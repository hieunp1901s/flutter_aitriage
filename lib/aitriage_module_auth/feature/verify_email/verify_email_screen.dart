import 'package:flutter/material.dart';
import 'package:flutter_aitriage/aitriage_core/ui/widget/device_detector.dart';
import 'package:flutter_aitriage/aitriage_module_auth/feature/verify_email/verify_email_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../aitriage_core/common/app_color.dart';
import '../../../aitriage_core/common/app_image.dart';
import '../../../aitriage_core/common/app_style.dart';
import '../../../aitriage_core/ui/widget/authentication_header.dart';
import '../../../aitriage_core/ui/widget/color_button.dart';
import '../../../aitriage_core/util/alert/alert_util.dart';
import '../../../aitriage_module_main/config/main_module_page_route.dart';
import '../../widget/input_pin_code.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DeviceDetector(
        tablet: _Tablet(),
        phone: _Phone()
    );
  }
}

class _Tablet extends GetView<VerifyEmailController> {
  const _Tablet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorAppBackground,
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 160.h),
              AuthenticationHeader(
                svgIconNameWithBorder: AppImage.svgEmail,
                headerText: 'check_your_email'.tr,
                contentText: 'we_sent_verification_code'.tr,
                styleContentText: AppStyle.styleCheckYourEmailNotification,
                thirdText: controller.getEmail(),
                styleThirdText: AppStyle.styleCheckYourEmail,
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: 360.w,
                child: InputPinCode(
                  shouldHideCode: false,
                  borderRadius: BorderRadius.circular(12.r),
                  fieldWidth: 70.w,
                  fieldHeight: 70.w,
                  lengthCode: 4,
                  appContext: context,
                  backgroundColor: Colors.white,
                  onComplete: (verifyCode) => controller.onInputCompleted(verifyCode),
                ),
              ),
              SizedBox(height: 32.h),
              ColorButton(
                shouldEnableBackground: true,
                width: 360.w,
                title: 'verify_email_title'.tr,
                onTap: () {
                  final alert = AlertUtil.showLoadingIndicator();
                  onLoginSuccess(message) {
                    AlertUtil.hideLoadingIndicator(alert);
                    Get.snackbar('Success', message);
                    Get.offNamed(MainModulePageRoute.main);
                  }
                  onRegisterSuccess(message) async {
                    AlertUtil.hideLoadingIndicator(alert);
                    await Get.offNamed(MainModulePageRoute.gettingStartedMain);
                  }
                  onError(message) {
                    AlertUtil.hideLoadingIndicator(alert);
                    Get.snackbar('Error', message);
                  }
                  controller.onSubmit(
                      onRegisterSuccess: onRegisterSuccess,
                      onLoginSuccess: onLoginSuccess,
                      onError: onError
                  );
                }
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('didnt_receive_email'.tr),
                  SizedBox(height: 4.w,),
                  TextButton(
                      onPressed: () {
                        final alert = AlertUtil.showLoadingIndicator();
                        onSuccess(message) {
                          AlertUtil.hideLoadingIndicator(alert);
                          Get.snackbar('Success', message);
                        }
                        onError(message) {
                          AlertUtil.hideLoadingIndicator(alert);
                          Get.snackbar('Error', message);
                        }
                        controller.resendCode(
                          onSuccess: onSuccess,
                          onError: onError
                        );
                      },
                      child: Text('click_to_resend'.tr))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Phone extends StatelessWidget {
  const _Phone();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


