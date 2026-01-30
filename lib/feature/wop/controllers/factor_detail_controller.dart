import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dashboard/feature/wop/models/order_model.dart';
import 'package:dashboard/feature/wop/controllers/total_orders_controller.dart';
import 'package:dashboard/feature/wop/controllers/dashboard_controller.dart';

class FactorDetailController extends GetxController {
  final TotalOrdersController totalOrdersController;
  final VoidCallback? onProcessed;

  FactorDetailController({
    required this.totalOrdersController,
    this.onProcessed,
  });

  Order get order => totalOrdersController.currentOrder;

  // Factor 1: Capacity State
  var totalDailyCapacity = 10.obs;
  var currentDailyUsage = 10.obs;
  var selectedDate = DateTime(2026, 1, 22).obs;
  var capacityLabel = 'Today Capacity'.obs;

  var proportionMaxCapacity = 3.obs;
  var proportionCurrentUsage = 1.obs;

  // Factor 2: Cylinder State
  var cylinderStatus = 'Pending Inspection'.obs;
  var isQAApproved = false.obs;
  var isSentForQA = false.obs;
  var availableStockCount = 0.obs;
  var allocatedCylinders = 0.obs;
  var inputAllocationCount = 0.obs;
  var hasAddedToWaitingList = false.obs;
  var isStockAvailable = false.obs;
  var isQAFailed = false.obs;
  var isStockChecked = false.obs;

  // Factor 5: Logistics Issue State
  final hasFactor5Issue = false.obs;
  final factor5Remark = "".obs;
  final isNoIssueSelected = false.obs;

  RxBool get isFactor4Complete => totalOrdersController.isFactor4Complete;

  var qaChecklist = <String, bool>{'C7': false, 'C8': false, 'C9': false}.obs;

  final Map<String, String> checklistLabels = {
    'C7': 'Initial Visual & Surface Check',
    'C8': 'Valve & Thread Inspection',
    'C9': 'Internal Contamination & Weight Check',
  };

  // @override
  void unusedInit() {
    // super.onInit();
    _initializeState();
  }

  void _initializeState() {
    final status = totalOrdersController.currentOrder.status; // Use live status
    if (status == 'In Production') {
      // Force "Green" / Completed state for all factors

      // Factor 2
      isSentForQA.value = true;
      isQAApproved.value = true;
      cylinderStatus.value = 'QA Approved';
      qaChecklist.updateAll((key, value) => true);
      isStockChecked.value = true;
      isStockAvailable.value = true;
      availableStockCount.value = order.quantity; // Assume full stock

      // Factor 3
      isRawMaterialAvailable.value = true;
      // Also update statuses in list?
      for (var item in rawMaterialItems) {
        item['status'] = 'Available';
        item['stock'] = item['req']; // Mock full stock
      }
    }
    isNoIssueSelected.value = false;
  }

  bool get isAtLeastOneCheckedUnused => qaChecklist.containsValue(true);

  // Factor 3: Raw Material State
  var isRawMaterialAvailable = true.obs;
  var indentGenerated = false.obs;
  var rawMaterialStatus = 'Checking Stock...'.obs;
  var expectedMaterialArrivalDate = ''.obs;
  var adjustedDeliveryDate = ''.obs;
  var isMaterialWaiting = false.obs;

  final RxList<Map<String, dynamic>> rawMaterialItems = [
    {
      'name': 'Gas Component A',
      'req': '50kg',
      'stock': '55kg',
      'status': 'In Stock',
    },
    {
      'name': 'Gas Component B',
      'req': '50kg',
      'stock': '30kg',
      'status': 'Shortage',
    },
    {
      'name': 'Chemical Additive X',
      'req': '5L',
      'stock': '6L',
      'status': 'In Stock',
    },
  ].obs;

  bool get checkDirectAvailability =>
      rawMaterialItems.every((item) => item['status'] == 'In Stock');

  @override
  void onInit() {
    super.onInit();
    // Defer initialization to avoid setState during build error
    Future.microtask(() => _initializeDetailState());
  }

