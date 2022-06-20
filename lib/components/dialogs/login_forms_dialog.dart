import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/models/login/login_form.dart';
import 'package:animesan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginForms extends StatelessWidget {
  final List<LoginForm> loginForms;
  final void Function(int) onSelect;
  const LoginForms({Key? key, required this.loginForms, required this.onSelect}) : super(key: key);

  final radius = 20.0;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 0,
            maxHeight: 250,
          ),
          decoration: BoxDecoration(
            color: appGreyColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              loginForms.length,
              (index) => option(loginForms[index].name, index, onSelect),
            ),
          ),
        ),
      ),
    );
  }

  Widget option(String name, int index, void Function(int) onSelect) {
    return CustomButtom(
      color: appGreyColor,
      height: 40,
      width: double.infinity,
      borderRadius: BorderRadius.zero,
      padding: const EdgeInsets.only(left: 10, right: 10),
      onPressed: () {
        onSelect(index);
        Get.back();
      },
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontFamily: "Bree Serif",
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
