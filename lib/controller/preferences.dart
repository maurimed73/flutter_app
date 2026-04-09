import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static const String _volumeKeyPrefix = 'pad_volume_';

  /// Salva o volume de um pad específico
  static Future<void> savePadVolume(String padId, double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('$_volumeKeyPrefix$padId', volume);
  }

  /// Carrega o volume de um pad específico
  static Future<double> loadPadVolume(String padId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('$_volumeKeyPrefix$padId') ?? 1.0;
  }
}
