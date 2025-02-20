class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final DateTime createdAt;
  final String? photoUrl;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'role': role,
    'createdAt': createdAt.toIso8601String(),
    'photoUrl': photoUrl,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    role: json['role'],
    createdAt: DateTime.parse(json['createdAt']),
    photoUrl: json['photoUrl'],
  );
}