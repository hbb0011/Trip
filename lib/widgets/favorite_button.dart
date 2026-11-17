import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/destination.dart';
import '../providers/favoris_model.dart';

class FavoriteButton extends StatelessWidget {
  final Destination destination;
  const FavoriteButton({super.key, required this.destination});
 
  @override
  Widget build(BuildContext context) {
    final favoris = context.watch<FavorisModel>();
    final estFavori = favoris.estFavori(destination);

    return IconButton(
      icon: Icon(estFavori ? Icons.favorite : Icons.favorite_border, color: Colors.red,),
      onPressed: () => context.read<FavorisModel>().basculer(destination),
    );


  }
}

