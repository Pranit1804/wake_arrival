import 'package:flutter/material.dart';
import 'package:wake_arrival/common/theme/app_color.dart';
import 'package:intl/intl.dart';

class UserGreetingHeader extends StatelessWidget {
  final String userName;

  const UserGreetingHeader({
    super.key,
    this.userName = 'Jason',
  });

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return DateFormat('EEE, MMM d').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTimeBasedGreeting(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      _getFormattedDate(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColor.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // // Settings Icon
          // IconButton(
          //   icon: const Icon(
          //     Icons.settings_outlined,
          //     color: AppColor.primaryTextColor,
          //     size: 24,
          //   ),
          //   onPressed: () {
          //     // TODO: Navigate to settings
          //   },
          // ),
        ],
      ),
    );
  }
}
