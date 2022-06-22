// import 'package:animesan/utils/types.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  late final SharedPreferences _prefer;

  late bool _forceDualAudio;
  // late QualidadeDownload qualidadeDownload;

  SettingsController({
    required SharedPreferences prefer,
  }) {
    _prefer = prefer;
    _loadSettings();
  }

  void _loadSettings() {
    // qualidadeDownload = _loadQuality();
    _forceDualAudio = _prefer.getBool("forceDualAudio") ?? true;
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
}
