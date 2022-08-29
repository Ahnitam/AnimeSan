import 'package:flutter/material.dart';

class LoginField {
  final String _label;
  dynamic value;

  LoginField({
    required String label,
    this.value,
  }) : _label = label;

  String get label => _label;
}

class LoginFormField {
  final String label;
  final bool isVisible;
  final TextInputType inputType;
  final List<String> autoFills;

  LoginFormField({
    required this.label,
    required this.isVisible,
    required this.inputType,
    required this.autoFills,
  });
}
