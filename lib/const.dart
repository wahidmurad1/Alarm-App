import 'package:flutter/material.dart';

const Color cTextPrimaryColor = Color(0xFF161B1D);
const Color cTextSecondaryColor = Color(0xFF97999B);
const Color cIconColor = Color(0xFF97999B);
// const Color cPasteColor = Color(0xFF35DFF1);
const Color cPrimaryColor = Color(0xFF487BFF);
const Color cSplashBackground = Color.fromARGB(255, 226, 224, 247);
const Color cGradientLinearPrimaryColor = Color(0xFF546EF7);
const Color cBackgroundNeutralColor = Color(0xFFF6F6F6);
const Color cBackgroundNeutralColor2 = Color(0xFFEFEFEF);
const Color cBackgroundNeutralColor3 = Color.fromARGB(255, 218, 218, 218);
const Color cOutLineColor = Color(0xFFCBCCCD);
const Color cWhiteColor = Color(0xFFFFFFFF);
const Color cWarningColor = Color(0xFFFFBB0D);
const Color cSuccessColor = Color(0xFF00D261);
const Color cRedAccentColor = Color(0xFFF76554);
const Color cTransparentColor = Colors.transparent;

//* new color
const Color cPrimaryTintColor = Color(0xFFD8DEFF);
const Color cBlueAccent = Color(0XFFECEBFF);
const Color cBlueShade = Color(0XFFB8B1FF);


double height = 0.0;
double width = 0.0;

void heightWidthKeyboardValue(context) {
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
}

const kH4sizedBox = SizedBox(height: 4);
const kH8sizedBox = SizedBox(height: 8);
const kH12sizedBox = SizedBox(height: 12);
const kH16sizedBox = SizedBox(height: 16);
const kH20sizedBox = SizedBox(height: 20);
const kH10sizedBox = SizedBox(height: 10);
const kH40sizedBox = SizedBox(height: 40);

const kW4sizedBox = SizedBox(width: 4);
const kW8sizedBox = SizedBox(width: 8);
const kW12sizedBox = SizedBox(width: 12);
const kW16sizedBox = SizedBox(width: 16);
const kW20sizedBox = SizedBox(width: 20);


const double h36 = 36.0;

//* info: remove extra padding from TextButton
ButtonStyle? kTextButtonStyle = TextButton.styleFrom(
  padding: EdgeInsets.zero,
  minimumSize: Size.zero,
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  splashFactory: InkSplash.splashFactory,
);
