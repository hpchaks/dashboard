import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dashboard/feature/wop/data/order_data.dart';
import 'package:dashboard/feature/wop/models/order_model.dart';
import 'package:dashboard/feature/wop/controllers/total_orders_controller.dart';

class DashboardController extends GetxController {
  // State
  var dateFrom = DateTime(2026, 1, 20).obs;
  var dateTo = DateTime(2026, 1, 27).obs;
  var quickFilter = 'this week'.obs;
  var currentWeekStart = DateTime(2026, 1, 20).obs;
  var selectedStatus = RxnString();

  // Constants
  final DateTime today = DateTime(2026, 1, 22);

  // Refresh trigger for metrics
  final _metricsRefresh = 0.obs;

  // Computed Metrics
  Map<String, int> get metrics {
    _metricsRefresh.value; // Depend on this

    final start = dateFrom.value.subtract(const Duration(days: 1));
    final end = dateTo.value.add(const Duration(days: 1));

    // Base collection for counts that strictly follow order placement date (e.g. Total, Pending)
    final ordersPlacedInRange = sampleOrders.where((o) {
      return o.orderDate.isAfter(start) && o.orderDate.isBefore(end);
    }).toList();

    final totalOrders = ordersPlacedInRange.length;
    final uniqueCustomers = ordersPlacedInRange
        .map((o) => o.customer)
        .toSet()
        .length;

    // --- SMART COUNTS (Filter by relevant action date, not placement date) ---

    // 1. In Production: Count orders where PLANNED START is within range
    final inProduction = sampleOrders.where((o) {
      if (o.status != 'In Production' || o.plannedStart == null) return false;
      return o.plannedStart!.isAfter(start) && o.plannedStart!.isBefore(end);
    }).length;

    // 2. Delivered: Count orders where DELIVERY DATE is within range
    final delivered = sampleOrders.where((o) {
      if (o.status != 'Delivered') return false;
      return o.deliveryDate.isAfter(start) && o.deliveryDate.isBefore(end);
    }).length;

    // 3. Due: Now we separate "Delivery Due" from generic "Due"
    // User requested "Due" -> "Delivery Due" (Achievable/Not Achievable)
    final deliveryDueOrders = sampleOrders.where((o) {
      return o.status == 'Due' || o.status == 'Delivery Due';
    }).toList();

    final deliveryDue = deliveryDueOrders.length;

    final achievable = deliveryDueOrders
        .where((o) => o.customBadge == 'Achievable')
        .length;

    final notAchievable = deliveryDueOrders
        .where(
          (o) =>
              o.customBadge == 'Not Achievable' ||
              o.customBadge == 'not Achievable',
        )
        .length;

    // "Due" is now treated as 0 or strictly those WITHOUT the special attributes if we wanted,
    // but based on the request "remove from due", we set due to 0 for the generic bucket.
    const due = 0;

    // 4. Planned: Count orders where PLANNED START is within range
    final planned = sampleOrders.where((o) {
      if (o.plannedStart == null) return false;
      return o.plannedStart!.isAfter(start) && o.plannedStart!.isBefore(end);
    }).length;

    // 5. Pending Planning: Count ALL orders marked as Pending Planning within the date range
    final pending = sampleOrders.where((o) {
      if (o.status != 'Pending Planning') return false;
      return o.orderDate.isAfter(start) && o.orderDate.isBefore(end);
    }).length;

    // 6. Hold/Stuck
    final holdStuck = ordersPlacedInRange
        .where((o) => o.status == 'Hold/Stuck')
        .length;

    final notDue = ordersPlacedInRange
        .where((o) => o.status == 'Not Due')
        .length;

    return {
      'totalOrders': totalOrders,
      'uniqueCustomers': uniqueCustomers,
      'planned': planned,
      'pending': pending,
      'inProduction': inProduction,
      'due': due, // Now 0
      'deliveryDue': deliveryDue, // New Total
      'achievable': achievable, // New Breakdown
      'notAchievable': notAchievable, // New Breakdown
      'delivered': delivered,
      'notDue': notDue,
      'holdStuck': holdStuck,
      'readyToPlan': pending,
    };
  }

  // Week Dates
  List<DateTime> get weekDates {
    return List.generate(7, (i) {
      return currentWeekStart.value.add(Duration(days: i));
    });
  }

