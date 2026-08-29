import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import 'app_logger.dart';

/// بتصغّر صور القياسات قبل رفعها لـ Supabase Storage.
///
/// كاميرا أي موبايل حديث بتطلع صورة 4–8 ميجا، والقياس الواحد فيه
/// صورتين (قبل/بعد) — يعني رفع لحد 16 ميجا على بيانات المدرب لكل
/// قياس. بعد الضغط بتصير كل صورة بحدود 200–400 كيلو بدون فرق واضح
/// بالعرض على الموبايل.
class ImageCompressor {
  ImageCompressor._();

  /// أقصى بُعد للصورة بعد الضغط (بيحافظ على النسبة).
  static const int maxDimension = 1600;

  /// جودة JPEG — 80 توازن معقول بين الحجم والوضوح لصور الجسم.
  static const int quality = 80;

  /// بترجع ملف مضغوط، أو الملف الأصلي لو فشل الضغط لأي سبب — الضغط
  /// تحسين، مش شرط لنجاح الحفظ.
  static Future<File> compress(File file) async {
    try {
      final targetPath = await _targetPathFor(file);

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        minWidth: maxDimension,
        minHeight: maxDimension,
        quality: quality,
        format: CompressFormat.jpeg,
        // بتصحّح دوران الصور المأخوذة بالعرض بدل ما تنقلب بعد الرفع.
        keepExif: false,
      );

      if (result == null) return file;

      final compressed = File(result.path);
      // لو الضغط طلع أكبر من الأصل (صورة صغيرة أصلاً) منرفع الأصل.
      if (await compressed.length() >= await file.length()) return file;
      return compressed;
    } catch (e) {
      AppLogger.warn('ImageCompressor.compress', e);
      return file;
    }
  }

  static Future<String> _targetPathFor(File file) async {
    final directory = await getTemporaryDirectory();
    final name = file.uri.pathSegments.last.split('.').first;
    final stamp = DateTime.now().microsecondsSinceEpoch;
    return '${directory.path}/compressed_${name}_$stamp.jpg';
  }
}
