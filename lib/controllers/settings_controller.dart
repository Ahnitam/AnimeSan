import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/mixins.dart';
// import 'package:animesan/utils/types.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  late final ModuleController _moduleController;
  late final SharedPreferences _prefer;

  late bool _forceDualAudio;
  // late QualidadeDownload qualidadeDownload;
  late StreamModule? _streamPadrao;

  SettingsController({
    required SharedPreferences prefer,
    required ModuleController moduleController,
  }) {
    _prefer = prefer;
    _moduleController = moduleController;
    _loadSettings();
  }

  void _loadSettings() {
    // qualidadeDownload = _loadQuality();
    _forceDualAudio = _prefer.getBool("forceDualAudio") ?? true;
    _streamPadrao = _moduleController.getStreamModuleById(_prefer.getString("idStreamPadrao"), enabledOnly: true);
  }

  // QualidadeDownload _loadQuality() {
  //   String? qualidade = _prefer.getString("qualidadeDownload");
  //   return QualidadeDownload.values.firstWhere((element) => element.toString() == qualidade, orElse: () => QualidadeDownload.melhor);
  // }

  bool get forceDualAudio => _forceDualAudio;

  set forceDualAudio(bool value) {
    _forceDualAudio = value;
    _prefer.setBool("forceDualAudio", value);
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
}
