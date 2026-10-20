import 'package:flutter/material.dart';
import 'package:rihla/widgets/destination_card.dart';
import 'package:rihla/widgets/search_box.dart';
import 'package:rihla/widgets/home_header.dart';
import 'package:rihla/widgets/hero_banner.dart';
import 'package:rihla/data/destinations.dart';
import 'package:rihla/widgets/section_title.dart';
import 'package:rihla/models/destination.dart';
import 'package:rihla/data/destinations.dart';


 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categorie = 'Tout';
  int _onglet = 0;

  List<Destination> get _filtrees {
    // TODO 1 : si _categorie vaut 'Tout', renvoyer destinations ;
    //          sinon, seulement celles dont categorie == _categorie
    //          (méthode where puis toList, vue en TP 2)
    if (_categorie =='Tout'){
      return destinations;
    }else{
      return destinations.where((d) => d.categorie== _categorie).toList();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _onglet ==0
            ? _construireAccueil()
            : const Center(child: Text('Bientôt disponible')),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,
        onDestinationSelected: (i) {
          setState(() {
            _onglet = i;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Favoris'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }

  ListView _construireAccueil() {
    return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const HomeHeader(prenom: 'Hiba'),
          const SizedBox(height: 20),
          const SearchBox(),
          const SizedBox(height: 24),
          HeroBanner(destination: destinations.first),
          const SizedBox(height: 28),
          const SectionTitle(titre: 'Categories'),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final c in categories)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: c == _categorie, // TODO 2 : vrai seulement pour la catégorie choisie
                      onSelected: (_) {
                        // TODO 3 : mémoriser c dans _categorie avec setState
                        setState(() {
                          _categorie =c;
                        });
                      },
                    ),
                  ),
              ],
            ),
        ),


          const SizedBox(height: 12),
          const SectionTitle(titre: 'Populaires', action: 'Voit Tous'),
          const SizedBox(height: 12),
          for (final i in _filtrees)
            DestinationCard(key: ValueKey(i.nom), destination: i),
        ],
      );
  }
}
