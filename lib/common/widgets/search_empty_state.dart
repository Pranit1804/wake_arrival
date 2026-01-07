import 'package:flutter/material.dart';
import 'package:wake_arrival/common/theme/app_color.dart';

class SearchEmptyState extends StatelessWidget {
  final String message;

  const SearchEmptyState({
    super.key,
    this.message = 'No results found',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.accentPurple.withOpacity(0.15),
              ),
              child: const Icon(
                Icons.search_off,
                size: 40,
                color: AppColor.accentPurple,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColor.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Try searching for a different location',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.tertiaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
