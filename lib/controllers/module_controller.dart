import 'package:animesan/models/mixins.dart';
import 'package:animesan/models/module.dart';
import 'package:animesan/modules/StreamModule/crunchyroll.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModuleController {
  final List<Module> _modules = [CrunchyrollModule()];
  late final SharedPreferences _prefer;

  ModuleController({required SharedPreferences prefer}) {
    _prefer = prefer;
    _verifyModules();
  }

  void _verifyModules() {
    for (var module in modules) {
      module.isEnabled = _prefer.getBool(
            "${module is StreamModule ? "stream" : module is InfoModule ? "info" : throw Exception("Modulo não suportado")}_${module.id}_isEnabled",
          ) ??
          false;
    }
  }

  enableSwitchModule(Module module, bool value) {
    module.isEnabled = value;
    _prefer.setBool(
      "${module is StreamModule ? "stream" : module is InfoModule ? "info" : throw Exception("Modulo não suportado")}_${module.id}_isEnabled",
      value,
    );
  }

  List<Module> get modules => _modules;
  List<StreamModule> get streamModules => _modules.whereType<StreamModule>().toList(growable: false);
  List<InfoModule> get infoModules => _modules.whereType<InfoModule>().toList(growable: false);
  List<StreamModule> get streamModulesEnabled => streamModules.where((module) => module.isEnabled).toList(growable: false);
  List<InfoModule> get infoModulesEnabled => infoModules.where((module) => module.isEnabled).toList(growable: false);

  StreamModule? getStreamModuleById(String? id, {bool enabledOnly = false}) {
    try {
      return enabledOnly ? streamModulesEnabled.firstWhere((module) => module.id == id) : streamModules.firstWhere((module) => module.id == id);
    } catch (e) {
      return null;
    }
  }
}
