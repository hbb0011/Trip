import 'package:flutter/foundation.dart';
import '../models/destination.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

 
/// Favoris partagés par tous les écrans.
class FavorisModel extends ChangeNotifier {
  // favoris rangés par id : Map<String, Destination>
  final Map<String, Destination> _favoris = {};
  
  bool estFavori(Destination d) => _favoris.containsKey(d.id);
  

  List<Destination> get favoris => List.unmodifiable(_favoris.values);

  int get nombre => _favoris.length;

  bool basculer(Destination d) {
    final ajoute = _favoris.remove(d.id) == null;
    if (ajoute) _favoris[d.id] = d;
    _sauvegarder(); // TP7 : recopie sur le disque
    notifyListeners();
    return ajoute;
  }


  
  static const _cle = 'favoris';
  
  // estFavori, liste, nombre : inchangés (TP6)
 
  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    // TODO 1 : lire la liste de textes (liste vide si rien n'est stocké)
    final textes = prefs.getStringList(_cle) ?? [];

    // TODO 2 : pour chaque texte : jsonDecode puis Destination.fromJson,
    //          ranger la destination dans _favoris avec son id
    for (final texte in textes){
      final json = jsonDecode(texte);
      final destination = Destination.fromJson(json);
      _favoris[destination.id] = destination;

    }

    notifyListeners();
  }
 
  Future<void> _sauvegarder() async {
    final prefs = await SharedPreferences.getInstance();
    // TODO 3 : transformer chaque destination en texte
    //          (toJson puis jsonEncode) et l'écrire avec setStringList
    final textes = _favoris.values
        .map((destination) => jsonEncode(destination.toJson()))
        .toList();
    await prefs.setStringList(_cle, textes);
  }
 
  

}
