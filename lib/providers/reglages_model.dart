import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
/// Réglages de l'application, mémorisés sur l'appareil.
class ReglagesModel extends ChangeNotifier {
  static const _cle = 'sombre';
  bool _sombre = false;
  bool get sombre => _sombre;
 
  // TODO charger() : lire le booléen (false par défaut) puis notifier
  Future<void> charger() async {
    final preferences = await SharedPreferences.getInstance();
    _sombre = preferences.getBool(_cle) ?? false;
    notifyListeners();
  }
  
  // TODO basculerTheme() : inverser, sauvegarder, notifier
  Future<void> basculerTheme() async {
    _sombre = !_sombre;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_cle, _sombre);
    notifyListeners();
  }
}
