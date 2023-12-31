import 'package:isar/isar.dart';
part 'system_param.g.dart';

@collection
class SystemParam {
  Id? isarId;
  final String? systemPathFileCountries;
  final String? systemAppBaseUrl;
  final String? systemAppColor;
  final String? systemAppEmailMarketing;
  final String? systemUrlPrivacyPolicy;
  final String? systemAppName;
  final String? trialTime;
  final String? systemAppBackgroundColor;
  final String? systemAppEmailSupport;
  final String? systemUrlTerms;
  final String? systemPathFileCity;
  final String? systemPathFileStates;

  SystemParam(
      this.isarId,
      this.systemPathFileCountries,
      this.systemAppBaseUrl,
      this.systemAppColor,
      this.systemAppEmailMarketing,
      this.systemUrlPrivacyPolicy,
      this.systemAppName,
      this.trialTime,
      this.systemAppBackgroundColor,
      this.systemAppEmailSupport,
      this.systemUrlTerms,
      this.systemPathFileCity,
      this.systemPathFileStates);

  SystemParam.fromJson(dynamic json)
      : systemPathFileCountries = json?['system.path.file.countries'],
        systemAppBaseUrl = json?['system.app.base.url'],
        systemAppColor = json?['system.app.color'],
        systemAppEmailMarketing = json?['system.app.email.marketing'],
        systemUrlPrivacyPolicy = json?['system.url.privacy.policy'],
        systemAppName = json?['system.app.name'],
        trialTime = json?['trial.time'],
        systemAppBackgroundColor = json?['system.app.background.color'],
        systemAppEmailSupport = json?['system.app.email.support'],
        systemUrlTerms = json?['system.url.terms'],
        systemPathFileCity = json?['system.path.file.cities'],
        systemPathFileStates = json?['system.path.file.states'];
}