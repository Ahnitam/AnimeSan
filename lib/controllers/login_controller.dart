import 'dart:convert';
import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/models/module.dart';
import 'package:animesan/utils/states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  late final ModuleController _moduleController;
  late final SharedPreferences _prefer;

  LoginController({required ModuleController moduleController, required SharedPreferences prefer}) {
    _moduleController = moduleController;
    _prefer = prefer;
    _loadLogins();
  }

  void _loadLogins() {
    for (Module module in _moduleController.getModules()) {
      String id = "${module is StreamModule ? "stream" : module is InfoModule ? "info" : throw Exception("Modulo não suportado")}_${module.id}_login";
      module.login.id = id;
      module.login.loadLogin(json.decode(_prefer.getString(id) ?? "{}"));
      _refreshLogin(module);
    }
  }

  Future<void> _refreshLogin(Module module) async {
    if (module.login.loginForm != null) {
      try {
        module.login.state.value = LoginState.carregando;
        await module.refreshLogin();
        module.login.state.value = LoginState.logado;
      } catch (e) {
        if (module.login.state.value != LoginState.unloged) {
          await logout(module);
        }
      }
      _moduleController.saveLoginSettings(module.login);
    }
  }

  Future<void> logar(Module module, String loginForm, Map<String, String> fields) async {
    module.login.state.value = LoginState.carregando;
    try {
      await module.logar(loginForm, fields);
      module.login.state.value = LoginState.logado;
    } catch (e) {
      await logout(module);
    }
    _moduleController.saveLoginSettings(module.login);
  }

  Future<void> logout(Module module) async {
    await module.logout();
  }
}
