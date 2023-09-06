import 'package:flutter_aitriage/aitriage_core/network/handle_error/handle_error.dart';
import 'package:flutter_aitriage/aitriage_core/util/alert/alert_util.dart';
import 'package:flutter_aitriage/aitriage_core/util/crypto/crypto.dart';
import 'package:flutter_aitriage/aitriage_module_auth/data/api/request/verify_login_request.dart';
import 'package:flutter_aitriage/aitriage_module_auth/domain/use_case/verify_email_uc.dart';
import 'package:get/get.dart';
import '../../../aitriage_core/service/local_storage_service.dart';
import '../../data/api/request/verify_email_request.dart';

class VerifyEmailController extends GetxController {
  final VerifyEmailUseCase _uc;
  var _verifyCode = '';

  VerifyEmailController(this._uc);

  void onInputCompleted(String verifyCode) => _verifyCode = verifyCode;

  void onSubmit() async {
    if(Get.arguments['userName'] == null){
      _onRegisterSubmit();
    } else {
      _onLoginSubmit();
    }
  }


  Future<void> _onRegisterSubmit() async {
    final argument = Get.arguments;
    final request = VerifyEmailRequest(
        email: argument?['email'],
        verificationCode: _verifyCode
    );

    try {
      AlertUtil.showLoadingIndicator();
      final resp = await _uc.execute(request);
      Get.snackbar('Success', resp.message.toString());
      AlertUtil.closeAllAlert();
    } catch (e) {
      AlertUtil.closeAllAlert();
      HandleNetworkError.handleNetworkError(e, (message, _, __) => Get.snackbar('Error', message));
    }
  }

  void _onLoginSubmit() async {
    final argument = Get.arguments;
    final userName = argument?['userName'];
    final password = await CryptoUtil.encrypt(argument?['password']);
    final request = VerifyLoginRequest(
        userName: argument?['userName'],
        password: await CryptoUtil.encrypt(argument?['password']),
        verificationCode: _verifyCode);

    try {
      AlertUtil.showLoadingIndicator();
      final resp = await _uc.loginWithVerificationCode(request);
      Get.snackbar('Success', resp.message.toString());
      LocalStorageService().setSecuredUser(userName: userName, password: password);
      AlertUtil.closeAllAlert();
    } catch (e) {
      AlertUtil.closeAllAlert();
      HandleNetworkError.handleNetworkError(
          e, (message, _, __) => Get.snackbar('Error', message));
    }
  }
}

