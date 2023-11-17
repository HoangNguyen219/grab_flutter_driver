import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grab_driver_app/common/internet/internet_controller.dart';
import 'package:grab_driver_app/controllers/auth_controller.dart';
import 'package:grab_driver_app/controllers/driver_location_controller.dart';
import 'package:grab_driver_app/controllers/map_controller.dart';
import 'package:grab_driver_app/services/auth_api_service.dart';
import 'package:grab_driver_app/views/auth/page/phone_verification_page.dart';
import 'package:grab_driver_app/views/home/page/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController(AuthService("http://10.0.2.2:6666")));

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Obx(() {
        Get.put(InternetController());
        Get.put(DriverLocationController());
        Get.put(MapController());
        return authController.userId.value != "" ? HomePage() : const PhoneVerificationPage();
      }),
    );
  }
}
