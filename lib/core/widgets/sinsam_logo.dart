import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SinSamLogoIcon extends StatelessWidget {
  final double size;
  const SinSamLogoIcon({super.key, this.size = 76});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.14),
      decoration: BoxDecoration(
        color: AppColors.navyDark,
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: size * 0.28,
            width: size * 0.50,
            decoration: BoxDecoration(
              color: AppColors.logoBlue,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(size * 0.08),
                bottom: Radius.circular(size * 0.03),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(radius: size * 0.09, backgroundColor: AppColors.logoGreen),
              CircleAvatar(radius: size * 0.09, backgroundColor: AppColors.logoGreen),
            ],
          ),
          Container(
            height: size * 0.06,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size * 0.03),
            ),
          ),
        ],
      ),
    );
  }
}
