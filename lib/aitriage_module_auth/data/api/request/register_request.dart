import 'package:flutter_aitriage/aitriage_core/network/common/base_request.dart';

class RegisterRequest extends BaseRequest {
  final String accountType;
  final String operatingStatus;
  final int businessOwner;
  final String organizationName;
  final String isoCode;
  final String email;
  final String password;
  final String phone;
  final String firstName;
  final String lastName;

  RegisterRequest({
    required this.accountType,
    required this.operatingStatus,
    required this.businessOwner,
    required this.organizationName,
    required this.isoCode,
    required this.email,
    required this.password,
    required this.phone,
    required this.firstName,
    required this.lastName
  });

  @override
  Map<String, dynamic> toRequest() => {
    'accountType': accountType,
    'operatingStatus': operatingStatus,
    'businessOwner' : businessOwner,
    'organizationName' : organizationName,
    'isoCode' : isoCode,
    'email' : email,
    'password' : password,
    'phone' : phone,
    'firstName' : firstName,
    'lastName': lastName,
  };
}