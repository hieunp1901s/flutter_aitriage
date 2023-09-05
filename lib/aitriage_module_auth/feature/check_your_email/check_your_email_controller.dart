import 'package:get/get.dart';
import '../../../aitriage_core/network/handle_error/handle_error.dart';
import '../../data/api/query/forget_password_query.dart';
import '../../domain/use_case/send_password_reset_verified_code.dart';

class CheckYourEmailController extends GetxController{
  final SendPasswordResetVerifiedCodeUseCase _uc;
  var userEmail = ''.obs;

  CheckYourEmailController(this._uc);

  @override
  void onInit() {
    super.onInit();
    userEmail.value = Get.arguments?['email'] ?? '';
  }

  void openEmailApp() {

  }

  void resend(Function? resendCodeSuccess) async {
    final query = ForgetPasswordQuery(userEmail.value);

    try {
      await _uc.execute(query);
      resendCodeSuccess?.call();
    } catch (e) {
      HandleNetworkError.handleNetworkError(e, (message) => Get.snackbar('Error', message));
    }
  }
}