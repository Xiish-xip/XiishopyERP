import 'package:equatable/equatable.dart';

/// Core user entity used throughout the app
/// Independent of Firebase/Firestore data layer
class AuthUserEntity extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String role;
  final String? country;
  final String? phone;
  final String? photoUrl;
  final bool emailVerified;

  const AuthUserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    this.role = 'retailer',
    this.country,
    this.phone,
    this.photoUrl,
    this.emailVerified = false,
  });

  bool get isDistributor => role == 'distributor';
  bool get isRetailer => role == 'retailer';
  bool get isAuthenticated => id.isNotEmpty;

  String get initials {
    final parts = displayName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
  }

  AuthUserEntity copyWith({
    String? displayName,
    String? country,
    String? phone,
    String? photoUrl,
    bool? emailVerified,
  }) => AuthUserEntity(
    id: id,
    email: email,
    displayName: displayName ?? this.displayName,
    role: role,
    country: country ?? this.country,
    phone: phone ?? this.phone,
    photoUrl: photoUrl ?? this.photoUrl,
    emailVerified: emailVerified ?? this.emailVerified,
  );

  @override
  List<Object?> get props => [id, email, displayName, role, country, phone, photoUrl, emailVerified];
}