
import 'package:alarm_app/const.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.onPress,
    required this.icon,
    this.iconColor,
    this.size,
    this.hasBorder = true,
  }) : super(key: key);

  final Function()? onPress;
  final IconData? icon;
  final Color? iconColor;
  final double? size;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: TextButton(
        onPressed: onPress,
        style: kTextButtonStyle,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            const SizedBox(
              height: h36,
              width: h36,
            ),
            Icon(
              icon,
              size: size ?? 24,
              color: iconColor ?? cIconColor,
            ),
          ],
        ),
      ),
    );
  }
}
