import 'package:alarm_app/widgets/const.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    required this.onPressed,
    required this.text,
    required this.textStyle,
    this.isIconExits,
    this.icon,
    Key? key, this.mainAxisAlignment, this.padding,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String text;
  final TextStyle textStyle;
  final bool? isIconExits;
  final IconData? icon;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: padding??const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Row(
          mainAxisAlignment: mainAxisAlignment??MainAxisAlignment.center,
          children: [
            Text(
              text.toString(),
              style: textStyle,
            ),
            if (isIconExits != null) kW4sizedBox,
            if (isIconExits != null)
              Icon(
                icon,
                size: 18,
                color: cPrimaryColor,
              )
          ],
        ),
      ),
    );
  }
}
