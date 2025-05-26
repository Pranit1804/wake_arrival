import 'package:flutter/material.dart';
import 'package:wake_arrival/common/constants/layout_constants.dart';
import 'package:wake_arrival/common/theme/app_color.dart';
import 'package:wake_arrival/common/theme/app_text_theme.dart';
import 'package:wake_arrival/models/search/presentation/pages/location_page.dart';

class SingleAutoCompleteWidget extends StatelessWidget {
  final LocationAddress address;
  const SingleAutoCompleteWidget({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.primaryDarkColor,
          ),
          child: Icon(
            Icons.location_pin,
            color: Colors.white.withOpacity(0.5),
            size: 12,
          ),
        ),
        const SizedBox(
          width: LayoutConstants.dimen_8,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address.titleAddress,
              style: AppTextTheme.bodyText1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              address.subtitleAddress,
              style: AppTextTheme.caption.copyWith(
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
