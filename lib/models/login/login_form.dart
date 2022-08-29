import 'package:animesan/models/login/field.dart';

class LoginForm {
  late final String _id;
  late final String _name;
  late final Map<String, LoginFormField> _fields;

  LoginForm({
    required String id,
    required String name,
    required Map<String, LoginFormField> fields,
  }) {
    _id = id;
    _name = name;
    _fields = fields;
  }

  String get id => _id;
  String get name => _name;
  Map<String, LoginFormField> get fields => _fields;
}
