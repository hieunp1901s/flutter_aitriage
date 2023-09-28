import 'package:flutter/material.dart';
import 'package:flutter_aitriage/aitriage_core/common/app_image.dart';
import 'package:flutter_aitriage/aitriage_core/ui/widget/device_detector.dart';
import 'package:flutter_aitriage/aitriage_core/ui/widget/svg_icon_widget.dart';
import 'package:flutter_aitriage/aitriage_core/util/alert/alert_util.dart';
import 'package:flutter_aitriage/aitriage_module_assessment/feature/patient_detail/patient_detail_controller.dart';
import 'package:flutter_aitriage/aitriage_module_assessment/widget/patient_detail_assessment.dart';
import 'package:flutter_aitriage/aitriage_module_assessment/widget/patient_detail_information.dart';
import 'package:flutter_aitriage/aitriage_module_assessment/widget/patient_detail_note.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../aitriage_core/common/app_color.dart';
import '../../../aitriage_core/common/app_style.dart';
import '../../../aitriage_core/ui/widget/color_button.dart';
import '../../config/assessment_module_page_route.dart';
import '../../widget/patient_detail_widget.dart';

class PatientDetailScreen extends StatelessWidget {
  const PatientDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DeviceDetector(
        tablet: _Tablet(),
        phone: Placeholder()
    );
  }
}

class _Tablet extends GetView<PatientDetailController> {
  const _Tablet({super.key});
  
  @override
  Widget build(BuildContext context) {
    final pageViewController = PageController();
    return Scaffold(
      backgroundColor: AppColor.colorBackgroundSearch,
      body: Column(
        children: [
          Container(
              height: 80.h,
              margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                     Radius.circular(12.r)),
                color: AppColor.colorAppBackground,
              ),
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                        onTap: () => Get.back(id: AssessmentModulePageRoute.nestedId),
                        child: Row(
                          children: [
                            SvgIconWidget(name: AppImage.svgArrowLeft),
                            SizedBox(width: 8.w),
                            Text('Back', style: AppStyle.styleTextUserChoice),
                          ],
                        )),
                    Spacer(),
                    ColorButton(title: 'Add assessment', width: 150.w, shouldEnableBackground: true),
                    SizedBox(width: 16.w),
                    ColorButton(title: 'Add note', width: 100.w, shouldTapAbleWhenDisable: true),
                    SizedBox(width: 16.w),
                    ColorButton(
                        title: 'Edit',
                        width: 80.w,
                        shouldTapAbleWhenDisable: true,
                        onTap: () async {
                          final result = await Get.toNamed(
                              AssessmentModulePageRoute.addNewPatients,
                              arguments: controller.vm.value.patientEntity
                          );

                          if (result == true) controller.getUserDetailInfo();
                        }),
                  ])),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 24.w),
                Obx(() => PatientDetailWidget(
                    vm: controller.vm.value,
                    onTap: (index) => pageViewController.jumpToPage(index),
                    onTapAvatar: () {
                      onSuccess() {
                        Get.snackbar('Message', 'Avatar upload success');
                      }
                      onError(message) {
                        Get.snackbar('Error', message);
                      }
                      Get.snackbar('Message', 'Avatar is uploading');
                      controller.onTapAvatar(onSuccess: onSuccess, onError: onError);
                    },
                )),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 24.w),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(12.r)),
                      color: AppColor.colorAppBackground,
                    ),
                    child: PageView(
                      controller: pageViewController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Obx(() => PatientDetailInformation(vm: controller.vm.value)),
                        PatientDetailAssessment(),
                        PatientDetailNote()
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}





