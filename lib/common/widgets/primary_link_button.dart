import 'package:flutter/material.dart';
import 'package:wake_arrival/common/theme/app_color.dart';
import 'package:wake_arrival/common/theme/app_text_theme.dart';

class PrimaryLinkButton extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final Color? linkColor;
  const PrimaryLinkButton({
    super.key,
    required this.title,
    this.linkColor,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: titleStyle ??
          AppTextTheme.bodyText2.copyWith(
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.dashed,
            decorationColor: linkColor ?? AppColor.linkColor,
            color: linkColor ?? AppColor.linkColor,
          ),
    );
  }
}
