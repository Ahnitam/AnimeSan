import 'package:animesan/controllers/module_controller.dart';
import 'package:animesan/models/anime.dart';
import 'package:animesan/models/login/login_form.dart';
import 'package:animesan/models/login/login.dart';
import 'package:flutter/material.dart';

abstract class Module {
  final ModuleController _moduleController;
  Login get login;
  List<LoginForm> get loginForms;
  bool isEnabled = false;
  String get id;
  String get apiUrl;
  String get name;
  Color get color;
  String get icon;
  late void Function() saveLogin;

  Module(this._moduleController) {
    saveLogin = () {
      _moduleController.saveLoginSettings(login);
    };
  }

  Future<void> logar(String loginForm, Map<String, String> fields);
  Future<void> logout();
  Future<List<Anime>> buscar(String search);
  Future<void> refreshLogin();
  Future<Anime> fetchAnimeInfo(Anime anime);
}