  // Orders By Date
  Map<String, List<Order>> get ordersByDate {
    final Map<String, List<Order>> grouped = {};

    final ordersToShow = selectedStatus.value != null
        ? sampleOrders.where((o) => o.status == selectedStatus.value).toList()
        : sampleOrders;

    for (var order in ordersToShow) {
      if (order.plannedStart != null) {
        final dateKey = DateFormat('yyyy-MM-dd').format(order.plannedStart!);
        if (!grouped.containsKey(dateKey)) {
          grouped[dateKey] = [];
        }
        grouped[dateKey]!.add(order);
      }
    }
    return grouped;
  }

  // Actions
  void handleQuickFilter(String filter) {
    quickFilter.value = filter;

    if (filter == 'this week') {
      final weekStart = today.subtract(Duration(days: today.weekday % 7));
      currentWeekStart.value = weekStart;
      dateFrom.value = weekStart;
      dateTo.value = weekStart.add(const Duration(days: 6));
    } else if (filter == 'this month') {
      final monthStart = DateTime(today.year, today.month, 1);
      dateFrom.value = monthStart;
      final monthEnd = DateTime(today.year, today.month + 1, 0);
      dateTo.value = monthEnd;
    } else if (filter == 'this year') {
      dateFrom.value = DateTime(2026, 1, 1);
      dateTo.value = DateTime(2026, 12, 31);
    }
  }

  void navigateWeek(int direction) {
    currentWeekStart.value = currentWeekStart.value.add(
      Duration(days: direction * 7),
    );
  }

  void updateDateRange(DateTime? from, DateTime? to) {
    if (from != null) dateFrom.value = from;
    if (to != null) dateTo.value = to;
  }

  // Calculate detailed order lists for timeline interactivity
  // Calculate detailed order lists for timeline interactivity
  Map<String, List<Order>> getTimelineDetailedOrders(List<DateTime> weekDates) {
    if (weekDates.isEmpty) return {};

    var relevantOrders = sampleOrders
        .where(
          (o) =>
              o.plannedStart != null &&
              o.status != 'Due' &&
              o.status != 'Delivery Due' &&
              o.status != 'Delivered' &&
              o.status != 'Hold/Stuck',
        )
        .toList();
    relevantOrders.sort((a, b) => a.plannedStart!.compareTo(b.plannedStart!));

    // To ensure backlog is accurate, we calculate from the start of the simulation (Jan 1, 2026)
    // up to the last date in the requested week.
    final DateTime startOfSimulation = DateTime(2026, 1, 1);
    final DateTime endOfRequestedWeek = weekDates.last;

    // Generate all dates from start to end
    List<DateTime> allDates = [];
    DateTime current = startOfSimulation;
    while (!current.isAfter(endOfRequestedWeek)) {
      allDates.add(current);
      current = current.add(const Duration(days: 1));
    }

    const int dailyCapacity = 10;
    List<Order> backlogOrders = [];
    Map<String, List<Order>> result = {};

    for (var date in allDates) {
      final dateKey = "${date.year}-${date.month}-${date.day}";

      // 1. Incoming Orders for this specific date
      List<Order> incoming = relevantOrders
          .where(
            (o) =>
                o.plannedStart!.year == date.year &&
                o.plannedStart!.month == date.month &&
                o.plannedStart!.day == date.day,
          )
          .toList();

      // 2. Total Pool = Incoming + Backlog
      List<Order> totalPool = [...incoming, ...backlogOrders];

      // 3. Processed (Capacity) = First 10
      List<Order> processed = [];
      List<Order> newBacklog = [];

      if (totalPool.length > dailyCapacity) {
        processed = totalPool
            .take(dailyCapacity)
            .map((o) => o.copyWith(customBadge: 'Capacity'))
            .toList();
        newBacklog = totalPool.skip(dailyCapacity).toList();
      } else {
        processed = totalPool
            .map((o) => o.copyWith(customBadge: 'Capacity'))
            .toList();
        newBacklog = [];
      }

      // 4. Update Backlog for next iteration
      backlogOrders = newBacklog;

      // 5. Store in result map ONLY if it's within our requested Dates or if we need to see it
      // For now, store everything to be safe, or just the requested weekDates
      result['${dateKey}_Production'] = totalPool;
      result['${dateKey}_Capacity'] = processed;

      // 6. Other Status Lists (Only if in sampleOrders for this date)
      // Note: These don't have backlog logic in current simulation
      result['${dateKey}_Due'] = sampleOrders
          .where(
            (o) =>
                (o.status == 'Due' || o.status == 'Delivery Due') &&
                o.deliveryDate.year == date.year &&
                o.deliveryDate.month == date.month &&
                o.deliveryDate.day == date.day,
          )
          .toList();

      result['${dateKey}_Achievable'] = result['${dateKey}_Due']!
          .where((o) => o.customBadge == 'Achievable')
          .toList();

      result['${dateKey}_NotAchievable'] = result['${dateKey}_Due']!
          .where(
            (o) =>
                o.customBadge == 'Not Achievable' ||
                o.customBadge == 'not Achievable',
          )
          .toList();

      result['${dateKey}_Delivered'] = sampleOrders
          .where(
            (o) =>
                o.status == 'Delivered' &&
                o.deliveryDate.year == date.year &&
                o.deliveryDate.month == date.month &&
                o.deliveryDate.day == date.day,
          )
          .toList();
    }

    return result;
  }

