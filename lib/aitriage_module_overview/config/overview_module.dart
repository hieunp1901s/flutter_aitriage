import 'package:get/get_navigation/src/routes/get_route.dart';
import '../../aitriage_core/common/app_module.dart';
import 'overview_page_route.dart';

class OverviewModule extends AppModule {
  @override
  List<GetPage> createRoutes() => OverviewPageRoute.createRoutes();
}