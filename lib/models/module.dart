import 'package:animesan/models/anime.dart';
import 'package:animesan/models/login/login.dart';
import 'package:animesan/models/login/login_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class Module {
  bool isEnabled = false;
  String get id;
  String get apiUrl;
  String get name;
  Color get color;
  String get icon;

  late final List<LoginForm> _loginForms;
  List<LoginForm> get loginForms => _loginForms;

  late final Login _login;
  @nonVirtual
  Login get login => _login;
  @nonVirtual
  set login(Login login) {
    try {
      _login = login;
    } catch (e) {
      debugPrint("Variavel já foi inicializada");
    }
  }

  Module({List<LoginForm> loginForms = const []}) {
    _loginForms = loginForms;
  }

  Future<void> logar(String loginForm);
  Future<void> logout();
  Future<List<Anime>> buscar(String search);
  Future<void> refreshLogin();
  Future<Anime> fetchAnimeInfo(Anime anime);
}
