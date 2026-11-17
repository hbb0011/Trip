import 'package:flutter/foundation.dart';
import '../models/destination.dart';
 
/// Favoris partagés par tous les écrans.
class FavorisModel extends ChangeNotifier {
  // favoris rangés par id : Map<String, Destination>
  final Map<String, Destination> _favoris = {};
  
  bool estFavori(Destination d) => _favoris.containsKey(d.id);
  

  List<Destination> get favoris => List.unmodifiable(_favoris.values);

  int get nombre => _favoris.length;

  bool basculer(Destination d) {
    final ajoute = !_favoris.containsKey(d.id);
    if (ajoute) {
      _favoris[d.id] = d;
    } else {
      _favoris.remove(d.id);
    }
    notifyListeners();
    return ajoute;
  }
}
