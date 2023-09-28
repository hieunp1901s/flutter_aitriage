import 'package:flutter/cupertino.dart';
import 'package:flutter_aitriage/aitriage_core/entity/patient.dart';
import 'package:flutter_aitriage/aitriage_module_assessment/domain/use_case/add_patient_uc.dart';
import 'package:flutter_aitriage/aitriage_module_assessment/domain/use_case/get_city_uc.dart';
import 'package:flutter_aitriage/aitriage_module_assessment/domain/use_case/get_nationality_uc.dart';
import 'package:flutter_aitriage/aitriage_module_assessment/domain/use_case/get_state_uc.dart';
import 'package:flutter_aitriage/aitriage_module_assessment/domain/use_case/update_patient_uc.dart';
import 'package:flutter_aitriage/aitriage_module_assessment/feature/add_new_patient/add_new_patient_vm.dart';
import 'package:flutter_aitriage/aitriage_module_auth/widget/drop_down_button.dart';
import 'package:flutter_aitriage/aitriage_module_main/feature/home_main/home_main_controller.dart';
import 'package:get/get.dart';
import '../../../aitriage_core/network/handle_error/handle_error.dart';
import '../../../aitriage_core/util/active_user/active_user.dart';
import '../../../aitriage_core/util/date_time_parse_util.dart';
import '../../domain/use_case/get_gender_type_param_uc.dart';
import '../../domain/use_case/get_race_uc.dart';

class AddNewPatientController extends GetxController {
  final GetGenderParamTypeUseCase _genderParamTypeUC;
  final GetRaceUseCase _getRaceUC;
  final GetNationalityUseCase _getNationalityUC;
  final GetCityUseCase _getCityUC;
  final GetStateUseCase _getStateUC;
  final AddPatientUseCase _addPatientUC;
  final UpdatePatientUseCase _updatePatientUC;
  final vm = AddNewPatientVM().obs;
  // Text Field controller
  final mrnController = TextEditingController();
  final patientNameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  // Dropdown controller
  final nationalityController = DropDownWrapperController();
  final stateController = DropDownWrapperController();
  final cityController = DropDownWrapperController();
  final genderController = DropDownWrapperController();
  final raceController = DropDownWrapperController();

  AddNewPatientController(
      this._genderParamTypeUC,
      this._getRaceUC,
      this._getNationalityUC,
      this._getCityUC,
      this._getStateUC,
      this._addPatientUC,
      this._updatePatientUC
      );

  @override
  void onInit() async {
    super.onInit();
    await _initParam();
    _initPatient();
  }

  Future _initParam() async {
    final location = Get.isRegistered<HomeMainController>()
        ? Get.find<HomeMainController>().currentLocation
        : null;
    final locationId = location?.id;
    final countryId = location?.countryId;
    final phoneCode = location?.countryCode;
    final genders = _genderParamTypeUC.execute();
    final races = _getRaceUC.execute();
    final nationalities = await _getNationalityUC.execute();
    final cities = _getCityUC.execute(locationId.toString());
    final states = _getStateUC.execute(locationId.toString());
    vm.value.update(
        genders: genders,
        races: races,
        nationalities: nationalities,
        cities: cities,
        states: states,
        locationId: locationId,
        countryId: countryId,
        phoneCode: phoneCode
    );
    vm.refresh();
  }

