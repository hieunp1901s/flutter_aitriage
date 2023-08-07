import 'package:flutter/material.dart';
import 'package:flutter_aitriage/aitriage_core/ui/widget/device_detector.dart';
import 'package:flutter_aitriage/aitriage_module_overview/config/overview_route.dart';
import 'package:flutter_aitriage/aitriage_module_overview/feature/home_overview/home_overview_controller.dart';
import 'package:get/get.dart';

class HomeOverviewScreen extends StatelessWidget {
  const HomeOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DeviceDetector(
        tablet: _HomeOverviewScreenTablet(),
        phone: _HomeOverviewScreenPhone()
    );
  }
}

class _HomeOverviewScreenTablet extends GetView<HomeOverviewController> {
  const _HomeOverviewScreenTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _HomeOverviewScreenPhone extends GetView<HomeOverviewController> {
  const _HomeOverviewScreenPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // onTap: () => Get.to(Scaffold(
        //   body: GestureDetector(
        //     onTap: () => Get.back(id: 1000),
        //     child: Container(color: Colors.black, width: 200, height: 200,),
        //   ),
        // ), id: 1000),
          onTap: () => Get.toNamed(OverviewRoute.initialRoute),
          child: Container(width: 200, height: 200, color: Colors.red)),
    );
  }
}


