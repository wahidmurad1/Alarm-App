import 'package:alarm_app/consts/const.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    this.title,
    this.subtitle,
    this.onPressed,
    this.leading,
    this.trailing,
    this.itemColor = cWhiteColor,
    this.borderColor,
    this.padding,
    this.spacing = 5,
    this.alignLeadingWithTitle = false,
    this.titleTextStyle,
    this.subTitleTextStyle,
  }) : super(key: key);

  final dynamic title, subtitle;
  final Function()? onPressed;
  final dynamic leading, trailing;
  final Color itemColor;
  final Color? borderColor;
  final bool alignLeadingWithTitle;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final TextStyle? titleTextStyle;
  final TextStyle? subTitleTextStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(),
      decoration: BoxDecoration(
        color: itemColor,
        border: Border.all(color: borderColor ?? itemColor),
        borderRadius: BorderRadius.circular(8),
      ),
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextButton(
          style: kTextButtonStyle,
          onPressed: onPressed,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: alignLeadingWithTitle ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                if (leading != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: leading!,
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        (title is String)
                            ? Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: titleTextStyle ?? semiBold14TextStyle(itemColor == cPrimaryColor ? cWhiteColor : cBlackColor),
                              )
                            : title,
                      if (subtitle != null)
                        Padding(
                          padding: EdgeInsets.only(top: spacing),
                          child: (subtitle is String)
                              ? Text(
                                  subtitle,
                                  overflow: TextOverflow.ellipsis,
                                  style: subTitleTextStyle ?? regular12TextStyle(itemColor == cPrimaryColor ? cWhiteColor : cBlackColor),
                                )
                              : subtitle,
                        ),
                    ],
                  ),
                ),
                if (trailing != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: trailing is IconData
                        ? Icon(
                            trailing!,
                            color: itemColor == cPrimaryColor ? cWhiteColor : cBlackColor,
                            size: isDeviceScreenLarge() ? 20 : 16,
                          )
                        : trailing!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