  void _initializeDetailState() {
    final status = totalOrdersController.currentOrder.status;
    if (status == 'In Production') {
      // Force "Green" / Completed state for all factors

      // Factor 2
      isSentForQA.value = true;
      isQAApproved.value = true;
      cylinderStatus.value = 'QA Approved';
      qaChecklist.updateAll((key, value) => true);
      isStockChecked.value = true;
      isStockAvailable.value = true;
      availableStockCount.value = order.quantity; // Assume full stock

      // Factor 3
      isRawMaterialAvailable.value = true;
      // Also update statuses in list?
      for (var item in rawMaterialItems) {
        item['status'] = 'Available';
        item['stock'] = item['req']; // Mock full stock
      }
    }

    // Factor 1: Set proportion limits based on Gas Type
    if (order.gasType.contains('X')) {
      proportionMaxCapacity.value = 3;
    } else if (order.gasType.contains('Y')) {
      proportionMaxCapacity.value = 5;
    } else if (order.gasType.contains('Z')) {
      proportionMaxCapacity.value = 7;
    } else {
      proportionMaxCapacity.value = 4; // Default
    }

    // Auto-check Vadilal availability if applicable
    if (order.cylinderType.toLowerCase().contains('vadilal')) {
      checkVadilalAvailability();
    }

    // Factor 2: Cylinder logic based on status
    // Factor 2: Cylinder logic based on status
    if (status != 'In Production') {
      if (order.status == 'Waiting for Cylinders') {
        cylinderStatus.value = 'Awaiting QA Inspection';
        isQAApproved.value = false;
        isSentForQA.value = true;
        isStockAvailable.value = false;
        totalOrdersController.isFactor2Complete.value = false;
      } else if (order.cylinderType.contains('OP')) {
        cylinderStatus.value = 'QA Pending (Initial Check)';
        isQAApproved.value = false;
        totalOrdersController.isFactor2Complete.value = false;
      } else {
        isStockChecked.value = false;
        cylinderStatus.value = 'Stock Check Required (System Tracked)';
        // DEMO: For PEND-2, we simulate 0 stock to show waiting list logic
        if (order.id == 'PEND-2') {
          availableStockCount.value = 0;
        } else {
          availableStockCount.value = 500; // Set to 500 for full stock testing
        }
        inputAllocationCount.value = 0; // Initialize to zero
        totalOrdersController.isFactor2Complete.value = false;
      }
    }

    // Factor 3: Initial material check
    if (order.id == 'PEND-1') {
      // DEMO: For PEND-1, we simulate shortage to show Indent flow
      rawMaterialItems[1]['status'] = 'Shortage';
      isRawMaterialAvailable.value = false;
    } else {
      // All others have full stock by default
      for (var item in rawMaterialItems) {
        item['status'] = 'In Stock';
      }
      isRawMaterialAvailable.value = true;
    }

    // totalOrdersController.isFactor3Complete.value = isRawMaterialAvailable.value; // Manual check required

    // Factor 1: Initial values for Jan 22
    updateCapacityForDate(22);
  }

  // Helper to get usage for a specific date for UI cards
  int getUsageForDate(DateTime date) {
    // Hardcoded logic for Jan 22 start as per current demo flow
    if (date.year == 2026 && date.month == 1) {
      if (date.day == 22) {
        return order.quantity >= 10 ? 10 : order.quantity;
      } else if (date.day == 23) {
        return (order.quantity > 10) ? (order.quantity - 10) : 0;
      }
    }
    return 0;
  }

  void updateCapacityForDate(int day) {
    selectedDate.value = DateTime(2026, 1, day);

    // Set Label
    if (day == 22) {
      capacityLabel.value = 'Today Capacity';
    } else {
      String suffix = 'th';
      if (day == 21 || day == 31) {
        suffix = 'st';
      } else if (day == 22)
        suffix = 'nd';
      else if (day == 23)
        suffix = 'rd';
      capacityLabel.value = '$day$suffix Capacity';
    }

    // Dynamic logic based on user request:
    // Daily capacity is 10.
    // Jan 22 takes first 10.
    // Jan 23 takes the remainder.

    if (day == 22) {
      currentDailyUsage.value = 10;
      totalDailyCapacity.value = 10;
      // Mock proportion usage based on order ID to keep it diverse
      proportionCurrentUsage.value = (order.id.hashCode % 3) + 1;
    } else if (day == 23) {
      int remainder = order.quantity - 10;
      currentDailyUsage.value = remainder > 0 ? remainder : 0;
      totalDailyCapacity.value = 10;
      proportionCurrentUsage.value = remainder > 0 ? 1 : 0;
    } else {
      currentDailyUsage.value = 0;
      totalDailyCapacity.value = 10;
      proportionCurrentUsage.value = 0;
    }
  }

  void toggleCheck(String key) {
    qaChecklist[key] = !(qaChecklist[key] ?? false);
  }

  bool get isAtLeastOneChecked => qaChecklist.values.any((checked) => checked);

