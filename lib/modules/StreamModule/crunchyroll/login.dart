import 'package:animesan/models/login/field.dart';
import 'package:animesan/models/login/login.dart';
import 'package:animesan/utils/states.dart';

class LoginCrunchyroll extends Login {
  final LoginField _username = LoginField(label: "Usuário: ");
  final LoginField _email = LoginField(label: "Email: ");
  final LoginField _senha = LoginField(label: "Senha: ");
  final LoginField _accessToken = LoginField(label: "Access Token: ");
  final LoginField _refreshToken = LoginField(label: "Refresh Token: ");
  final LoginField _externalId = LoginField(label: "External ID: ");
  final LoginField _plano = LoginField(label: "Plano: ");

  LoginField get username => _username;
  LoginField get email => _email;
  LoginField get senha => _senha;
  LoginField get accessToken => _accessToken;
  LoginField get refreshToken => _refreshToken;
  LoginField get externalId => _externalId;
  LoginField get plano => _plano;

  @override
  void loadLogin(Map<String, dynamic> json) {
    try {
      loginForm = json["loginForm"];
      _email.value = json["email"];
      _senha.value = json["senha"];
      _refreshToken.value = json["refreshToken"];
    } catch (e) {
      logout();
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "email": _email.value,
      "senha": _senha.value,
      "refreshToken": _refreshToken.value,
      "loginForm": loginForm,
    };
  }

  @override
  void logout() {
    state.value = LoginState.unloged;
    _username.value = null;
    _email.value = null;
    _senha.value = null;
    _accessToken.value = null;
    _refreshToken.value = null;
    _externalId.value = null;
    _plano.value = null;
    loginForm = null;
  }

  @override
  List<LoginField> get visibleFields {
    List<LoginField> lista = List.empty(growable: true);
    if (username.value != null) {
      lista.add(username);
    }
    if (email.value != null) {
      lista.add(email);
    }
    if (plano.value != null) {
      lista.add(plano);
    }
    return lista;
  }
}
