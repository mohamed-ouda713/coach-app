import 'package:glow_up/core/constants/auth_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String id;
  final String email;
  final String fullName;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
  });

  factory UserModel.fromSupabaseUser(User user) {
    final metadata = user.userMetadata;
    final name = metadata?[UserMetadataKeys.fullName] as String?;

    return UserModel(
      id: user.id,
      email: user.email ?? '',
      fullName: (name != null && name.trim().isNotEmpty) ? name.trim() : '-',
    );
  }

  String get displayEmail => email.isNotEmpty ? email : '-';
  String get displayName => fullName;
}
