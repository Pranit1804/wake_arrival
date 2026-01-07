import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wake_arrival/common/theme/app_color.dart';

class GlassmorphicSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onClear;

  const GlassmorphicSearchBar({
    super.key,
    required this.controller,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColor.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColor.primaryTextColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              color: AppColor.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search destination...',
              hintStyle: TextStyle(
                color: AppColor.tertiaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: AppColor.accentPurple,
                size: 24,
              ),
              suffixIcon: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, child) {
                  return value.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: AppColor.tertiaryTextColor,
                            size: 20,
                          ),
                          onPressed: onClear,
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
