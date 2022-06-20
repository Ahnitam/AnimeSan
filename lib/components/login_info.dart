import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/controllers/login_controller.dart';
import 'package:animesan/models/login/field.dart';
import 'package:animesan/models/module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginInfo extends StatelessWidget {
  final Module module;
  final LoginController _loginController = Get.find<LoginController>();
  LoginInfo({Key? key, required this.module}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _widgets(),
    );
  }

  List<Widget> _widgets() {
    final List<Field> visibleFields = module.login.getVisibleFields();
    final List<Widget> widgets = List.generate(
      visibleFields.length,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                "${visibleFields[index].name}: ",
                style: const TextStyle(
                  fontFamily: "Bree Serif",
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                visibleFields[index].value.toString(),
                style: const TextStyle(
                  fontFamily: "Bree Serif",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );

    widgets.add(
      CustomButtom(
        height: 40,
        width: 150,
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
        onPressed: () => _loginController.logout(module),
        child: const Text(
          "Logout",
          style: TextStyle(
            fontFamily: "Bree Serif",
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );

    return widgets;
  }
}
