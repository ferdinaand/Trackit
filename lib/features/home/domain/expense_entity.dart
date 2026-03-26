class Expense {
  final String title;
  final String category;
  final String description;
  final String createdAt;
  final double amount;
  final String userId;
  final String id;

  Expense({
    required this.title,
    required this.category,
    required this.description,
    required this.createdAt,
    required this.amount,
    required this.userId,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'user_id': userId,
      'category': category
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      userId: map['user_id'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['created_at'] ?? '',
      category: map['category'] ?? '',
      amount: (map['amount'] is int)
          ? (map['amount'] as int).toDouble()
          : (map['amount'] ?? 0.0) as double,
    );
  }
}
