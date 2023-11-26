
import 'package:alarm_app/consts/const.dart';
import 'package:alarm_app/widgets/custom_icon_button.dart';
import 'package:alarm_app/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void commonBottomSheet({
    required context,
    required Widget content,
    required onPressCloseButton,
    required onPressRightButton,
    required String rightText,
    required TextStyle rightTextStyle,
    required String title,
    required bool isRightButtonShow,
    double? bottomSheetHeight,

  }) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)), color: cWhiteColor),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).viewInsets.bottom > 0.0 ? height * .9 : bottomSheetHeight ?? height * .5,
              constraints: BoxConstraints(minHeight: bottomSheetHeight ?? height * .5, maxHeight: height * .9),
              child: Column(
                children: [
                  kH4sizedBox,
                  Container(
                    decoration: BoxDecoration(
                      color: cOutLineColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    height: 5,
                    width: width * .1,
                  ),
                  kH40sizedBox,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: content,
                      ),
                    ),
                  ),
                  kH4sizedBox,
                ],
              ),
            ),
            Positioned(
              top: 12,
              left: 5,
              child: CustomIconButton(
                onPress: onPressCloseButton,
                icon: Icons.cancel_rounded,
                iconColor: cIconColor,
                size: 24,
              ),
            ),
            Positioned(
              top: 20,
              child: Text(
                title,
                style: const TextStyle(color: cTextPrimaryColor, fontSize: 18),
              ),
            ),
            if (isRightButtonShow)
              Positioned(
                top: 20,
                right: 10,
                child:  CustomTextButton(
                      onPressed:  onPressRightButton,
                      text: rightText,
                      textStyle: rightTextStyle ,
                    ),
              ),
          ],
        );
      },
    );
  }
  final isBottomSheetRightButtonActive = StateProvider<bool>((ref) => true);

