class User {
  final String userId;
  final String name;
  final String phone;
  final String userType; // "DRIVER" or "CUSTOMER"
  final int maxDistance;

  User({
    required this.userId,
    required this.name,
    required this.phone,
    required this.userType,
    required this.maxDistance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      name: json['name'],
      phone: json['phone'],
      userType: json['userType'],
      maxDistance: json['maxDistance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'phone': phone,
      'userType': userType,
      'maxDistance': maxDistance,
    };
  }
}