  void sendForQA(BuildContext context) {
    if (isAtLeastOneChecked) {
      isSentForQA.value = true;
      isQAApproved.value = true; // Auto approve
      isQAFailed.value = false;
      cylinderStatus.value = 'QA Passed - Ready for Production';
      totalOrdersController.isFactor2Complete.value = true;

      Get.snackbar(
        'QA Approved',
        'Cylinder verified and approved successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      popOrFinish(context);
    }
  }

  void rejectForQA(BuildContext context) {
    // 1. Mark as failed in UI
    isQAApproved.value = false;
    isQAFailed.value = true;
    cylinderStatus.value = 'QA Failed - Waiting for QA';
    totalOrdersController.isFactor2Complete.value = false;

    // 2. Update the actual order status to 'Hold/Stuck' as it requires external action
    final dashboardController = Get.find<DashboardController>();
    dashboardController.updateOrderStatus(order.id, 'Hold/Stuck');

    // 3. Email Simulation (Sales & Customer)
    Get.snackbar(
      'QA Rejected',
      'Cylinders failed inspection. Status updated.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );

    // Secondary snackbar to show the email communication
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.snackbar(
        'Notifications Sent',
        'Email alerts sent to Sales & Customer regarding QA failure.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
        icon: const Icon(Icons.email, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    });

    popOrFinish(context);
  }

  void approveQA(BuildContext context) {
    isQAApproved.value = true;
    isQAFailed.value = false;
    cylinderStatus.value = 'QA Passed - Ready for Production';
    totalOrdersController.isFactor2Complete.value = true;

    Get.snackbar(
      'QA Approved',
      'Cylinders verified and approved.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    popOrFinish(context);
  }

  void failQA(String reason, BuildContext context) {
    isQAApproved.value = false;
    isQAFailed.value = true;
    cylinderStatus.value = 'QA Rejected: $reason';
    totalOrdersController.isFactor2Complete.value =
        false; // Rejected means not ready

    Get.snackbar(
      'QA Rejected',
      'Rejection logged: $reason',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    // User didn't explicitly say navigate back on reject, but usually we do to update status.
    // "Handle rejection...". Let's stay on screen to show red status OR back.
    // Given the flow "Screen should automatically navigate back" for Approve.
    // I'll assume Back for Reject too, or maybe stay to try again?
    // "Handle rejection based on reason" -> Maybe move to "Hold"?
    // I'll keep it simple: Status set, Snack bar shown.
    // The "Detailed Planning" screen should show Factor 2 as failed (Red).
    // I'll pop context to return to detailed planning list.
    popOrFinish(context);
  }

  // Vadilal Logic
  var isVadilalCylinderChecked = false.obs;
  var isVadilalCylinderAvailable = false.obs;

  void checkVadilalAvailability() {
    isVadilalCylinderChecked.value = true;
    isVadilalCylinderAvailable.value =
        false; // Simulating NOT available for demo
  }

  void moveOrderToWaitingForCylinders(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();
    dashboardController.updateOrderStatus(order.id, 'Waiting for Cylinders');

    Get.snackbar(
      'Status Updated',
      'Order moved to Waiting for Cylinders list.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
    popOrFinish(context);
  }

  void allocateCylinders(int count, BuildContext context) {
    allocatedCylinders.value = count;
    isStockChecked.value = true;

    final dashboardController = Get.find<DashboardController>();

    if (count >= order.quantity) {
      isStockAvailable.value = true;
      cylinderStatus.value = 'Reserved';
      totalOrdersController.isFactor2Complete.value = true;

      Get.snackbar(
        'Reserved',
        'All ${order.quantity} cylinders reserved successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      popOrFinish(context);
    } else {
      // Not Available / Partial
      isStockAvailable.value = false;
      int short = order.quantity - count;
      cylinderStatus.value = 'Waiting List ($short Shortage)';
      totalOrdersController.isFactor2Complete.value = false;

      // System wide status tracking
      dashboardController.updateOrderStatus(
        order.id,
        'Waiting for Cylinders (Stock)',
      );

      Get.snackbar(
        'Moved to Waiting',
        'Shortage detected. System marked this order as "Waiting for Cylinders".',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
      );
      popOrFinish(context);
    }
  }

  void selectMaterialOption(bool available, BuildContext context) {
    if (available) {
      isRawMaterialAvailable.value = true;
      rawMaterialStatus.value = 'Material Available - Ready';
      totalOrdersController.isFactor3Complete.value = true;
      Get.snackbar(
        'Success',
        'Raw material confirmed available.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      popOrFinish(context); // Auto "Done"
    } else {
      // Shortage / Generate Indent
      isRawMaterialAvailable.value = false;
      isMaterialWaiting.value = true;
      indentGenerated.value = true;
      rawMaterialStatus.value = 'Waiting List (Indent Generated)';

      // Update individual item statuses
      for (var item in rawMaterialItems) {
        if (item['status'] == 'Shortage') {
          item['status'] = 'Indent Generated';
        }
      }
      rawMaterialItems.refresh(); // Notify listeners

      // Mark factor as "Incomplete" (Stops the planning from being finished)
      totalOrdersController.isFactor3Complete.value = false;

      // REMOVED: Moving to waiting list.
      // The user wants it to STAY in 'Pending Planning' list.

      Get.snackbar(
        'Indent Generated',
        'Material indent generated. Order remains in planning queue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade900,
        colorText: Colors.white,
      );
      // Navigator.pop removed so user can see the UI change on the same screen
    }
  }

  void receiveMaterialStock(BuildContext context) {
    // 1. Reset states
    isMaterialWaiting.value = false;
    indentGenerated.value = false;
    isRawMaterialAvailable.value = true;
    rawMaterialStatus.value = 'Material Received - Ready for Planning';

    // 2. Update stock numbers to show replenishment (e.g., 55kg)
    for (var item in rawMaterialItems) {
      if (item['status'] == 'Indent Generated') {
        item['status'] = 'In Stock';
        item['stock'] = '55kg'; // Now exceeds requirements
      }
    }
    rawMaterialItems.refresh();

    // 3. Move order back to active list
    final dashboardController = Get.find<DashboardController>();
    dashboardController.updateOrderStatus(order.id, 'Pending Planning');

    Get.snackbar(
      'Stock Received',
      'Material inventory updated. Order moved back to Pending Planning.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  // Factor 4: Production Issues
  RxBool get hasProductionIssue => totalOrdersController.hasFactor4Issue;
  RxString get productionRemark => totalOrdersController.factor4Remark;
  Rx<DateTime?> expectedIssueDate = Rx<DateTime?>(null);

  void markFactor4Complete(
    bool complete, {
    String? remark,
    DateTime? expectedDate,
  }) {
    // If remark is present, it's an issue
    if (remark != null && remark.isNotEmpty) {
      totalOrdersController.setProductionIssue(true, remark);

      // Update persistent order model with the remark, but KEEP original status
      final dashboardController = Get.find<DashboardController>();
      dashboardController.updateOrderStatus(
        order.id,
        order.status, // KEEP original status (e.g., 'In Production')
        productionIssueRemark: remark,
      );

      // Simulate Email Notifications
      _simulateEmailNotifications(remark);

      Get.snackbar(
        'Issue Logged',
        'Remark saved. Notifications sent to Sales & Customer.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.indigo,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } else {
      // If complete is true (No Issues)
      if (complete) {
        totalOrdersController.setProductionIssue(false, '');
      } else {
        // Reset / Undo
        totalOrdersController.setProductionIssue(false, '');
        totalOrdersController.isFactor4Complete.value = false;
      }
    }
  }

  // Factor 5: Delivery
  var simulationDeliveryDate = DateTime.now().obs;

  void updateDeliveryDate(DateTime date) {
    simulationDeliveryDate.value = date;

    // Auto-verify if date is valid (e.g., in future)
    // For now we just accept any user input as a simulation
    if (date.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
      // logic if needed
    }
  }

  void logLogisticsIssue(String remark) {
    hasFactor5Issue.value = true;
    factor5Remark.value = remark;

    // Simulate Email Notifications
    _simulateEmailNotifications(remark, isLogistics: true);

    Get.snackbar(
      'Logistics Issue Logged',
      'Sales & Customer have been notified.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  void markDelivered(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();
    // Set delivery date to today so it hits the current week/month metric
    dashboardController.updateOrderStatus(
      order.id,
      'Delivered',
      newDeliveryDate: dashboardController.today,
    );
    totalOrdersController.isFactor5Complete.value = true;

    Get.snackbar(
      'Delivered',
      'Order has been marked as Delivered.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    popOrFinish(context);
  }

  void popOrFinish(BuildContext context) {
    if (onProcessed != null) {
      onProcessed!();
    } else {
      Navigator.pop(context);
    }
  }

  void _simulateEmailNotifications(String remark, {bool isLogistics = false}) {
    // This is a simulation of backend email triggers
    final issueType = isLogistics ? 'Logistics' : 'Production';
    debugPrint('--- NOTIFICATION SYSTEM ---');
    debugPrint('TO: Sales Team <sales@company.com>');
    debugPrint(
      'TO: Customer <${order.customer.toLowerCase().replaceAll(" ", ".")}@email.com>',
    );
    debugPrint('SUBJECT: $issueType Issue Logged - Order ${order.id}');
    debugPrint('REMARK: $remark');
    debugPrint('---------------------------');
  }
}
