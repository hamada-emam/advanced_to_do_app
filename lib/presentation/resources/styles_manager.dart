// import 'package:secound_task2/presentation/resourses/color_manager.dart';

import 'package:flutter/material.dart';

import 'app_values.dart';
import 'color_manager.dart';

// alll font styles for app
class CustomTextStyles {
  // header of pages
  static TextStyle? headOfPagesTitleStyle = TextStyle(
      fontSize: FontSizes.fontSize23,
      color: ColorManager.darkBlak,
      fontWeight: FontWeight.w700);
  // tabs  labels
  static TextStyle? tabLabesTextStyles = const TextStyle(
      fontSize: FontSizes.fontSize18,
      // color: ColorManager.darkGrey,
      fontWeight: FontWeight.w400);

  static TextStyle? titleStyle = TextStyle(
      fontSize: FontSizes.fontSize18,
      color: ColorManager.darkGrey,
      fontWeight: FontWeight.w400);

  static TextStyle? subTitleStyle = TextStyle(
      fontSize: 18, color: ColorManager.darkGrey, fontWeight: FontWeight.w400);

  // tabs text style// disactive
  static TextStyle? tabTitleDisabled = TextStyle(
    fontSize: 18,
    color: ColorManager.lightGrey,
  );

  // active
  static TextStyle? tabTitleActive = TextStyle(
    fontSize: 18,
    color: ColorManager.darkGrey,
  );

  // button styles
  static TextStyle? buttonTextStyle = const TextStyle(
      fontSize: 18, color: ColorManager.mainWight, fontWeight: FontWeight.bold);

  static TextStyle? bodyStyle = TextStyle(
      fontSize: 20, color: ColorManager.darkGrey, fontWeight: FontWeight.w600);

  static TextStyle? detailsbodyStyle = const TextStyle(
      fontSize: 20, color: ColorManager.mainWight, fontWeight: FontWeight.w600);

  static TextStyle? detailesTitle = const TextStyle(
      fontSize: 25, color: ColorManager.mainWight, fontWeight: FontWeight.w700);

  static TextStyle? detailesFont = const TextStyle(
      fontSize: 18, color: ColorManager.mainWight, fontWeight: FontWeight.w300);

  static TextStyle? lighttitleStyle = const TextStyle(
      fontSize: 20, color: ColorManager.mainWight, fontWeight: FontWeight.w500);

  static TextStyle? darktitleStyle = TextStyle(
      fontSize: 20, color: ColorManager.darkBlak, fontWeight: FontWeight.w500);
}
