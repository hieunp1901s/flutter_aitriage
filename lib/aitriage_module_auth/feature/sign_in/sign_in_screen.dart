import 'package:flutter/material.dart';
import 'package:flutter_aitriage/aitriage_core/common/app_style.dart';
import 'package:flutter_aitriage/aitriage_core/ui/widget/device_detector.dart';
import 'package:flutter_aitriage/aitriage_module_auth/feature/sign_in/sign_in_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../aitriage_core/common/app_color.dart';
import '../../../aitriage_core/common/app_image.dart';
import '../../../aitriage_core/ui/widget/authentication_header.dart';
import '../../../aitriage_core/ui/widget/color_button.dart';
import '../../../aitriage_core/ui/widget/custom_login_field.dart';
import '../../../aitriage_module_main/config/main_route.dart';
import '../../config/auth_module_page_route.dart';
import '../../widget/drop_down_button.dart';
import '../../widget/remember_me_forgot_password.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DeviceDetector(
        tablet: const _Tablet(),
        phone: _Phone());
  }
}

class _Tablet extends GetView<SignInController> {
  const _Tablet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorAppBackground,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 160.h),
              AuthenticationHeader(
                svgIconName: AppImage.svgAppLogo,
                headerText: 'welcome_back'.tr,
              ),
              SizedBox(height: 14.h),
              SizedBox(
                child: CustomLoginField(
                  onTextChange: (_) => controller.onTextEmailChange(_),
                  // isValidated: widget.controller.isValidEmail.value,
                  label: 'email_label'.tr,
                  hintText: 'email_hint'.tr,
                ),
              ),
              SizedBox(height: 14.h),
              CustomLoginField(
                shouldSecured: true,
                onTextChange: (_) =>
                    controller.onTextPasswordChange(_),
                // isValidated: widget.controller.isValidPassword.value,
                label: 'password_label'.tr,
                hintText: 'password_hint'.tr,
              ),
              Obx(() {
                return SizedBox(
                  width: 360.w,
                  child: RememberAndForgotPassword(
                    isChecked: controller.isCheck.value,
                    onTapCheck: (value) {
                      controller.onCheckBoxTap(value);
                    },
                    onTapForgotPassword: () =>
                        Get.toNamed(AuthModulePageRoute.forgotPassword),
                  ),
                );
              }),
              Obx(() {
                return SizedBox(
                  width: 360.w,
                  child: ColorButton(
                    title: 'sign_in'.tr,
                    shouldEnable: controller.isValidated.value,
                    onTap: () async {
                      controller.onSubmitSignIn(
                          callback: (value) => Get.toNamed(
                              MainRoute.main,
                              arguments: {'userInfo': value}));
                    },
                    // shouldEnable: widget.controller.isValidated.value,
                  ),
                );
              }),
              SizedBox(
                width: 450.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('dont_have_account'.tr,
                      style: AppStyle.styleRememberMeText,),
                    TextButton(
                        onPressed: () =>
                            Get.toNamed(
                                AuthModulePageRoute.registerAccountType),
                        child: Text(
                          'Sign up', style: AppStyle.styleForgotPassword,)),
                  ],
                ),
              ),
              SizedBox(
                height: 80.h,
              ),
              Obx(() => DropDownButton(
                width: 200.w,
                title: '',
                shouldIncludeAsterisk: false,
                children: controller.vm.value.countryList.map((e) => CountryWidget(
                  isNetworkIcon: true,
                  leftIconName: e.emoji,
                  contentText: e.name,
                  width: 200.w,
                )).toList(),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _Phone extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhoneState();
}

class _PhoneState extends State<_Phone> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}