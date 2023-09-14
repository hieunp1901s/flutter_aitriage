import 'package:flutter_aitriage/aitriage_core/service/hivi_service/response/get_list_country_language_response.dart';
import 'package:flutter_aitriage/aitriage_module_assessment/config/assessment_module_api_route.dart';
import '../../../aitriage_core/common/app_env.dart';
import '../../../aitriage_core/network/provider/get_base_provider.dart';
import '../../domain/repository/patient_repository.dart';

class PatientRepositoryImpl extends PatientRepository {
  final _provider = GetConnectBaseProvider(url: AppEnvironment.baseUrl);

  @override
  Future<GetListCountryLanguageResponse> getNationality() async {
    final resp = await _provider.get(AssessmentModuleApiRoute.getNationality);
    return _provider.convertResponse(resp, (json) => GetListCountryLanguageResponse.fromJson(json));
  }
}