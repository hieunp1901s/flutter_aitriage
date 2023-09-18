import 'package:flutter_aitriage/aitriage_core/entity/user_info.dart';

import '../repository/active_user_repository.dart';

enum ActiveUserInformationUseCase {accessToken, refreshToken, userInfo}

extension ActiveUserInfomationX on ActiveUserInformationUseCase{
  Future<dynamic> getData({String key = ''}) async{
    switch(this){
      case ActiveUserInformationUseCase.accessToken:
        return await ActiveUserRepository().getUserAccessToken(accessTokenKey: ActiveUserInformationUseCase.accessToken.securedKey);

      case ActiveUserInformationUseCase.refreshToken:
        return '';

      case ActiveUserInformationUseCase.userInfo:
        return await ActiveUserRepository().getUserInfo(userKey: key);

      default:
        return '';
    }
  }

  String get securedKey{
    switch(this){
      case ActiveUserInformationUseCase.userInfo:
        return '';
      case ActiveUserInformationUseCase.accessToken:
        return 'ACCESS_TOKEN';
      case ActiveUserInformationUseCase.refreshToken:
        return "REFRESH_TOKEN";
    }
  }
}

extension ActiveUserInfomationY on ActiveUserInformationUseCase{
  Future<void> setSecuredData({String key = '', required dynamic data}) async {
    switch(this){ 
      case ActiveUserInformationUseCase.userInfo:
        await ActiveUserRepository().setUserInfo(key, data);
      case ActiveUserInformationUseCase.accessToken:
        await ActiveUserRepository().setAccessToken(ActiveUserInformationUseCase.accessToken.securedKey, data);
      case ActiveUserInformationUseCase.refreshToken:
        await ActiveUserRepository().setAccessToken(ActiveUserInformationUseCase.accessToken.securedKey, data);
    }
  }
}
