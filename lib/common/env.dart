enum EnvType {
  dev, // 测试环境
  staging, // 预发环境
  prod, // 生产环境
}

class Env {
  static EnvType _envType = EnvType.dev;

  static EnvType get envType => _envType;

  static void setEnv(EnvType type) {
    _envType = type;
  }

  static final Map<EnvType, Map<String, dynamic>> _config = {
    EnvType.dev: {'baseUrl': 'http://192.168.1.6:9000', 'appName': '领狗AI(测试)'},
    EnvType.staging: {'baseUrl': 'http://192.168.1.6:9000', 'appName': '领狗AI(预发)'},
    EnvType.prod: {'baseUrl': 'http://192.168.1.6:9000', 'appName': '领狗AI'},
  };

  static Map<String, dynamic> get _currentConfig => _config[_envType]!;

  static String get baseUrl => _currentConfig['baseUrl'] as String;
  static String get appName => _currentConfig['appName'] as String;

  static bool get isDev => _envType == EnvType.dev;
  static bool get isStaging => _envType == EnvType.staging;
  static bool get isProd => _envType == EnvType.prod;
}
