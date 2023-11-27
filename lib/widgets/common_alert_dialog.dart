import 'package:alarm_app/consts/const.dart';
import 'package:alarm_app/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

class CommonAlertDialog extends StatelessWidget {
  const CommonAlertDialog({
    this.title,
    required this.addContent,
    this.hasCloseBtn = false,
    this.hasDivider = true,
    this.actions,
    this.onClose,
    this.horizontalContentPadding,
    this.verticalContentPadding,
    Key? key,
  }) : super(key: key);

  final String? title;
  final Widget? addContent;
  final bool hasCloseBtn, hasDivider;
  final List<Widget>? actions;
  final Function()? onClose;
  final double? horizontalContentPadding;
  final double? verticalContentPadding;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      titlePadding: EdgeInsets.zero,
      title: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Column(
          children: [
            Container(
              color: cWhiteColor,
              height: kDialogTitleContainerHeight,
              width: width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (title != null)
                    Center(
                      child: Text(
                        title.toString(),
                        textAlign: TextAlign.center,
                        style: semiBold16TextStyle(cTextPrimaryColor),
                      ),
                    ),
                  if (hasCloseBtn)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CustomIconButton(
                        hasBorder: false,
                        onPress: onClose,
                        icon: Icons.close,
                        size: height > kSmallDeviceSizeLimit ? 20 : 16,
                      ),
                    ),
                ],
              ),
            ),
            const Divider(
              height: 0.5,
              thickness: 0.3,
              color: cLineColor,
            )
          ],
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: horizontalContentPadding ?? 15,
        vertical: verticalContentPadding ?? 10,
      ),
      insetPadding: const EdgeInsets.all(20),
      content: addContent,
      actions: actions,
    );
  }
}
