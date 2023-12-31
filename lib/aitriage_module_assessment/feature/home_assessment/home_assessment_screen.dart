import 'package:flutter/material.dart';
import 'package:flutter_aitriage/aitriage_core/util/alert/alert_util.dart';
import 'package:flutter_aitriage/aitriage_module_assessment/config/assessment_module_page_route.dart';
import 'package:flutter_aitriage/aitriage_module_assessment/widget/assessment_summary_list_view.dart';
import 'package:flutter_aitriage/aitriage_module_assessment/widget/risk_with_symbol.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:number_paginator/number_paginator.dart';
import '../../../aitriage_core/common/app_color.dart';
import '../../../aitriage_core/common/app_image.dart';
import '../../../aitriage_core/common/app_style.dart';
import '../../../aitriage_core/ui/widget/base_search_bar_tablet.dart';
import '../../../aitriage_core/ui/widget/color_button.dart';
import '../../../aitriage_core/ui/widget/custom_trailing_widget.dart';
import '../../../aitriage_core/ui/widget/dashboard_item_view.dart';
import '../../../aitriage_core/ui/widget/device_detector.dart';
import '../../../aitriage_core/ui/widget/line_separated.dart';
import '../../../aitriage_core/ui/widget/svg_icon_widget.dart';
import '../../../aitriage_core/util/app_event_channel/core/app_event_channel.dart';
import '../../../aitriage_core/util/app_event_channel/custom_event/current_location_changed_event.dart';
import '../../../aitriage_core/util/subscription_collector/subscription_collector.dart';
import 'home_assessment_controller.dart';

class HomeAssessmentScreen extends StatelessWidget {
  const HomeAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DeviceDetector(tablet: _Tablet(), phone: _Phone());
  }
}

class _Tablet extends StatefulWidget {
  const _Tablet();

  @override
  State<_Tablet> createState() => _TabletState();
}

class _TabletState extends State<_Tablet> with SubscriptionCollector {
  final _pageController = NumberPaginatorController();
  final controller = Get.find<HomeAssessmentController>();

  @override
  void initState() {
    super.initState();
    final appEventChannel = AppEventChannel();
    final lastEvent = appEventChannel.getLastEvent<CurrentLocationChangedEvent>();
    final subscription = appEventChannel
        .on<CurrentLocationChangedEvent>()
        .listen((event) => onTapNumberPaginator(0));
    addToCollector(subscription);

    if (lastEvent != null) onTapNumberPaginator(0);
  }

  @override
  void dispose() {
    disposeAllStreamInCollector();
    super.dispose();
  }

  void onTapNumberPaginator(int page) {
    final alert = AlertUtil.showLoadingIndicator();
    controller.onTapNumberPaginator(
        page,
        onSuccess: () => AlertUtil.hideLoadingIndicator(alert),
        onError: (message) {
          AlertUtil.hideLoadingIndicator(alert);
          Get.snackbar('Error', message);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorAppBackground,
      body: Container(
        color: AppColor.colorBackgroundSearch,
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 150.h,
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    final itemWidth = (constraints.maxWidth - 72.w) / 4;
                    return Row(
                      children: [
                        Obx(() => DashboardItemView(
                            icon: const RiskWithSymbol(risk: Risk.total),
                            width: itemWidth,
                            label: 'Total Assessment',
                            amount: controller.vm.value.totalAssessment)),
                        SizedBox(width: 24.w),
                        Obx(() => DashboardItemView(
                            icon: const RiskWithSymbol(risk: Risk.low),
                            width: itemWidth,
                            label: 'Low risk',
                            amount: controller.vm.value.totalLowRisk)),
                        SizedBox(width: 24.w),
                        Obx(() => DashboardItemView(
                            icon: const RiskWithSymbol(risk: Risk.medium),
                            width: itemWidth,
                            label: 'Medium risk',
                            amount: controller.vm.value.totalMediumRisk)),
                        SizedBox(width: 24.w),
                        Obx(() => DashboardItemView(
                            icon: const RiskWithSymbol(risk: Risk.high),
                            width: itemWidth,
                            label: 'High risk',
                            amount: controller.vm.value.totalHighRisk))
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColor.colorAppBackground,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            BaseSearchBarTablet(
                              width: 320.w,
                              hintText: 'Search...',
                              onTextChange: (text) {
                                controller.onSearchTextFieldChanged(
                                    text,
                                    onSuccess: () => _pageController.currentPage = 0);
                              },
                            ),
                            SizedBox(width: 16.w),
                            CustomTrailingWidget(
                                child: SvgIconWidget(name: AppImage.svgFilter, size: 24.r)),
                            const Spacer(),
                            ColorButton(
                              title: 'Add new',
                              shouldEnableBackground: true,
                              onTap: () async {
                              },
                              width: 102.w,
                            )
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Expanded(
                            child: Obx(() => AssessmentSummaryListView(
                                onTapAssessment: (_) => Get.toNamed(
                                    AssessmentModulePageRoute.assessmentDetail,
                                    id: AssessmentModulePageRoute.nestedId),
                                list: controller.vm.value.listAssessmentVM))),
                        LineSeparated(margin: 16.h),
                        Row(
                          children: [
                            Obx(() => Text(
                              controller.vm.value.pageCountString,
                              style: AppStyle.styleRememberMeText,
                            )),
                            const Spacer(),
                            Obx(() => Align(
                              alignment: Alignment.topRight,
                              child: SizedBox(
                                height: 50.w,
                                ///Tính chiều rộng động. 20 là tổng padding giữa 2 dấu mũi tên.
                                ///100 là tổng khoảng cách của 2 ô mũi tên, do trong thư viện set height = width
                                ///nên set cứng height là 50.w để lấy khoảng cách.
                                ///50 * totalPage để tính độ rộng cần thiết cho content ở giữa.
                                width: (50 * controller.vm.value.totalPage).toDouble().w
                                    + 20.w + 100.w,
                                child: StatefulBuilder(
                                  builder: (_, setState) {
                                    if (controller.vm.value.totalPage < 1) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      return NumberPaginator(
                                        numberPages: controller.vm.value.totalPage,
                                        onPageChange: (value) {
                                          setState(() {});
                                          onTapNumberPaginator(value);
                                        },
                                        controller: _pageController,
                                        config: NumberPaginatorUIConfig(
                                            contentPadding:
                                            const EdgeInsets.all(0),
                                            buttonShape:
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  8.r),
                                            )),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ))
                          ],
                        )
                      ],
                    ),
                  )),
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