  void _initPatient() {
    final argument = Get.arguments;

    // Edit patient will have argument
    if (argument is Patient) {
      vm.value.update(patientScreenType: PatientScreenType.edit, patient: argument);
      vm.refresh();
      // Set value for text field
      // final dob = argument.birthday ?? argument.yearOfBirth?.toString() ?? '';
      final dob = DateTimeParserUtil().backendFormatToAppFormat(
          argument.birthday ?? argument.yearOfBirth?.toString() ?? '');
      mrnController.text = argument.code ?? '';
      patientNameController.text = argument.fullName ?? '';
      dobController.text = dob;
      phoneController.text = argument.phone ?? '';
      emailController.text = argument.email ?? '';
      addressController.text = argument.address ?? '';
      descriptionController.text = argument.description ?? '';
      // NEED TO REFACTOR LOGIC
      vm.value.setFirstTimeMRN();
      vm.value.setFirstTimeNationality();
      vm.value.setFirstTimeDateOfBirth();
      vm.value.setFirstTimePatientCity();
      vm.value.setFirstTimePatientGender();
      vm.value.setFirstTImePatientRace();
      vm.value.setFirstTimePatientState();
      vm.value.setFirstTimePatientName();
      // update vm
      onInfoChange(
        mrn: argument.code,
        patientName: argument.fullName,
        dob: dob,
        phone: argument.phone ?? '',
        email: argument.email ?? '',
        address: argument.address ?? '',
        description: argument.description ?? '',
      );

      // state is a dependency of city
      // need to update state before city, order of running matter
      // don't change
      final nationalityIndex = vm.value.getNationalityIndex(argument.nationalityName);
      if (nationalityIndex != -1) {
        onTapNationality(nationalityIndex);
        nationalityController.value = nationalityIndex;
      }

      final stateIndex = vm.value.getStateIndex(argument.stateName);
      if (stateIndex != -1) {
        onTapState(stateIndex);
        stateController.value = stateIndex;
      }

      final cityIndex = vm.value.getCityIndex(argument.cityName ?? '');
      if (cityIndex != -1) {
        onTapCity(cityIndex);
        cityController.value = cityIndex;
      }

      final genderIndex = vm.value.getGenderIndex(argument.gender);
      if (genderIndex != -1) {
        onTapGender(genderIndex);
        genderController.value = genderIndex;
      }

      final raceIndex = vm.value.getRaceIndex(argument.raceName ?? '');
      if (raceIndex != -1) {
        onTapRace(raceIndex);
        raceController.value = raceIndex;
      }
    } else {
      vm.value.update(patientScreenType: PatientScreenType.add);
      vm.refresh();
    }
  }

  void onTapSavePatient({
    Function? onSuccess,
    Function? onError
  }) async {
    final type = vm.value.patientScreenType;

    if (type == PatientScreenType.add) {
      try {
        final request = vm.value.getAddPatientRequest;
        final user = await ActiveUserUtil.userInfo;
        await _addPatientUC.execute(request, user.accountId.toString());
        onSuccess?.call();
      } catch (e) {
        HandleNetworkError.handleNetworkError(e, (message, _, __) => onError?.call(message));
      }
    } else {
      try {
        final patient = vm.value.getEditPatient;
        final user = await ActiveUserUtil.userInfo;
        await _updatePatientUC.execute(patient, user.accountId.toString());
        onSuccess?.call();
      } catch (e) {
        HandleNetworkError.handleNetworkError(e, (message, _, __) => onError?.call(message));
      }
    }
  }

  void onInfoChange({
    String? mrn,
    String? patientName,
    String? dob,
    int? genderIndex,
    int? raceIndex,
    String? phone,
    String? email,
    int? nationalityIndex,
    int? stateIndex,
    int? cityIndex,
    String? address,
    String? description
  }) {
    // update value for request only, not change view
    vm.value.update(
        mrn: mrn,
        patientName: patientName,
        date: dob,
        genderIndex: genderIndex,
        raceIndex: raceIndex,
        phone: phone,
        email: email,
        nationalityIndex: nationalityIndex,
        stateIndex: stateIndex,
        cityIndex: cityIndex,
        address: address,
        description: description
    );
    vm.refresh();
  }

  void onTapNationality(int index) {
    vm.value.setFirstTimeNationality();
    onInfoChange(nationalityIndex: index);
  }

  void onTapState(int index) {
    vm.value.setFirstTimePatientState();
    cityController.value = 0;
    vm.value.setFirstTimePatientCity();
    onInfoChange(stateIndex: index, cityIndex: 0);
  }

  void onTapCity(int index) {
    vm.value.setFirstTimePatientCity();
    onInfoChange(cityIndex: index);
  }

  void onTapGender(int index) {
    vm.value.setFirstTimePatientGender();
    onInfoChange(genderIndex: index);
  }

  void onTapRace(int index) {
    vm.value.setFirstTImePatientRace();
    onInfoChange(raceIndex: index);
  }
}