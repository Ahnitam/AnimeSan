import 'package:flutter/material.dart';

class Field {
  String name;
  dynamic value;
  bool isVisible;
  TextInputType inputType;

  Field({
    required this.name,
    this.value = "",
    this.isVisible = false,
    this.inputType = TextInputType.text,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      name: json["name"],
      value: json["value"],
      isVisible: json["isVisible"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "value": value,
      "isVisible": isVisible,
    };
  }
}
