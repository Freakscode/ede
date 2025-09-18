import 'package:hive/hive.dart';
import 'package:caja_herramientas/app/core/database/database_config.dart';

class TutorialOverlayService {
  static const _showKey = 'show';

  static Future<void> clearTutorialBox() async {
    final box = Hive.box(DatabaseConfig.tutorialHomeKey);
    await box.clear();
  }

  static Future<void> setShowTutorial(bool value) async {
    final box = Hive.box(DatabaseConfig.tutorialHomeKey);
    await box.put(_showKey, value);
  }

  static bool getShowTutorial() {
  final box = Hive.box(DatabaseConfig.tutorialHomeKey);
  final value = box.get(_showKey, defaultValue: true) as bool;
  return value;
  }
}
