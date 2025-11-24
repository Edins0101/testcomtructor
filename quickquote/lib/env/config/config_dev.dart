
import 'config_base.dart';

class DevEnv extends BaseConfig {
  @override
  String get appName => 'Quick Quote - Dev';

  @override
  String get serviceUrl => 'http://10.0.2.2:5198';
}
