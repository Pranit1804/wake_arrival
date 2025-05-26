import 'package:flutter/material.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/theme/app_color.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: LayoutConstants.dimen_50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.primaryButtonColor,
          borderRadius: BorderRadius.circular(LayoutConstants.dimen_6),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: LayoutConstants.dimen_16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
