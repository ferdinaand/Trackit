class Profile {
  final String email;
  final String firstname;
  final String lastname;
  final String phone;
  final double income;
  final String userId;

  Profile({
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.income,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'first_name': firstname,
      'last_name': lastname,
      'phone': phone,
      'Income': income,
      'id': userId
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      userId: map['id'] ?? '',
      email: map['email'] ?? '',
      firstname: map['first_name'] ?? '',
      lastname: map['last_name'] ?? '',
      phone: map['phone'] ?? '',
      income: (map['Income'] is int)
          ? (map['Income'] as int).toDouble()
          : (map['Income'] ?? 0.0) as double,
    );
  }
}
