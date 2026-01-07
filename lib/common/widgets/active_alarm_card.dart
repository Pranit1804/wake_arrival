import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wake_arrival/common/theme/app_color.dart';

class ActiveAlarmCard extends StatelessWidget {
  final String destinationName;
  final String address;
  final String distance;
  final String duration;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onCardTap;

  const ActiveAlarmCard({
    super.key,
    required this.destinationName,
    required this.address,
    this.distance = '3.2 km',
    this.duration = '15 min',
    required this.onEdit,
    required this.onDelete,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColor.accentPurple.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.cardBackground,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColor.primaryTextColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Map Preview Section
                  _buildMapPreview(),

                  // Details Section
                  _buildDetailsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.backgroundGradientStart.withOpacity(0.8),
            AppColor.backgroundGradientEnd.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Map placeholder with grid pattern
          Center(
            child: Icon(
              Icons.map_outlined,
              size: 80,
              color: AppColor.primaryTextColor.withOpacity(0.3),
            ),
          ),

          // Distance/Duration Badge
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColor.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColor.accentPink,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$duration ($distance)',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Route indicator
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.accentPink,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.navigation,
                size: 20,
                color: AppColor.primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Destination Name and Actions
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destinationName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColor.primaryTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      address,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColor.secondaryTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Edit Button
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColor.accentPurple,
                  size: 22,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColor.accentPurple.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Delete Button
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColor.accentPink,
                  size: 22,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColor.accentPink.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Status indicator
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Active',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.greenAccent,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColor.secondaryTextColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
