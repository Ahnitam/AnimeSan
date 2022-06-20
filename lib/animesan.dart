import 'package:animesan/views/config.dart';
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
      ),
      themeMode: ThemeMode.dark,
      initialRoute: "/",
      routes: {
        "/": (context) => Home(),
        "/config": (context) => const Config(),
      },
    );
  }
}
