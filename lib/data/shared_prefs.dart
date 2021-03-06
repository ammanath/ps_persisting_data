import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPSettings {
  final String fontSizeKey = 'font_size';
  final String colorKey = 'color';

  static SharedPreferences _sp;
  static SPSettings _instance;

  SPSettings._internal();

  factory SPSettings() {
    if (_instance == null) {
      _instance = SPSettings._internal();
    }
    return _instance;
  }

  Future init() async {
    _sp = await SharedPreferences.getInstance();
  }

  Future setColor(int color) {
    return _sp.setInt(colorKey, color);
  }

  int getColor() {
    int color = _sp.getInt(colorKey);
    if (color == null) {
      color = Colors.amber.value;
    }
    return color;
  }

  Future setFontSize(String fontSize) {
    return _sp.setString(fontSizeKey, fontSize);
  }

  String getFontSize() {
    String fontSize = _sp.getString(fontSizeKey);
    if (fontSize == null) {
      fontSize = "Small";
    }
    return fontSize;
  }
}
