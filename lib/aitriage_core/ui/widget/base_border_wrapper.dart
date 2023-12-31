import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/app_color.dart';

class BaseBorderWrapper extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final bool shouldShowBorder;

  const BaseBorderWrapper({
    super.key,
    this.child,
    this.width,
    this.height,
    this.backgroundColor = AppColor.colorAppBackground,
    this.shouldShowBorder = true
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: backgroundColor,
          border: shouldShowBorder ? Border.all(color: AppColor.colorTextFieldPlaceHolder) : null ,
          borderRadius: BorderRadius.circular(8.r)
      ),
      child: child,
    );
  }
}
