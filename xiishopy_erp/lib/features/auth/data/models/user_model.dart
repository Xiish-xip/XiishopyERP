import 'package:equatable/equatable.dart';
import '../../../../core/constants/enums.dart';

/// User data model mapped from Firestore
class UserModel extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final UserRole role;
  final Country? country;
  final String? phone;
  final String? photoUrl;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.role = UserRole.retailer,
    this.country,
    this.phone,
    this.photoUrl,
    this.emailVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return UserModel(
      id: docId,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      role: UserRole.fromString(data['role'] as String? ?? 'retailer'),
      country: data['country'] != null ? Country.values.firstWhere(
        (c) => c.databaseValue == data['country'],
        orElse: () => Country.ke,
      ) : null,
      phone: data['phone'] as String?,
      photoUrl: data['photoUrl'] as String?,
      emailVerified: data['emailVerified'] as bool? ?? false,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'email': email,
    'displayName': displayName,
    'role': role.databaseValue,
    'country': country?.databaseValue,
    'phone': phone,
    'photoUrl': photoUrl,
    'emailVerified': emailVerified,
    'updatedAt': DateTime.now(),
  };

  UserModel copyWith({
    String? displayName,
    Country? country,
    String? phone,
    String? photoUrl,
  }) => UserModel(
    id: id,
    email: email,
    displayName: displayName ?? this.displayName,
    role: role,
    country: country ?? this.country,
    phone: phone ?? this.phone,
    photoUrl: photoUrl ?? this.photoUrl,
    emailVerified: emailVerified,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [id, email, displayName, role, country, phone, photoUrl, emailVerified];
}