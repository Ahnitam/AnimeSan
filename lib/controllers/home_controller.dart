import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/anime.dart';
import 'package:animesan/models/mixins.dart';

class HomeController {
  List<Anime> _animes = List.empty();
  late final ModuleController _moduleController;

  HomeController({required moduleController}) {
    _moduleController = moduleController;
  }

  List<Anime> get animes => _animes;

  Future<List<Anime>> searchAnime(String text) async {
    _animes = await _moduleController.getSelectedModule<StreamModule>().value?.buscar(text) ?? List.empty();
    return _animes;
  }
}
