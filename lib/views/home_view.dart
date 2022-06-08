import 'package:animesan/components/search_with_buttom.dart';
import 'package:animesan/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final controller = Get.put(HomeController());

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          SearchButtom(
            margin: const EdgeInsets.all(10),
            label: "ANIME",
            onSubmit: _onSubmit,
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  void _onSubmit(String text) {}
}
