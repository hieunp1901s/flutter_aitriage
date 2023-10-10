import 'dart:developer';
import 'package:flutter_aitriage/aitriage_core/common/app_constant.dart';
import 'package:flutter_aitriage/aitriage_module_patient/domain/use_case/get_list_assessment_by_location_uc.dart';
import 'package:get/get.dart';
import '../../../aitriage_core/network/handle_error/handle_error.dart';
import '../../../aitriage_core/util/app_event_channel/core/app_event_channel.dart';
import '../../../aitriage_core/util/app_event_channel/custom_event/current_location_changed_event.dart';
import '../../../aitriage_core/util/debounce/debounce_util.dart';
import '../../../aitriage_core/util/subscription_collector/subscription_collector.dart';
import '../../../aitriage_module_patient/domain/use_case/get_gender_type_param_uc.dart';
import 'home_assessment_vm.dart';

class HomeAssessmentController extends GetxController with SubscriptionCollector {
  // use case
  final GetListAssessmentByLocationUseCase _getListAssessmentByLocationUC;
  final GetGenderParamTypeUseCase _getGenderParamTypeUC;
  // vm
  final vm = HomeAssessmentVM().obs;
  // Util
  final _debounce = DebounceUtil();
  final appEventChannel = AppEventChannel();

  HomeAssessmentController(this._getListAssessmentByLocationUC, this._getGenderParamTypeUC);

  @override
  void onInit() {
    super.onInit();
    _registerListener();
  }

  @override
  void onClose() {
    super.onClose();
    disposeAllStreamInCollector();
  }

  void _registerListener() {
    // wait until get location in home main controller done before calling next api
    final lastEvent = appEventChannel.getLastEvent<CurrentLocationChangedEvent>();
    final subscription = appEventChannel
        .on<CurrentLocationChangedEvent>()
        .listen((event) => onTapNumberPaginator(0));
    addToCollector(subscription);

    if (lastEvent != null) onTapNumberPaginator(0);
  }

  void onTapNumberPaginator(
    int page, {
        Function? onSuccess,
        Function(String)? onError
  }) async {
    try {
      final pageParam = page + 1;
      final genderParamType = _getGenderParamTypeUC.execute();
      final searchParam = vm.value.searchParam;
      final resp = await _getListAssessmentByLocationUC.execute(
          pageParam,
          AppConstant.pageLimit,
          search: searchParam
      );
      vm.value.update(
          listAssessment: resp.data,
          genderParamType: genderParamType,
          totalPage: resp.totalPage,
          totalLowRisk: resp.totalLowRisk,
          totalMediumRisk: resp.totalMediumRisk,
          totalHighRisk: resp.totalHighRisk,
          pageLimit: AppConstant.pageLimit,
          currentPage: page,
          searchParam: searchParam);
      vm.refresh();
      onSuccess?.call();
    } catch (error) {
      log(error.toString());
      HandleNetworkError.handleNetworkError(
          error, (message, _, __) => onError?.call(message));
    }
  }

  void onSearchTextFieldChanged(
      String? text, {
        Function? onSuccess
    }) {
    // reset current page + pass text to api param
    vm.value.update(searchParam: text);
    _debounce.run(() => onTapNumberPaginator(0, onSuccess: onSuccess));
  }
}