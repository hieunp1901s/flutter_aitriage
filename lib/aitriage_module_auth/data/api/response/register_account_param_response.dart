
import 'package:flutter_aitriage/aitriage_module_auth/domain/entity/register_account_param.dart';
import '../../../../aitriage_core/network/common/base_response.dart';

class RegisterAccountParamResponse extends BaseResponse {
  final data = <RegisterAccountParam>[];

  RegisterAccountParamResponse.fromJson(dynamic json) : super.fromJson(json) {
    data.addAll((json?['data'] as List).map((e) => RegisterAccountParam.fromJson(e)).toList());
  }
}