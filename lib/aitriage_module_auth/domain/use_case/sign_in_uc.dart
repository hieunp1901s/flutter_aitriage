import 'package:flutter_aitriage/aitriage_core/util/active_user/active_user.dart';
import 'package:flutter_aitriage/aitriage_core/service/hivi_service/hivi_service.dart';
import 'package:flutter_aitriage/aitriage_module_auth/data/api/request/sign_in_request.dart';
import 'package:flutter_aitriage/aitriage_module_auth/data/api/response/user_param_response.dart';
import 'package:flutter_aitriage/aitriage_module_auth/data/repository/sign_in_repository.dart';
import 'package:flutter_aitriage/aitriage_module_auth/data/repository/sign_up_repository.dart';
import 'package:get/get.dart';
import '../../../aitriage_core/entity/user_info.dart';
import '../../../aitriage_core/network/common/base_response.dart';
import '../../data/api/request/generate_code_request.dart';

abstract class SignInUseCase {
  Future<UserParamResponse> execute(SignInRequest request);

  Future<BaseResponse> genCodeForSignIn(String email);

  Future<UserInfo> onlineSignIn(SignInRequest request);

  Future<String> offlineSignIn(SignInRequest request);
}

class SignInUseCaseImpl extends SignInUseCase {
  final SignInRepositoryImpl _repository;
  final SignUpRepositoryImpl _genCodeRepository;
  final hiviService = HiviService.instance;

  SignInUseCaseImpl(this._repository, this._genCodeRepository);

  @override
  Future<UserParamResponse> execute(SignInRequest request) async {
    final result = await _repository.signIn(request);
    return result;
  }

  @override
  Future<BaseResponse> genCodeForSignIn(String email) async {
    final request = GenerateCodeRequest(email: email, reason: 'VERIFY_EMAIL');
    final result = await _genCodeRepository.generateCodeEmail2Fa(request);
    return result;
  }

  @override
  Future<String> offlineSignIn(SignInRequest request) async {
    // final password = request.password;
    //     final key = '${AppConstant.preCharSaveUserData}${request.username}';
    //     if(password == await LocalStorageService().getSecuredUserPassword(userName: request.username)){
    //       final timePast = (DateTime.now().difference(await LocalStorageService().getFirstDateOffline())).inDays;
    //       if(timePast > 7) {
    //         Get.dialog(const AlertDialog(title: Text('Expired 7 Day'),));
    //       } else {
    //         final result = await LocalStorageService().getUserData(key: key);
    //         LocalStorageService().setFirstDateOffline();
    //         LocalStorageService().setCurrentAccessToken(accessToken: result.accessToken ?? '');
    //         // temp value
    //         // return UserInfo.fromJson();

    //       }
    //     }
    return '';
  }

  @override
  Future<UserInfo> onlineSignIn(SignInRequest request) async {
      final result = await execute(request);
      await ActiveUserUtil.setAccessToken(result.data.accessToken ?? '');
      final resp =
          await hiviService.getUserInfoUC.execute(result.data.id ?? 0);
      if(resp.data.email != null){
        await ActiveUserUtil.setUserInfo(resp.data);
      }
      return resp.data;

  }
}
