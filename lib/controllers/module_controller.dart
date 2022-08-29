import 'dart:convert';

import 'package:animesan/controllers/settings_controller.dart';
import 'package:animesan/models/login/login.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/models/module.dart';
import 'package:animesan/modules/StreamModule/crunchyroll/crunchyroll.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModuleController {
  late final List<Module> _modules;
  final SharedPreferences _prefer;

  final Rx<StreamModule?> _selectedStreamModule = Rx<StreamModule?>(null);
  final Rx<InfoModule?> _selectedInfoModule = Rx<InfoModule?>(null);
  final Rx<StreamModule?> _streamPadrao = Rx<StreamModule?>(null);
  final Rx<InfoModule?> _infoPadrao = Rx<InfoModule?>(null);

  ModuleController({required SharedPreferences prefer}) : _prefer = prefer {
    _modules = [
      CrunchyrollModule(this),
    ];
    _verifyModules();
  }

  void _verifyModules() {
    for (var module in _modules) {
      module.isEnabled = _prefer.getBool(
            "${module is StreamModule ? "stream" : module is InfoModule ? "info" : throw Exception("Modulo não suportado")}_${module.id}_isEnabled",
          ) ??
          false;

      if (module is StreamModule && module.id == _prefer.getString("idStreamPadrao") && module.isEnabled) {
        _streamPadrao.value = module;
        _selectedStreamModule.value = module;
      } else if (module is InfoModule && module.id == _prefer.getString("idInfoPadrao") && module.isEnabled) {
        _infoPadrao.value = module;
        _selectedInfoModule.value = module;
      }
    }
  }

  enableSwitchModule<T extends Module>(Module module, bool isEnabled) {
    (T != StreamModule && T != InfoModule) ? throw Exception("Modulo não suportado") : null;
    if (!isEnabled && getSelectedModule<T>().value == module) {
      setSelectedModule<T>(null);
    }
    if (!isEnabled && getModulePadrao<T>().value == module) {
      setModulePadrao<T>(null);
    }
    _streamPadrao.refresh();
    _infoPadrao.refresh();
    module.isEnabled = isEnabled;
    _prefer.setBool(
      "${module is StreamModule ? "stream" : module is InfoModule ? "info" : throw Exception("Modulo não suportado")}_${module.id}_isEnabled",
      isEnabled,
    );
  }

  Rx<T?> getModulePadrao<T extends Module>() {
    if (T == StreamModule) {
      return _streamPadrao as Rx<T?>;
    } else if (T == InfoModule) {
      return _infoPadrao as Rx<T?>;
    } else {
      throw Exception("Modulo não suportado");
    }
  }

  void setModulePadrao<T extends Module>(Module? module) {
    if (module is StreamModule || (T == StreamModule && module == null)) {
      _streamPadrao.value = module as StreamModule?;
      if (module != null) {
        _prefer.setString("idStreamPadrao", module.id);
      } else {
        _prefer.remove("idStreamPadrao");
      }
    } else if (module is InfoModule || (T == InfoModule && module == null)) {
      _infoPadrao.value = module as InfoModule?;
      if (module != null) {
        _prefer.setString("idInfoPadrao", module.id);
      } else {
        _prefer.remove("idInfoPadrao");
      }
    } else {
      throw Exception("Modulo não suportado");
    }
  }

  List<T> getModules<T extends Module>({bool isEnabled = false}) {
    return _modules.whereType<T>().where((element) => (isEnabled ? element.isEnabled : true)).toList(growable: false);
  }

  T? getModuleById<T extends Module>(String? id, {bool enabledOnly = false}) {
    try {
      return enabledOnly
          ? getModules<T>(isEnabled: true).firstWhere((module) => module.id == id)
          : getModules<T>().firstWhere((module) => module.id == id);
    } catch (e) {
      return null;
    }
  }

  Rx<T?> getSelectedModule<T extends Module>() {
    if (T == StreamModule) {
      return _selectedStreamModule as Rx<T?>;
    } else if (T == InfoModule) {
      return _selectedInfoModule as Rx<T?>;
    } else {
      throw Exception("Modulo não suportado");
    }
  }

  void setSelectedModule<T extends Module>(Module? module) {
    if (module is StreamModule || (T == StreamModule && module == null)) {
      _selectedStreamModule.value = module as StreamModule?;
    } else if (module is InfoModule || (T == InfoModule && module == null)) {
      _selectedInfoModule.value = module as InfoModule?;
    } else {
      throw Exception("Modulo não suportado");
    }
  }

  void saveLoginSettings(Login login) async {
    await _prefer.setString(login.id, json.encode(login.toJson()));
  }
}
