import 'package:flutter_aitriage/aitriage_core/network/common/base_request.dart';
import 'package:flutter_aitriage/aitriage_core/service/hivi_service/response/get_list_country_language_response.dart';
import '../../../aitriage_core/common/app_env.dart';
import '../../../aitriage_core/network/common/base_response.dart';
import '../../../aitriage_core/network/provider/get_base_provider.dart';
import '../../config/patient_module_api_route.dart';
import '../../domain/repository/patient_repository.dart';
import '../api/query/list_patient_query.dart';
import '../api/query/patient_detail_query.dart';
import '../api/request/update_patient_request.dart';
import '../api/response/patient_detail_response.dart';
import '../api/response/patient_response.dart';

class PatientRepositoryImpl extends PatientRepository {
  final _provider = GetConnectBaseProvider(url: AppEnvironment.baseUrl);

  @override
  Future<GetListCountryLanguageResponse> getNationality() async {
    final resp = await _provider.get(PatientModuleApiRoute.getNationality);
    return _provider.convertResponse(resp, (json) => GetListCountryLanguageResponse.fromJson(json));
  }

  @override
  Future<BaseResponse> addPatient(BaseRequest request, String accountId) async {
    final resp = await _provider.post(PatientModuleApiRoute.addPatient.replaceFirst('%s', accountId), request.toRequest());
    return _provider.convertResponse(resp, (json) => BaseResponse.fromJson(json));
  }

  @override
  Future<PatientResponse> getListPatient(String accountId, int page, int limit, {String? searchParam}) async {
    final query = ListPatientQuery(page, limit, 'ACTIVE', search: searchParam);
    final resp = await _provider.get(PatientModuleApiRoute.getAllPatient.replaceFirst('%s', accountId), query: query.toQuery);
    return _provider.convertResponse(resp, (json) => PatientResponse.fromJson(json));
  }

  @override
  Future<PatientDetailResponse> getPatientDetail(String accountId, String customerId) async {
    final query = PatientDetailQuery(customerId);
    final resp = await _provider.get(PatientModuleApiRoute.getPatientDetail.replaceFirst('%s', accountId), query: query.toQuery);
    return _provider.convertResponse(resp, (json) => PatientDetailResponse.fromJson(json));
  }

  @override
  Future<PatientDetailResponse> updatePatient(UpdatePatientRequest request, String accountId) async {
    final resp = await _provider.put(PatientModuleApiRoute.updatePatient.replaceAll('%s', accountId), request.toRequest());
    return _provider.convertResponse(resp, (json) => PatientDetailResponse.fromJson(json));
  }

  @override
  Future<BaseResponse> deletePatient(String accountId, String patientId) async {
    final resp = await _provider.delete(PatientModuleApiRoute.deletePatient.replaceAll('%s', accountId), query: {'customerId' : patientId});
    return _provider.convertResponse(resp, (json) => BaseResponse.fromJson(json));
  }
}