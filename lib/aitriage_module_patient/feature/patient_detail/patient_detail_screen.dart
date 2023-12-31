import 'package:flutter/material.dart';
import 'package:flutter_aitriage/aitriage_core/common/app_image.dart';
import 'package:flutter_aitriage/aitriage_core/ui/widget/device_detector.dart';
import 'package:flutter_aitriage/aitriage_core/ui/widget/svg_icon_widget.dart';
import 'package:flutter_aitriage/aitriage_core/util/alert/alert_util.dart';
import 'package:flutter_aitriage/aitriage_module_patient/feature/patient_detail/patient_detail_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../aitriage_core/common/app_color.dart';
import '../../../aitriage_core/common/app_style.dart';
import '../../../aitriage_core/ui/widget/color_button.dart';
import '../../config/patient_module_page_route.dart';
import '../../widget/add_note_dialog.dart';
import '../../widget/patient_detail_assessment.dart';
import '../../widget/patient_detail_information.dart';
import '../../widget/patient_detail_note.dart';
import '../../widget/patient_detail_widget.dart';

class PatientDetailScreen extends StatelessWidget {
  const PatientDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DeviceDetector(tablet: _Tablet(), phone: Placeholder());
  }
}

class _Tablet extends StatefulWidget {
  const _Tablet();

  @override
  State<_Tablet> createState() => _TabletState();
}

class _TabletState extends State<_Tablet> {
  final controller = Get.find<PatientDetailController>();
  final pageViewController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.colorBackgroundSearch,
        body: Column(
          children: [
            Container(
                height: 80.h,
                margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  color: AppColor.colorAppBackground,
                ),
                child: Row(mainAxisSize: MainAxisSize.max, children: [
                  GestureDetector(
                      onTap: () => Get.back(
                          id: PatientModulePageRoute.nestedId,
                          result: controller.vm.value.shouldReloadData),
                      child: Row(
                        children: [
                          SvgIconWidget(name: AppImage.svgArrowLeft),
                          SizedBox(width: 8.w),
                          Text('Back', style: AppStyle.styleTextUserChoice),
                        ],
                      )),
                  const Spacer(),
                  ColorButton(
                      title: 'Add assessment',
                      width: 150.w,
                      shouldEnableBackground: true),
                  SizedBox(width: 16.w),
                  ColorButton(
                    title: 'Add note',
                    width: 100.w,
                    shouldTapAbleWhenDisable: true,
                    onTap: () {
                      Get.dialog(
                          AddNoteDialog(
                            title: 'ADD NOTE',
                            primaryButtonTitle: 'Save',
                            secondaryButtonTile: 'Cancel',
                            onTapSecondaryButton: () => Get.back(),
                            onTapPrimaryButton: (text) {
                              onSuccess() {
                                Get.back();
                                Get.snackbar('Success', 'Successfully added note');

                                if (pageViewController.page == 2) controller.reloadListNote();
                              }
                              onError(String message) {
                                Get.snackbar('Error', message);
                              }

                              if (text.isEmpty) {
                                Get.snackbar('Alert', 'Note empty');
                                return;
                              }

                              controller.onTapCreateNote(text, onSuccess: onSuccess, onError: onError);
                            },
                        )
                      );
                    },
                  ),
                  SizedBox(width: 16.w),
                  ColorButton(
                      title: 'Edit',
                      width: 80.w,
                      shouldTapAbleWhenDisable: true,
                      onTap: () async {
                        final result = await Get.toNamed(
                            PatientModulePageRoute.addNewPatients,
                            arguments: controller.vm.value.patientEntity);

                        if (result == true) {
                          controller.vm.value.update(shouldReloadData: true);
                          controller.getUserDetailInfo();
                        }
                      }),
                ])),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 24.w),
                  Obx(() => PatientDetailWidget(
                      vm: controller.vm.value,
                      onTap: (index) {
                        controller.handleOnTapPatientDetailWidget(index);
                        pageViewController.jumpToPage(index);
                      },
                      onTapAvatar: () {
                        onSuccess() {
                          Get.snackbar('Message', 'Avatar upload success');
                        }
                        onError(message) {
                          Get.snackbar('Error', message);
                        }
                        Get.snackbar('Message', 'Avatar is uploading');
                        controller.onTapAvatar(
                            onSuccess: onSuccess, onError: onError);
                      },
                      onTapPrimaryButton: () {
                        final alert = AlertUtil.showLoadingIndicator();
                        onSuccess() {
                          AlertUtil.hideLoadingIndicator(alert);
                          Get.back(
                              id: PatientModulePageRoute.nestedId,
                              result: controller.vm.value.shouldReloadData);
                          Get.snackbar(
                              'Success', 'Successfully deleted patient');
                        }
                        onError(message) {
                          AlertUtil.hideLoadingIndicator(alert);
                          Get.snackbar('Error', message);
                        }
                        controller.onTapDeleteButton(
                            onSuccess: onSuccess, onError: onError);
                      })),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.w),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12.r)),
                        color: AppColor.colorAppBackground,
                      ),
                      child: PageView(
                        controller: pageViewController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Obx(() => PatientDetailInformation(vm: controller.vm.value)),
                          Obx(() => PatientDetailAssessment(
                              list: controller.vm.value.listAssessmentVM,
                              totalPage: controller.vm.value.assessmentTotalPage,
                              pageCountString: controller.vm.value.assessmentPageCountString,
                            onPageChanged: (index) => controller.getListAssessment(index),
                          )),
                          Obx(() => PatientDetailNote(
                              list: controller.vm.value.listNoteVM,
                              totalPage: controller.vm.value.noteTotalPage,
                              pageCountString: controller.vm.value.notePageCountString,
                              onPageChanged: (index) => controller.getListNote(index),
                              onTapNote: (noteId, description) {
                                Get.dialog(
                                    AddNoteDialog(
                                      title: 'NOTE',
                                      primaryButtonTitle: 'Save',
                                      secondaryButtonTile: 'Delete',
                                      initText: description,
                                      onTapSecondaryButton: () {
                                        onSuccess() {
                                          Get.back();
                                          controller.reloadListNote();
                                          Get.snackbar('Success', 'Successfully deleted note');
                                        }
                                        onError(String message) {
                                          Get.snackbar('Error', message);
                                        }
                                        controller.onTapDeleteNote(noteId, onSuccess: onSuccess, onError: onError);
                                      },
                                      onTapPrimaryButton: (text) {
                                        onSuccess() {
                                          Get.back();
                                          controller.reloadListNote();
                                          Get.snackbar('Success', 'Successfully edited note');
                                        }
                                        onError(String message) {
                                          Get.snackbar('Error', message);
                                        }
                                        controller.onTapEditNote(noteId, text, onSuccess: onSuccess, onError: onError);
                                      },
                                    )
                                );
                              },
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
