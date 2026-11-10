import 'package:flutter/material.dart';
import 'package:rihla/widgets/destination_card.dart';
import 'package:rihla/widgets/search_box.dart';
import 'package:rihla/widgets/home_header.dart';
import 'package:rihla/widgets/hero_banner.dart';
import 'package:rihla/data/destinations.dart';
import 'package:rihla/widgets/section_title.dart';
import 'package:rihla/models/destination.dart';
import '../services/api_service.dart';

 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categorie = 'Tout';
  int _onglet = 0;

  late Future<List<Destination>> _futurDestinations;


  List<Destination> _filtrer(List<Destination> toutes) => _categorie == 'Tout'
    ? toutes
    : toutes.where((d) => d.categorie == _categorie).toList();


  @override
  void initState() {
    super.initState();
    // TODO 1 : lancer la requête et stocker le Future
      _futurDestinations = ApiService.getDestinations();
  }

  Future<void> _recharger() async {
    final futur = ApiService.getDestinations();
    setState(() {
      _futurDestinations = futur;   // FutureBuilder écoute le nouveau Future
    });
    try{
      await futur;                  // RefreshIndicator attend la fin
    } catch (_) {                   // l'erreur est affichée par FutureBuilder
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _onglet ==0
            ? _construireExplorer()
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

  ListView _construireAccueil(List<Destination> destinations) {
    final filtrees = _filtrer(destinations);
    return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
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
          for (final d in filtrees)
            DestinationCard(key: ValueKey(d.id), destination: d),
        ],
      );
  }

  Widget _construireExplorer() {
  return FutureBuilder<List<Destination>>(
    future: _futurDestinations,
    builder: (context, snapshot) {
      // TODO 2 : en attente (waiting) et pas encore de données
      //          -> CircularProgressIndicator centré
      if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      // TODO 3 : erreur (snapshot.hasError) -> ErreurReseau(...)
      if (snapshot.hasError) {
        return ErreurReseau(
          message: 'Impossible de charger les destinations.',
          onReessayer: () {
            setState(() {
              _futurDestinations = ApiService.getDestinations();
            });
          },
        );
      }
      final destinations = snapshot.data!;
      return RefreshIndicator(
        onRefresh: _recharger,
        child: _construireAccueil(destinations),
      );
    },
  );
}

}

class ErreurReseau extends StatelessWidget {
  final String message;
  final VoidCallback onReessayer;
 
  const ErreurReseau({super.key, required this.message, required this.onReessayer});
 
  @override
  Widget build(BuildContext context) {
    // TODO 4 : Column centrée : Icon(Icons.cloud_off) en couleur d'erreur,
    //          le message, « Vérifiez que json-server est lancé. »,
    //          et un FilledButton.tonalIcon « Réessayer » qui appelle onReessayer
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, color: Theme.of(context).colorScheme.error, size: 64),
            const SizedBox(height: 16),
            Text(message),
            const Text('Vérifiez que json-server est lancé.'),
            FilledButton.tonalIcon(
              onPressed: onReessayer,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

