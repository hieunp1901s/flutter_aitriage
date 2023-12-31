import 'package:flutter_aitriage/aitriage_core/entity/system_param.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../../entity/city.dart';
import '../../../entity/country.dart';
import '../../../entity/param_type.dart';
import '../../../entity/race.dart';
import '../../../entity/role.dart';
import '../../../entity/state.dart';
import '../../../entity/table_sync_date.dart';

class IsarProvider {
  IsarProvider._();

  static Isar? _isar;

  static Future init() async {
    final path = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        CitySchema,
        CountrySchema,
        ParamTypeSchema,
        RaceSchema,
        RoleSchema,
        StateSchema,
        SystemParamSchema,
        TableSyncDateSchema
      ],
      directory: path.path,
    );
  }

  static Isar get instance => _isar!;
}