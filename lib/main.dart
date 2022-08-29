import 'package:animesan/animesan.dart';
import 'package:animesan/controllers/cached_animes.dart';
import 'package:animesan/controllers/login_controller.dart';
import 'package:animesan/controllers/midia_controller.dart';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/controllers/settings_controller.dart';
import 'package:animesan/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dependencies();
  runApp(const AnimeSan());
}

Future<void> dependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(CachedAnimes());

  final SharedPreferences prefer = Get.put<SharedPreferences>(await SharedPreferences.getInstance());
  Get.put(SettingsController(prefer: prefer));
  final ModuleController moduleController = Get.put<ModuleController>(ModuleController(prefer: prefer));
  Get.put(MidiaController(moduleController: moduleController));
  Get.put(LoginController(moduleController: moduleController, prefer: prefer));
}
