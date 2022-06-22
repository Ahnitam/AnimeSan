import 'package:animesan/animesan.dart';
import 'package:animesan/controllers/login_controller.dart';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dependencies();
  runApp(const AnimeSan());
}

Future<void> dependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefer = Get.put<SharedPreferences>(await SharedPreferences.getInstance());
  final ModuleController moduleController = Get.put<ModuleController>(ModuleController(prefer: prefer));
  Get.put(SettingsController(prefer: prefer));
  Get.put(LoginController(moduleController: moduleController, prefer: prefer));
}
