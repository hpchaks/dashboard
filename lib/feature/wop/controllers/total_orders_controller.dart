import 'package:get/get.dart';
import 'package:dashboard/feature/wop/data/order_data.dart';
import 'package:dashboard/feature/wop/models/order_model.dart';
import 'package:dashboard/feature/wop/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';

class TotalOrdersController extends GetxController {
  // Reactive Filter State
  var searchQuery = ''.obs;
  var selectedStatus = 'Total Order'.obs;
  var selectedCylinder = 'All Cylinders'.obs;
  var selectedSort = 'Sort'.obs;

  // Selected Order State (Merged from PlanningController)
  final Rx<Order?> selectedOrder = Rx<Order?>(null);

  // Factor Completion States
  var isFactor1Complete = false.obs; // Capacity
  var isFactor2Complete = false.obs; // Cylinder
  var isFactor3Complete = false.obs; // Raw Material
  var isFactor4Complete = false.obs; // Production Issues
  var isFactor5Complete = false.obs; // Delivery Date
  var isFactor3Waiting = false.obs; // Raw Material Waiting
  var hasFactor4Issue = false.obs; // Production Issue
  var factor4Remark = ''.obs;
  var expandedFactorIndex = 1.obs;
  var viewingFactorIndex = 0.obs; // 0 = List, 1-5 = Specific Factor Detail

  Order get currentOrder => selectedOrder.value!;

  // Status List from User Request
  final Map<String, String> statusIcons = {
    'Pending Planning': '🆕',
    'Due': '⚠️',
    'Not Due': '⏳',
    'In Production': '⚙️',
    'Delivered': '✔️',
    'Hold/Stuck': '🛑',
    'Achievable': '🎯',
    'Not Achievable': '❌',
    'Delivery Due': '🚚',
    'Capacity': '🏭',
  };

  List<String> get statusList => ['Total Order', ...statusIcons.keys];

  List<String> get cylinderList => ['All Cylinders', 'OP(Customer)', 'Vadilal'];

  List<String> get sortList => [
    'Sort',
    'Sort by Delivery Date',
    'Sort by Order Date',
    'Sort by Production Days',
  ];

  // Date Filter
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  var dateFrom = Rx<DateTime?>(null);
  var dateTo = Rx<DateTime?>(null);

  void selectDate(DateTime date) {
    selectedDate.value = date;
    dateFrom.value = null; // Clear range if single date selected
    dateTo.value = null;
  }

  void setDateRange(DateTime? from, DateTime? to) {
    dateFrom.value = from;
    dateTo.value = to;
    selectedDate.value = null; // Clear single date if range selected
  }

  void clearDate() {
    selectedDate.value = null;
    dateFrom.value = null;
    dateTo.value = null;
  }

  // Refresh trigger to force update when external data changes
  final _refreshTrigger = 0.obs;

  void refreshOrders() {
    _refreshTrigger.value++;
  }

  void selectOrder(Order order) {
    selectedOrder.value = order;
    _initializePlanningState();
  }

  void _initializePlanningState() {
    if (selectedOrder.value == null) return;

    // Basic initialization based on Order status
    final order = selectedOrder.value!;
    final status = order.status; // Use fresh status

    // Reset all first
    isFactor1Complete.value = false;
    isFactor2Complete.value = false;
    isFactor3Complete.value = false;
    isFactor4Complete.value = false;
    hasFactor4Issue.value = false;
    factor4Remark.value = '';
    isFactor5Complete.value = false;
    expandedFactorIndex.value = 1;
    viewingFactorIndex.value = 0;

    // Auto-complete previous factors if order is already planned or in production
    if (status == 'In Production') {
      isFactor1Complete.value = true;
      isFactor2Complete.value = true;
      isFactor3Complete.value = true;
      expandedFactorIndex.value = 4;
    }

    // Factor 2: Cylinder logic based on status
    if (status != 'In Production' &&
        (order.status == 'Waiting for Cylinders' ||
            order.cylinderType.contains('OP'))) {
      isFactor2Complete.value = false;
    }

    // Factor 3: Raw Material logic
    if (order.id == 'SO-PEND-1' || order.status == 'Waiting for Raw Material') {
      isFactor3Complete.value = false;
    }
    // Factor 4: Initialize from persistent order data
  }

  void setProductionIssue(bool hasIssue, String remark) {
    hasFactor4Issue.value = hasIssue;
    factor4Remark.value = remark;
    if (hasIssue) {
      isFactor4Complete.value = false; // Issue -> Not Complete (Red/Orange)
    } else {
      isFactor4Complete.value = true; // No Issue -> Complete (Green)
    }
  }

