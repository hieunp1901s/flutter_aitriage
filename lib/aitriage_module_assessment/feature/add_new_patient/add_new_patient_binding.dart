import 'package:get/get.dart';
import '../../data/repository/patient_repository.dart';
import '../../domain/use_case/get_gender_uc.dart';
import '../../domain/use_case/get_nationality_uc.dart';
import '../../domain/use_case/get_race_uc.dart';
import 'add_new_patient_controller.dart';

class AddNewPatientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetGenderUseCaseImpl());
    Get.lazyPut(() => GetRaceUseCaseImpl());
    Get.lazyPut(() => PatientRepositoryImpl());
    Get.lazyPut(() => GetNationalityUseCaseImpl(Get.find<PatientRepositoryImpl>()));
    Get.lazyPut(() => AddNewPatientController(
        Get.find<GetGenderUseCaseImpl>(),
        Get.find<GetRaceUseCaseImpl>(),
        Get.find<GetNationalityUseCaseImpl>()
    ));
  }
}