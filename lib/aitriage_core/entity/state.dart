import 'package:isar/isar.dart';
part 'state.g.dart';

@collection
class State {
  Id? isarId;
  final int? id;
  final String? name;
  final int? countryId;
  final String? countryCode;
  final String? countryName;
  final String? stateCode;
  final String? type;

  State(
      this.id,
      this.name,
      this.countryId,
      this.countryCode,
      this.countryName,
      this.stateCode,
      this.type
  );

  State.fromJson(dynamic json)
      : id = json?['id'],
        name = json?['name'],
        countryId = json?['country_id'],
        countryCode = json?['country_code'],
        countryName = json?['country_name'],
        stateCode = json?['state_code'],
        type = json?['type'];
}