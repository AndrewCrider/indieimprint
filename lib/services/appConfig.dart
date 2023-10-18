import 'package:flutter/material.dart';

enum Flavor { eyecreality, flatline }

class AppConfig {
  String appOwner = "";
  String baseUrl = "";
  Color primaryColor = Colors.blue;
  Flavor flavor = Flavor.eyecreality;

  static AppConfig shared = AppConfig.create();

  factory AppConfig.create({
    String appOwner = "",
    String baseUrl = "",
    Color primaryColor = Colors.blue,
    Flavor flavor = Flavor.eyecreality,
  }) {
    return shared = AppConfig(appOwner, baseUrl, primaryColor, flavor);
  }

  AppConfig(this.appOwner, this.baseUrl, this.primaryColor, this.flavor);
}