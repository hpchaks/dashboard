class Order {
  final String id;
  final String customer;
  final String gasType;
  final int quantity;
  final String cylinderType;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final int productionDays;
  final String status;
  final DateTime? plannedStart;
  final String priority;
  final String proportion;
  final String? customBadge; // For Capacity, Achievable, Not Achievable badges
  final String? productionIssueRemark;

  Order({
    required this.id,
    required this.customer,
    required this.gasType,
    required this.quantity,
    required this.cylinderType,
    required this.orderDate,
    required this.deliveryDate,
    required this.productionDays,
    required this.status,
    this.plannedStart,
    required this.priority,
    this.proportion = '',
    this.customBadge,
    this.productionIssueRemark,
  });

  Order copyWith({
    String? customBadge,
    String? status,
    String? productionIssueRemark,
  }) {
    return Order(
      id: id,
      customer: customer,
      gasType: gasType,
      quantity: quantity,
      cylinderType: cylinderType,
      orderDate: orderDate,
      deliveryDate: deliveryDate,
      productionDays: productionDays,
      status: status ?? this.status,
      plannedStart: plannedStart,
      priority: priority,
      proportion: proportion,
      customBadge: customBadge ?? this.customBadge,
      productionIssueRemark:
          productionIssueRemark ?? this.productionIssueRemark,
    );
  }
}
