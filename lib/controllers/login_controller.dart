import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/login/login.dart';
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
    for (Module module in _moduleController.modules) {
      String id = "${module is StreamModule ? "stream" : module is InfoModule ? "info" : throw Exception("Modulo não suportado")}_${module.id}_login";
      module.login = Login.fromId(id, _prefer);
      _refreshLogin(module);
    }
  }

  Future<void> _refreshLogin(Module module) async {
    if (module.login.state.value == LoginState.logado) {
      try {
        module.login.changeState(LoginState.carregando);
        await module.refreshLogin();
        module.login.changeState(LoginState.logado);
      } catch (e) {
        await logout(module);
      }
    }
  }

  Future<void> logar(Module module, String loginForm) async {
    module.login.changeState(LoginState.carregando);
    try {
      await module.logar(loginForm);
      module.login.changeState(LoginState.logado);
    } catch (e) {
      await logout(module);
    }
  }

  Future<void> logout(Module module) async {
    await module.logout();
    await module.login.logout();
  }
}
