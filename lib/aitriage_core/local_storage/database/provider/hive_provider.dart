import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveProvider {
  HiveProvider._();

  static Future<void> init() async {
    final path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);

    // Hive.registerAdapter(CityAdapter());
    // Hive.registerAdapter(CountryAdapter());
    // Hive.registerAdapter(ParamTypeAdapter());
    // Hive.registerAdapter(RaceAdapter());
    // Hive.registerAdapter(RoleAdapter());
    // Hive.registerAdapter(StateAdapter());

  }

  static read() {

  }

  static write() {

  }
}