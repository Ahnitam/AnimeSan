import 'dart:convert';

import 'package:animesan/models/login/field.dart';
import 'package:animesan/utils/states.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login {
  late final String _id;
  late final Map<String, Field> _fields;
  late final Rx<LoginState> _state;
  late final SharedPreferences _prefer;

  Login({
    required String id,
    required Map<String, Field> fields,
    required state,
    required SharedPreferences prefer,
  }) {
    _id = id;
    _state = state;
    _fields = fields;
    _prefer = prefer;
  }

  /// Retorna o valor do campo [_state]
  Rx<LoginState> get state => _state;

  /// Retorna um valor do campo [_fields] com um identificador [id]
  String? getField(String id) => _fields[id]?.value;

  /// Retorna valores visiveis do campo [_fields]
  List<Field> getVisibleFields() => _fields.values.where((field) => field.isVisible).toList();

  /// Muda o estado do login
  void changeState(LoginState state) {
    _state.value = state;
    _save();
  }

  /// Adicionar um novo campo
  Future<void> putField({
    required String id,
    required String name,
    required String value,
    required bool isVisible,
  }) async {
    Field field = _fields[id] ?? Field(name: name, value: value, isVisible: isVisible);
    field.name = name;
    field.value = value;
    field.isVisible = isVisible;
    _fields[id] = field;
    _save();
  }

  /// Fazer logout
  Future<void> logout() async {
    _fields.clear();
    state.value = LoginState.unloged;
    await _save();
  }

  /// Salvar o login
  Future<void> _save() async {
    await _prefer.setString(_id, json.encode(toJson()));
  }

  Map<String, dynamic> toJson() {
    return {
      "state": state.value.name,
      "fields": json.encode(_fields),
    };
  }

  /// Criar um login a partir de um identificador
  factory Login.fromId(String id, SharedPreferences prefer) {
    Map<String, dynamic> jsonLogin = json.decode(prefer.getString(id) ?? "{}");
    try {
      final Map<String, Field> fields = {};
      json.decode(jsonLogin["fields"]).forEach(
        (key, value) {
          fields[key] = Field.fromJson(value);
        },
      );
      return Login(
        id: id,
        fields: fields,
        state: LoginState.values.firstWhere((element) => element.name == jsonLogin["state"]).obs,
        prefer: prefer,
      );
    } catch (e) {
      return Login(
        id: id,
        fields: {},
        state: LoginState.unloged.obs,
        prefer: prefer,
      );
    }
  }
}
