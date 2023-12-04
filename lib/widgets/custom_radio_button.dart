import 'package:alarm_app/consts/const.dart';
import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final Function()? onChanged;
  final bool isSelected;

  const CustomRadioButton({
    this.isSelected = false,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  Widget buildLabel(context) {
    return Container(
      width: 17,
      height: 17,
      decoration: (Theme.of(context).platform == TargetPlatform.iOS)
          ? null
          : ShapeDecoration(
              shape: CircleBorder(side: BorderSide(color: isSelected ? cPrimaryColor : cIconColor, width: 1.6)),
              color: cTransparentColor,
            ),
      child: Center(
        child: (Theme.of(context).platform == TargetPlatform.iOS && isSelected)
            ? Icon(
                Icons.check,
                size: isDeviceScreenLarge() ? 20 : 16,
                color: cPrimaryColor,
              )
            : CircleAvatar(radius: 4.5, backgroundColor: isSelected ? cPrimaryColor : cTransparentColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged,
      splashColor: cPrimaryColor,
      child: buildLabel(context),
    );
  }
}
