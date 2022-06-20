import 'package:animesan/components/custom_buttom.dart';
import 'package:animesan/components/dialogs/login_forms_dialog.dart';
import 'package:animesan/components/login_info.dart';
import 'package:animesan/components/logo.dart';
import 'package:animesan/controllers/login_controller.dart';
import 'package:animesan/models/login/field.dart';
import 'package:animesan/models/login/login_form.dart';
import 'package:animesan/models/module.dart';
import 'package:animesan/utils/colors.dart';
import 'package:animesan/utils/states.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModuleLoginDialog extends StatelessWidget {
  final Module module;
  final double radius = 20.0;
  late final Rx<int> _selectedIndex;
  ModuleLoginDialog({Key? key, required this.module}) : super(key: key) {
    _selectedIndex = module.loginForms.isNotEmpty ? 0.obs : (-1).obs;
  }

  final LoginController _loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: 200,
            maxHeight: 300,
          ),
          decoration: BoxDecoration(
            color: appGreyColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Obx(
              () {
                if (_selectedIndex.value != -1) {
                  final LoginForm loginForm = module.loginForms[_selectedIndex.value];
                  if (module.login.state.value == LoginState.logado) {
                    return LoginInfo(module: module);
                  } else if (module.login.state.value == LoginState.carregando) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: AnimeSanLogo(
                          height: 60,
                          enableTitle: false,
                          loading: true,
                        ),
                      ),
                    );
                  } else {
                    final List<Widget> widgets = [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CustomButtom(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          color: appBackgroudColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(radius),
                          height: 40,
                          width: double.infinity,
                          onPressed: () => Get.dialog(
                            LoginForms(
                              loginForms: module.loginForms,
                              onSelect: (index) => _selectedIndex.value = index,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  loginForm.name,
                                  style: const TextStyle(
                                    fontFamily: "Bree Serif",
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ];
                    final List<TextEditingController> controllers = List.empty(growable: true);
                    for (var field in loginForm.fields.values) {
                      final TextEditingController textController = TextEditingController();
                      controllers.add(textController);
                      widgets.add(textField(field, textController));
                    }
                    widgets.add(
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: CustomButtom(
                          borderRadius: BorderRadius.circular(radius),
                          height: 40,
                          width: 150,
                          onPressed: () {
                            for (int i = 0; i < loginForm.fields.length; i++) {
                              loginForm.fields[loginForm.fields.keys.elementAt(i)]!.value = controllers[i].text;
                            }
                            _loginController.logar(module, loginForm.id);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: "Bree Serif",
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: widgets,
                    );
                  }
                } else {
                  return const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Não há necessidade de Login',
                      style: TextStyle(
                        fontFamily: "Bree Serif",
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(Field field, TextEditingController textController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: appBackgroudColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: TextField(
            keyboardType: TextInputType.text,
            obscureText: !field.isVisible,
            controller: textController,
            textAlignVertical: TextAlignVertical.bottom,
            style: const TextStyle(
              fontFamily: "Bree Serif",
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0.0),
              isDense: true,
              labelText: field.name,
              labelStyle: const TextStyle(
                fontFamily: "Bree Serif",
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
