import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../../theme/app_colors.dart';

enum AvatarSize { small, medium, large }

/// دائرة صورة العميلة، أو حرفها الأول بخلفية متدرجة لو ما في صورة.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = AvatarSize.medium,
    this.gradientColors = const [
      AppColors.categoryBlueStart,
      AppColors.categoryBlueEnd,
    ],
  });

  final String name;
  final String? imageUrl;
  final AvatarSize size;
  final List<Color> gradientColors;

  double get _diameter => switch (size) {
    AvatarSize.small => AppSizes.avatarSm,
    AvatarSize.medium => AppSizes.avatarMd,
    AvatarSize.large => AppSizes.avatarLogo,
  };

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Container(
      width: _diameter,
      height: _diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient:
            hasImage
                ? null
                : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
        image:
            hasImage
                ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      alignment: Alignment.center,
      child:
          hasImage
              ? null
              : Text(
                name.trim().isNotEmpty ? name.trim()[0] : '؟',
                style: TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  fontWeight: FontWeight.w700,
                  fontSize: _diameter * 0.36,
                  color: Colors.white,
                ),
              ),
    );
  }
}
