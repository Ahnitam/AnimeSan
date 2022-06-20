import 'package:animesan/controllers/settings_controller.dart';
import 'package:animesan/models/anime.dart';
import 'package:animesan/models/mixins.dart';
import 'package:get/get.dart';

class HomeController {
  List<Anime> animes = List.empty();
  Rx<StreamModule?> selectedStreamModule = Get.find<SettingsController>().streamPadrao.obs;

  Future<List<Anime>> searchAnime(String text) async {
    animes = await selectedStreamModule.value!.buscar(text);
    return animes;
  }
}
