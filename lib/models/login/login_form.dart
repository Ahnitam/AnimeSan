import 'package:animesan/models/login/field.dart';

class LoginForm {
  late final String _id;
  late final String _name;
  late final Map<String, Field> _fields;

  LoginForm({
    required String id,
    required String name,
    required Map<String, Field> fields,
  }) {
    _id = id;
    _name = name;
    _fields = fields;
  }

  String get id => _id;
  String get name => _name;
  Map<String, Field> get fields => _fields;
}