  // Calculate daily production and capacity with spill-over logic
  Map<String, Map<String, int>> calculateDailyProductionLoad(
    List<DateTime> weekDates,
  ) {
    if (weekDates.isEmpty) return {};

    var relevantOrders = sampleOrders
        .where(
          (o) =>
              o.plannedStart != null &&
              o.status != 'Due' &&
              o.status != 'Delivery Due' &&
              o.status != 'Delivered' &&
              o.status != 'Hold/Stuck',
        )
        .toList();
    relevantOrders.sort((a, b) => a.plannedStart!.compareTo(b.plannedStart!));

    // Simulation starts from Jan 1st for accurate backlog numbers
    final DateTime startOfSimulation = DateTime(2026, 1, 1);
    final DateTime maxDate = weekDates.last;

    List<DateTime> allDates = [];
    DateTime current = startOfSimulation;
    while (!current.isAfter(maxDate)) {
      allDates.add(current);
      current = current.add(const Duration(days: 1));
    }

    const int dailyCapacity = 10;
    int backlog = 0;
    Map<String, Map<String, int>> result = {};

    for (var date in allDates) {
      final dateKey = "${date.year}-${date.month}-${date.day}";

      int incoming = relevantOrders
          .where(
            (o) =>
                o.plannedStart!.year == date.year &&
                o.plannedStart!.month == date.month &&
                o.plannedStart!.day == date.day,
          )
          .fold(0, (sum, o) => sum + o.quantity);

      int totalLoad = incoming + backlog;
      int processed = totalLoad > dailyCapacity ? dailyCapacity : totalLoad;
      backlog = totalLoad - processed;

      result[dateKey] = {'production': totalLoad, 'capacity': processed};
    }

    return result;
  }

  void setSelectedStatus(String? status) {
    selectedStatus.value = status;
  }

  void updateOrderStatus(
    String orderId,
    String newStatus, {
    DateTime? newDeliveryDate,
    String? productionIssueRemark,
  }) {
    // Note: sampleOrders is a global list in order_data.dart, but we need to trigger UI updates.
    // Ideally, sampleOrders should be an RxList in this controller.
    // For now, we'll iterate and update (assuming mutable Order is acceptable or we replace it).
    // Since Order fields are final, we replace the object.

    final index = sampleOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final oldOrder = sampleOrders[index];
      // Create new order with updated status
      final newOrder = Order(
        id: oldOrder.id,
        customer: oldOrder.customer,
        gasType: oldOrder.gasType,
        quantity: oldOrder.quantity,
        cylinderType: oldOrder.cylinderType,
        orderDate: oldOrder.orderDate,
        deliveryDate: newDeliveryDate ?? oldOrder.deliveryDate,
        productionDays: oldOrder.productionDays,
        status: newStatus,
        plannedStart: newStatus == 'In Production'
            ? today
            : oldOrder.plannedStart,
        priority: oldOrder.priority,
        proportion: oldOrder.proportion,
        customBadge: oldOrder.customBadge,
        productionIssueRemark:
            productionIssueRemark ?? oldOrder.productionIssueRemark,
      );

      sampleOrders[index] = newOrder;

      // Notify all listeners and controllers
      forceRefreshAll();
    }
  }

  void forceRefreshAll() {
    // 1. Refresh internal metrics (Obx)
    _metricsRefresh.value++;

    // 2. Trigger GetBuilder updates if any
    update();

    // 3. Force rebuild of filtered lists by "touching" observables
    final currentStatus = selectedStatus.value;
    selectedStatus.value = 'TEMP';
    selectedStatus.value = currentStatus;

    // 4. Refresh external controllers
    if (Get.isRegistered<TotalOrdersController>()) {
      Get.find<TotalOrdersController>().refreshOrders();
    }
  }
}
