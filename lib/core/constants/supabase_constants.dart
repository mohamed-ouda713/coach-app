import 'package:flutter_dotenv/flutter_dotenv.dart';

/// القيم الحساسة — جايّة من .env
class SupabaseConfig {
  SupabaseConfig._();

  static String get url => dotenv.env['SUPABASE_URL'] ?? '';
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
}

/// أسماء الجداول (Tables) بقاعدة البيانات
class SupabaseTables {
  SupabaseTables._();

  static const String trainers = 'trainers';
  static const String subscribers = 'subscribers';
  static const String measurements = 'measurements';
  static const String expenses = 'expenses';
  static const String partners = 'partners';
  static const String notifications = 'notifications';
}

/// أسماء الأعمدة (Columns)
class SupabaseColumns {
  SupabaseColumns._();

  static const String id = 'id';
  static const String trainerId = 'trainer_id';
  static const String subscriberId = 'subscriber_id';
  static const String fullName = 'full_name';
  static const String email = 'email';
  static const String age = 'age';
  static const String weight = 'weight';
  static const String height = 'height';
  static const String goal = 'goal';
  static const String program = 'program';
  static const String subscriptionStartDate = 'subscription_start_date';
  static const String subscriptionEndDate = 'subscription_end_date';
  static const String subscriptionFee = 'subscription_fee';
  static const String lastProgramUpdate = 'last_program_update';
  static const String note = 'note';
  static const String avatarUrl = 'avatar_url';
  static const String measurementMonth = 'measurement_month';
  static const String waistSize = 'waist_size';
  static const String abdomenSize = 'abdomen_size';
  static const String photoBeforeUrl = 'photo_before_url';
  static const String photoAfterUrl = 'photo_after_url';
  static const String amount = 'amount';
  static const String description = 'description';
  static const String date = 'date';
  static const String type = 'type';
  static const String message = 'message';
  static const String isRead = 'is_read';
  static const String createdAt = 'created_at';

  // ── Financial — partners (قسمة الربح) ─────────────────────
  static const String name = 'name';
  static const String sharePercentage = 'share_percentage';
}

/// أسماء الـ Storage Buckets
class SupabaseBuckets {
  SupabaseBuckets._();

  static const String measurementPhotos = 'measurement_photos';
  static const String profileAvatars = 'profile_avatars';
}

/// أسماء الـ RPC Functions (لسا مفيش عنا حاليًا)
class SupabaseFunctions {
  SupabaseFunctions._();
}