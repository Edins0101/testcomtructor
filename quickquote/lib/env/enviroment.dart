import 'package:quickquote/env/config/config_prod.dart';

import 'config/config_base.dart';
import 'config/config_dev.dart';

class Environment {
  static final Environment _environment = Environment._internal();

  factory Environment() => _environment;

  Environment._internal();

  static const String dev = 'DEV';
  static const String prod = 'PROD';

  BaseConfig? config;

  void initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    if (environment == Environment.prod) {
      return ProdEnv();
    } else {
      return DevEnv();
    }
  }
}