  void planOrder() {
    if (selectedOrder.value == null) return;
    final order = selectedOrder.value!;
    final dashboardController = Get.find<DashboardController>();

    // 1. Update status
    dashboardController.updateOrderStatus(order.id, 'In Production');

    // 2. IMPORTANT: Clear preloaded state so the list can re-filter and show other orders
    clearPreloadedOrders();
    refreshOrders();

    // 3. Show success dialog
    Get.defaultDialog(
      title: "Success",
      middleText: "Order ${order.id} moved to Production successfully!",
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
      radius: 12,
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(); // Close dialog
          Get.back(); // Close Detail screen (since we push it with Get.to)

          // Clear states after returning
          selectedOrder.value = null;
          viewingFactorIndex.value = 0;
          expandedFactorIndex.value = 1;
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("OK", style: TextStyle(color: Colors.white)),
      ),
      barrierDismissible: false,
    );
  }

  void completeProduction() {
    if (selectedOrder.value == null) return;
    final order = selectedOrder.value!;
    final dashboardController = Get.find<DashboardController>();

    // 1. Update status to Delivered
    dashboardController.updateOrderStatus(
      order.id,
      'Delivered',
      newDeliveryDate: dashboardController.today,
    );

    // 2. Refresh list
    clearPreloadedOrders();
    refreshOrders();

    // 3. Show success dialog
    Get.defaultDialog(
      title: "Order Finalized",
      middleText: "Order ${order.id} has been marked as Delivered!",
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(
        color: Colors.indigo,
        fontWeight: FontWeight.bold,
      ),
      radius: 12,
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(); // Close dialog
          Get.back(); // Close Detail screen

          // Clear selection
          selectedOrder.value = null;
          viewingFactorIndex.value = 0;
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("OK", style: TextStyle(color: Colors.white)),
      ),
      barrierDismissible: false,
    );
  }

  // Preloaded orders for direct navigation (Timeline drill-down)
  final RxList<Order> preloadedOrders = <Order>[].obs;

  void setPreloadedOrders(List<Order> orders) {
    preloadedOrders.assignAll(orders);
    // Note: We deliberately do NOT change 'selectedStatus' or 'dateFrom/To' here
    // because we want the UI to reflect a "Special Selection" rather than a filter combo.
    // But we might need to clear them UI-wise or the controller will re-filter?
    // filteredOrders below checks 'preloadedOrders' first, so it bypasses filters entirely.
    // However, clean UI state is good:

    // selectedStatus.value = 'Total Order'; // REMOVED to allow context preservation
    selectedCylinder.value = 'All Cylinders';
    dateFrom.value = null;
    dateTo.value = null;
    selectedDate.value = null;
  }

  void clearPreloadedOrders() {
    preloadedOrders.clear();
  }

  // Computed Filtered Orders
  List<Order> get filteredOrders {
    _refreshTrigger.value; // Depend on trigger

    // Determine the base list: Preloaded Orders from timeline OR the full Sample Dataset
    List<Order> baseOrders;
    if (preloadedOrders.isNotEmpty) {
      // Always get the latest data from sampleOrders even for preloaded list
      baseOrders = preloadedOrders.map((po) {
        return sampleOrders.firstWhere(
          (so) => so.id == po.id,
          orElse: () => po,
        );
      }).toList();
    } else {
      baseOrders = List.from(sampleOrders);
    }

    List<Order> orders = baseOrders;
    bool skipDateFilter = false;

    // 1. Search Filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      orders = orders.where((o) {
        return o.customer.toLowerCase().contains(query) ||
            o.id.toLowerCase().contains(query) ||
            o.gasType.toLowerCase().contains(query);
      }).toList();
    }

    // 2. Status Filter
    if (selectedStatus.value != 'Total Order') {
      final status = selectedStatus.value;

      // SMART SIMULATION LOGIC: If looking for Production/Capacity on a specific date,
      // we MUST use the simulation engine to catch backlog/overflow orders.
      if ((status == 'In Production' || status == 'Capacity') &&
          selectedDate.value != null &&
          preloadedOrders.isEmpty) {
        final dashboardController = Get.find<DashboardController>();
        // Calculate simulation for the selected day
        final simData = dashboardController.getTimelineDetailedOrders([
          selectedDate.value!,
        ]);
        final dateKey =
            "${selectedDate.value!.year}-${selectedDate.value!.month}-${selectedDate.value!.day}";

        if (status == 'Capacity') {
          orders = simData['${dateKey}_Capacity'] ?? [];
        } else {
          orders = simData['${dateKey}_Production'] ?? [];
        }
        skipDateFilter = true;
      } else {
        // Normal status filtering for other cases
        if (status == 'Capacity' ||
            status == 'Achievable' ||
            status == 'Not Achievable') {
          orders = orders.where((o) => o.customBadge == status).toList();
        } else if (status == 'Due') {
          orders = orders.where((o) => o.status == 'Due').toList();
          // We still skip date filter for 'Due' as it's an alert status
          skipDateFilter = true;
        } else if (status == 'Delivery Due') {
          orders = orders.where((o) => o.status == 'Delivery Due').toList();
          skipDateFilter = true;
        } else {
          orders = orders.where((o) => o.status == status).toList();
        }
      }
    }

    // 3. Cylinder Filter
    if (selectedCylinder.value != 'All Cylinders') {
      final selected = selectedCylinder.value;
      if (selected == 'OP(Customer)') {
        orders = orders
            .where(
              (o) => o.cylinderType == 'OP' || o.cylinderType == 'OP(Customer)',
            )
            .toList();
      } else if (selected == 'Vadilal') {
        orders = orders
            .where((o) => o.cylinderType.toLowerCase().contains('vadilal'))
            .toList();
      }
    }

    // 4. Date Filter
    // CRITICAL FIX: If preloadedOrders is present (from timeline drill-down),
    // we do NOT apply the date filter. This is because backlog orders
    // might have an 'orderDate' from the past, and filtering by 'selectedDate'
    // would hide them.
    if (preloadedOrders.isEmpty && !skipDateFilter) {
      if ((dateFrom.value != null && dateTo.value != null) ||
          selectedDate.value != null) {
        final start = (dateFrom.value ?? selectedDate.value!).subtract(
          const Duration(days: 1),
        );
        final end = (dateTo.value ?? selectedDate.value!).add(
          const Duration(days: 1),
        );

        final status = selectedStatus.value;

        orders = orders.where((o) {
          // SMART LOGIC: Use relevant date based on status
          if (status == 'Delivered') {
            return o.deliveryDate.isAfter(start) &&
                o.deliveryDate.isBefore(end);
          } else if (status == 'Planned' ||
              status == 'In Production' ||
              status == 'Capacity') {
            final date = o.plannedStart ?? o.orderDate;
            return date.isAfter(start) && date.isBefore(end);
          } else if (status == 'Due' || status == 'Delivery Due') {
            // Always show Due orders regardless of date filter (Global Alert)
            return true;
          } else if (status == 'Achievable' || status == 'Not Achievable') {
            return o.deliveryDate.isAfter(start) &&
                o.deliveryDate.isBefore(end);
          } else {
            // "All Status": Show order if ANY of its key dates match the selected date/range
            final d1match =
                o.orderDate.isAfter(start) && o.orderDate.isBefore(end);
            final d2match =
                o.plannedStart != null &&
                o.plannedStart!.isAfter(start) &&
                o.plannedStart!.isBefore(end);
            final d3match =
                o.deliveryDate.isAfter(start) && o.deliveryDate.isBefore(end);

            if (d1match || d2match || d3match) return true;

            // Also check if this order is active in the production simulation for this date
            if (selectedDate.value != null &&
                o.status == 'In Production' &&
                preloadedOrders.isEmpty) {
              final dashboardController = Get.find<DashboardController>();
              final simData = dashboardController.getTimelineDetailedOrders([
                selectedDate.value!,
              ]);
              final dateKey =
                  "${selectedDate.value!.year}-${selectedDate.value!.month}-${selectedDate.value!.day}";
              final prodOrders = simData['${dateKey}_Production'] ?? [];
              return prodOrders.any((po) => po.id == o.id);
            }

            return false;
          }
        }).toList();
      }
    }

    // 5. Sorting
    switch (selectedSort.value) {
      case 'Sort by Delivery Date':
        orders.sort((a, b) => a.deliveryDate.compareTo(b.deliveryDate));
        break;
      case 'Sort by Order Date':
        orders.sort((a, b) => a.orderDate.compareTo(b.orderDate));
        break;
      case 'Sort by Production Days':
        orders.sort((a, b) => a.productionDays.compareTo(b.productionDays));
        break;
    }

    return orders;
  }

  List<Order> getOrders() {
    return filteredOrders;
  }
}
