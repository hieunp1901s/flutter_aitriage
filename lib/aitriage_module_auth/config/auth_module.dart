import 'package:get/get_navigation/src/routes/get_route.dart';
import '../../aitriage_core/common/app_module.dart';
import 'auth_module_page_route.dart';

class AuthModule extends AppModule {
  @override
  List<GetPage> createRoutes() => AuthModulePageRoute.createRoutes();
}