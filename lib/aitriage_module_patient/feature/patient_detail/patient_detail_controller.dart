import 'dart:developer';
import 'package:flutter_aitriage/aitriage_core/common/app_constant.dart';
import 'package:flutter_aitriage/aitriage_core/network/handle_error/handle_error.dart';
import 'package:flutter_aitriage/aitriage_core/service/hivi_service/hivi_service.dart';
import 'package:flutter_aitriage/aitriage_module_patient/feature/patient_detail/patient_detail_vm.dart';
import 'package:get/get.dart';
import '../../data/api/request/update_patient_request.dart';
import '../../domain/use_case/add_patient_note_uc.dart';
import '../../domain/use_case/delete_note_uc.dart';
import '../../domain/use_case/delete_patient_uc.dart';
import '../../domain/use_case/edit_note_uc.dart';
import '../../domain/use_case/get_gender_type_param_uc.dart';
import '../../domain/use_case/get_list_assessment_by_patient.dart';
import '../../domain/use_case/get_list_patient_note_uc.dart';
import '../../domain/use_case/get_patient_detail_uc.dart';
import '../../domain/use_case/update_patient_uc.dart';

class PatientDetailController extends GetxController {
  final GetPatientDetailUseCase _getPatientDetailUC;
  final GetListPatientNoteUseCase _getListPatientNoteUC;
  final GetGenderParamTypeUseCase _getGenderParamTypeUC;
  final AddPatientNoteUseCase _addPatientNoteUC;
  final UpdatePatientUseCase _updatePatientUC;
  final DeletePatientUseCase _deletePatientUC;
  final EditNoteUseCase _editNoteUC;
  final DeleteNoteUseCase _deleteNoteUC;
  final GetListAssessmentByPatientUseCase _getListAssessmentByPatientUC;
  // Nested navigation doesn't support dynamic argument, need to get argument from onGenerateRoute
  final dynamic _argument;
  final vm = PatientDetailVM().obs;

  PatientDetailController(
      this._argument, 
      this._getPatientDetailUC, 
      this._getGenderParamTypeUC, 
      this._updatePatientUC,
      this._deletePatientUC,
      this._getListPatientNoteUC,
      this._addPatientNoteUC,
      this._editNoteUC,
      this._deleteNoteUC,
      this._getListAssessmentByPatientUC
  );

  @override
  void onReady() {
    super.onReady();
    getUserDetailInfo();
  }

  void getUserDetailInfo() async {
    try {
      final patientId = _argument['patientId'];
      final genderParamTypes = _getGenderParamTypeUC.execute();
      final resp = await _getPatientDetailUC.execute(patientId.toString());
      vm.value.update(patient: resp.data, genderParamType: genderParamTypes);
      vm.refresh();
    } catch (_) {}
  }

  void onTapAvatar({
   Function? onSuccess,
   Function(String)? onError
  }) async {
    try {
      final resp = await HiviService.instance.uploadImageUC.execute();
      final updatedPatientInfo = vm.value.patientEntity.copyWith(avatar: resp.data);
      final request = UpdatePatientRequest(updatedPatientInfo);
      final resp1 = await _updatePatientUC.execute(request);
      vm.value.update(patient: resp1.data, shouldReloadData: true);
      vm.refresh();
      onSuccess?.call();
    } catch (error) {
      HandleNetworkError.handleNetworkError(error, (message, _, __) => onError?.call(message));
    }
  }

  void onTapDeleteButton({
    Function? onSuccess,
    Function(String)? onError
  }) async {
    try {
      final patientId = _argument['patientId'];
      await _deletePatientUC.execute(patientId.toString());
      vm.value.update(shouldReloadData: true);
      onSuccess?.call();
    } catch (error) {
      log(error.toString());
      HandleNetworkError.handleNetworkError(error, (message, _, __) => onError?.call(message));
    }
  }

  void onTapCreateNote(
    String text, {
    Function? onSuccess,
    Function(String)? onError
  }) async {
    try {
      final patientId = _argument['patientId'];
      await _addPatientNoteUC.execute(patientId.toString(), text);
      onSuccess?.call();
    } catch (error) {
      log(error.toString());
      HandleNetworkError.handleNetworkError(error, (message, _, __) => onError?.call(message));
    }
  }

  void handleOnTapPatientDetailWidget(int index) {
    if (index == 2) {
      getListNote(0);
    } else if (index == 1) {
      getListAssessment(0);
    }
  }

  void getListNote(int page) async {
    try {
      final patientId = _argument['patientId'];
      final resp = await _getListPatientNoteUC.execute(patientId.toString(), page + 1, AppConstant.pageLimit);
      vm.value.update(
          listNote: resp.data,
          noteTotalPage: resp.totalPage,
          noteTotalItem: resp.totalItem,
          noteCurrentPage: page,
          notePageLimit: AppConstant.pageLimit
      );
      vm.refresh();
    } catch (error) {
      log(error.toString());
    }
  }

  void onTapEditNote(
      String noteId,
      String description, {
        Function? onSuccess,
        Function(String)? onError
    }) async {
    try {
      await _editNoteUC.execute(noteId, description);
      onSuccess?.call();
    } catch (error) {
      log(error.toString());
      HandleNetworkError.handleNetworkError(error, (message, _, __) => onError?.call(message));
    }
  }

  void onTapDeleteNote(
      String noteId, {
        Function? onSuccess,
        Function(String)? onError
  }) async {
    try {
      await _deleteNoteUC.execute(noteId);
      onSuccess?.call();
    } catch (error) {
      log(error.toString());
      HandleNetworkError.handleNetworkError(error, (message, _, __) => onError?.call(message));
    }
  }

  void reloadListNote() {
    final currentPage = vm.value.noteCurrentPage;
    getListNote(currentPage);
  }

  void getListAssessment(int page) async {
    final patientId = _argument['patientId'];
    final resp = await _getListAssessmentByPatientUC.execute(page + 1, AppConstant.pageLimit, patientId: patientId.toString());
    vm.value.update(
        listAssessment: resp.data,
        assessmentTotalPage: resp.totalPage,
        assessmentTotalItem: resp.totalItem,
        assessmentCurrentPage: page,
        assessmentPageLimit: AppConstant.pageLimit
    );
    vm.refresh();
  }
}