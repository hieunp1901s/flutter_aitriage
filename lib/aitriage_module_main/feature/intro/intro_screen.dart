import 'package:flutter/material.dart';
import 'package:flutter_aitriage/aitriage_core/common/app_style.dart';
import 'package:flutter_aitriage/aitriage_core/ui/widget/color_button.dart';
import 'package:flutter_aitriage/aitriage_core/ui/widget/device_detector.dart';
import 'package:flutter_aitriage/aitriage_core/util/bluetooth_util/example/example_permission_screen/example_controller.dart';
import 'package:flutter_aitriage/aitriage_core/util/bluetooth_util/example/example_permission_screen/example_view.dart';
import 'package:flutter_aitriage/aitriage_module_auth/config/auth_module_page_route.dart';
import 'package:flutter_aitriage/aitriage_module_auth/feature/sign_up/register_account_type/register_account_type_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../aitriage_core/common/app_color.dart';
import '../../../aitriage_core/util/global_function.dart';
import '../../widget/circle_indicator.dart';
import '../../widget/intro_page_view_item_tablet.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void dispose() {
    // Clear cachedImage
    imageCache.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const DeviceDetector(
        tablet: _Tablet(),
        phone: _Phone()
    );
  }
}

class _Tablet extends StatefulWidget {
  const _Tablet();

  @override
  State<_Tablet> createState() => _TabletState();
}

class _TabletState extends State<_Tablet> {
  var index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorAppBackground,
      body: Column(
        children: [
          SizedBox(
            height: 790.h,
            child: PageView(
              onPageChanged: (value) => setState(() {
                index = value;
              }),
              // controller: controller,
              children: [
                IntroPageViewItemTablet(
                  title: 'intro_title_1'.tr,
                  label: 'intro_label_1'.tr,
                  intro: cachedImage[1],
                ),
                IntroPageViewItemTablet(
                  title: 'intro_title_2'.tr,
                  label: 'intro_label_2'.tr,
                  intro: cachedImage[2],
                ),
                IntroPageViewItemTablet(
                  title: 'intro_title_2'.tr,
                  label: 'intro_label_3'.tr,
                  intro: cachedImage[3],
                ),
                IntroPageViewItemTablet(
                  title: 'intro_title_2'.tr,
                  label: 'intro_label_4'.tr,
                  intro: cachedImage[4],
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          CircleIndicator(index: index, length: 4),
          SizedBox(height: 50.h),
          ColorButton(
              onTap: () => Navigator.of(Get.context!).push(
                MaterialPageRoute(builder: (context) => const RegisterAccountTypeScreen())
              ),
              title: 'sign_up_title'.tr, 
              width: 360.w, 
              shouldEnableBackground: true,
          ),
          SizedBox(height: 34.h),
          GestureDetector(
            onTap: () => Get.offNamed(AuthModulePageRoute.signIn),
            // onTap: () => Get.to(
            //     () => BluetoothExampleView(),
            //     binding: BindingsBuilder(() {
            //       Get.put(BluetoothExampleController());})),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('login_suggest'.tr, style: AppStyle.styleRememberMeText),
                const Text(' '),
                Text('sign_in'.tr, style: AppStyle.styleIntroSuggest2)
              ],
            ),
          )
        ],
      )
    );
  }
}


class _Phone extends StatefulWidget {
  const _Phone();

  @override
  State<_Phone> createState() => _PhoneState();
}

class _PhoneState extends State<_Phone> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColor.colorAppBackground,
    );
  }
}
