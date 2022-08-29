import 'package:animesan/utils/colors.dart';
import 'package:animesan/views/config_view.dart';
import 'package:animesan/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimeSan extends StatelessWidget {
  const AnimeSan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[500],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: appPrimaryColor,
        ),
      ),
      themeMode: ThemeMode.dark,
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => const Home()),
        GetPage(name: "/config", page: () => const Config()),
      ],
    );
  }
}
