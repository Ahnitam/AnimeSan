import 'package:animesan/models/mixins.dart';
import 'package:animesan/models/module.dart';
import 'package:animesan/modules/StreamModule/crunchyroll.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModuleController {
  final List<Module> _modules = [CrunchyrollModule()];
  late final SharedPreferences _prefer;

  Rx<StreamModule?> _selectedStreamModule = null.obs;
  StreamModule? _streamPadrao;
  InfoModule? _infoPadrao;

  ModuleController({required SharedPreferences prefer}) {
    _prefer = prefer;
    _verifyModules();
  }

  void _verifyModules() {
    // String _streamPadrao = _moduleController.getStreamModuleById(_prefer.getString("idStreamPadrao"), enabledOnly: true);
    for (var module in modules) {
      module.isEnabled = _prefer.getBool(
            "${module is StreamModule ? "stream" : module is InfoModule ? "info" : throw Exception("Modulo não suportado")}_${module.id}_isEnabled",
          ) ??
          false;

      if (module is StreamModule && module.id == _prefer.getString("idStreamPadrao") && module.isEnabled) {
        _streamPadrao = module;
        _selectedStreamModule = module.obs;
      } else if (module is InfoModule && module.id == _prefer.getString("idInfoPadrao") && module.isEnabled) {
        _infoPadrao = module;
      }
    }
  }

  enableSwitchModule(Module module, bool value) {
    if (!value && _selectedStreamModule.value == module) {
      _selectedStreamModule.value = null;
    }
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

  Rx<StreamModule?> get selectedStreamModule => _selectedStreamModule;

  void setSelectedStreamModule(StreamModule? module) {
    _selectedStreamModule.value = module;
  }

  StreamModule? get streamPadrao => _streamPadrao;

  set streamPadrao(StreamModule? value) {
    _streamPadrao = value;
    if (value != null) {
      _prefer.setString("idStreamPadrao", value.id);
    } else {
      _prefer.remove("idStreamPadrao");
    }
  }

  InfoModule? get infoPadrao => _infoPadrao;

  set infoPadrao(InfoModule? value) {
    _infoPadrao = value;
    if (value != null) {
      _prefer.setString("idInfoPadrao", value.id);
    } else {
      _prefer.remove("idInfoPadrao");
    }
  }
}
