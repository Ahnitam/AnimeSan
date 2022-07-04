import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/exceptions/login_exception.dart';
import 'package:animesan/models/anime.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/utils/colors.dart';
import 'package:animesan/utils/states.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController {
  final Rx<List<Anime>> _animes = Rx<List<Anime>>(List.empty());
  late final ModuleController _moduleController;
  final Rx<SearchState> _searchState = Rx<SearchState>(SearchState.inicial);

  Rx<SearchState> get searchState => _searchState;

  HomeController({required ModuleController moduleController}) {
    _moduleController = moduleController;
  }

  List<Anime> get animes => _animes.value;

  Future<void> searchAnime(String text) async {
    if (_searchState.value == SearchState.carregando) {
      Get.snackbar(
        "Busca em andamento",
        "já tem uma busca em andamento",
        backgroundColor: appWarningColor.withOpacity(0.4),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
        animationDuration: const Duration(milliseconds: 500),
        duration: const Duration(seconds: 2),
      );
      return;
    }
    _searchState.value = SearchState.carregando;
    try {
      final StreamModule selectedModule = _moduleController.getSelectedModule<StreamModule>().value!;
      if (selectedModule.loginForms.isEmpty || selectedModule.login.state.value == LoginState.logado) {
        _animes.value = await selectedModule.buscar(text);
        if (_animes.value.isEmpty) {
          _searchState.value = SearchState.vazio;
        } else {
          _searchState.value = SearchState.sucesso;
        }
      } else {
        throw UnlogedException();
      }
    } on UnlogedException {
      _searchState.value = SearchState.error;
      _animes.value = List.empty();
      Get.snackbar(
        "Faça Login",
        "faça login para poder pesquisar",
        backgroundColor: appWarningColor.withOpacity(0.4),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
        animationDuration: const Duration(milliseconds: 500),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _searchState.value = SearchState.error;
      _animes.value = List.empty();
      Get.snackbar(
        "Erro ao Buscar",
        "Erro do plugin ao realizar busca",
        backgroundColor: appErrorColor.withOpacity(0.4),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
        animationDuration: const Duration(milliseconds: 500),
        duration: const Duration(seconds: 2),
      );
    }
  }
}
