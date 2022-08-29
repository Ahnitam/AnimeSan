import 'package:animesan/models/login/field.dart';
import 'package:animesan/utils/states.dart';
import 'package:get/get.dart';

abstract class Login {
  late final String id;
  String? loginForm;
  final Rx<LoginState> _state;

  Login() : _state = Rx(LoginState.unloged);

  /// Retorna o valor do campo [_state]
  Rx<LoginState> get state => _state;

  Map<String, dynamic> toJson();

  List<LoginField> get visibleFields;

  void logout();

  /// Criar um login a partir de um identificador
  void loadLogin(Map<String, dynamic> json);
}
