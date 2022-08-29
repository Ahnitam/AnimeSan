import 'dart:async';

import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/exceptions/login_exception.dart';
import 'package:animesan/models/anime.dart';
import 'package:animesan/models/episodio.dart';
import 'package:animesan/models/mixins.dart';
import 'package:animesan/models/module.dart';
import 'package:animesan/utils/firebase_collections.dart';
import 'package:animesan/utils/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class MidiaController extends GetxController {
  final ModuleController _moduleController;

  Map<String, Map<String, dynamic>?> _externalIds = {};
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _externalIdsListenner;

  final Rx<ExternalIdState> externalIdsState = Rx<ExternalIdState>(ExternalIdState.inicial);

  MidiaController({required ModuleController moduleController}) : _moduleController = moduleController {
    _externalIdsListenner = FirebaseFirestore.instance.collection(firebaseExternalIdCollection).snapshots().listen((event) {
      if (externalIdsState.value == ExternalIdState.inicial) {
        externalIdsState.value = ExternalIdState.carregando;
      }
      final Map<String, Map<String, dynamic>?> docs = {};
      for (var doc in event.docs) {
        docs[doc.id] = doc.data();
      }
      _externalIds = docs;
      externalIdsState.value = ExternalIdState.carregado;
    }, onError: (error) {
      externalIdsState.value = ExternalIdState.carregado;
    });
  }

  Future<List<Anime>> searchAnime<T extends Module>(String text) async {
    try {
      final T? selectedModule = _moduleController.getSelectedModule<T>().value;
      if (selectedModule == null) {
        return const [];
      }
      if (selectedModule.loginForms.isEmpty || selectedModule.login.state.value == LoginState.logado) {
        return (await selectedModule.buscar(text)).toList(growable: false);
      } else {
        throw UnlogedException();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAnime(Anime anime) async {
    try {
      if (anime.temporadas.isEmpty) {
        anime.state.value = MidiaState.carregando;
        await anime.module.fetchAnimeInfo(anime);
      }
      anime.state.value = MidiaState.carregado;
    } catch (e) {
      anime.state.value = MidiaState.error;
    }
  }

  Future<void> fetchDownload(Episodio episodio) async {
    try {
      if (episodio.download == null) {
        episodio.state.value = MidiaState.carregando;
        episodio.download = await (episodio.temporada.anime.module as StreamModule).fetchDownloadInfo(episodio: episodio);
      }
      episodio.state.value = MidiaState.carregado;
    } catch (e) {
      episodio.state.value = MidiaState.error;
    }
  }

  void download(Episodio episodio) async {
    if (episodio.download == null) {
      throw Exception('Download não encontrado');
    }
  }

  String? getAnimeExternalId(Anime anime, Module? moduleExternalId) {
    try {
      if (moduleExternalId == null) {
        throw ArgumentError("moduleExternalId não pode ser nulo");
      }
      return _externalIds["${anime.module.id}_${anime.id}"]![moduleExternalId.id];
    } catch (e) {
      return null;
    }
  }

  Future<void> setAnimeExternalId(Anime anime, Anime animeExternalId) async {
    try {
      await FirebaseFirestore.instance
          .collection(firebaseExternalIdCollection)
          .doc("${anime.module.id}_${anime.id}")
          .set({animeExternalId.module.id: animeExternalId.id}, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _externalIdsListenner.cancel();
    super.dispose();
  }
}
