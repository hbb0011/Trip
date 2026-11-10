import 'package:flutter/material.dart';
import 'package:rihla/data/destinations.dart';
import 'package:rihla/services/api_service.dart';
import 'package:rihla/models/reservation.dart';
import 'package:rihla/widgets/favorite_button.dart';
import 'package:rihla/screens/detail_screen.dart';
import 'package:rihla/models/destination.dart';
import 'reservation_screen.dart';

class DetailScreen extends StatefulWidget{
  final Destination destination;
  const DetailScreen({super.key, required this.destination,});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int travelers = 1;
  Widget _tuile(IconData icon,String titre, String valeur){
    final theme = Theme.of(context);
    final cs = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: cs.outlineVariant),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: cs.primary),
            const SizedBox(height: 4),
            Text(titre, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text(valeur, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> _reserver() async {
    final reservation = await Navigator.push<Reservation>(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationScreen(
          destination: widget.destination,
          voyageurs: travelers,
        ),
      ),
    );
    // TODO 3 : si reservation est null (retour sans valider), s'arrêter
    if (reservation ==null) return;
    // TODO 4 : si l'écran n'est plus affiché (!mounted), s'arrêter
    if (!mounted) return;
 
    final String id;
      try {
        id = await ApiService.creerReservation(reservation);          // TODO 5 : appeler ApiService.creerReservation (sans oublier await)
      } catch (e) {
        if (!mounted) return;
        // TODO 6 : SnackBar rouge « Envoi impossible : json-server est-il lancé ? »
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Envoi impossible : json-server est-il lancé ?'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;   // pas de confirmation si rien n'est enregistré
      }
 
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
          title: const Text('Réservation confirmée'),
          content: Text(
            'N° de réservation : $id\n'
            'Nom: ${reservation.nom}\n'
            'Destination: ${reservation.destination.nom}\n'
            'Voyageurs: ${reservation.voyageurs}\n'
            'Formule: ${reservation.formule}\n'
            'Tot: ${reservation.total} DT \n'
            'Email: ${reservation.email}\n'
          ),                   // TODO 5 : nom, destination, voyageurs,
                                //          formule, total et e-mail
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
  }
 
// Le bouton « Réserver » : onPressed: _reserver,


  @override
  Widget build(BuildContext context){
    final destination =  widget.destination;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tot = destination.prix * travelers;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 340,
            child: Stack(
              fit: StackFit.expand,
              children:[
                Hero(
                  tag: 'image-${widget.destination.nom}',
                  child: Image.asset(destination.image, 
                  fit: BoxFit.cover)
                ),
                Positioned(
                  top: 48,
                  left: 16,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      /* TODO 2 : revenir à l'écran précédent */
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.black,
                      onPressed: () => Navigator.pop(context),
                    ), 
                  ),
                ),

                Positioned(
                  top: 48,
                  right: 16,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const FavoriteButton(),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(destination.nom,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 16, color: cs.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            destination.region,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${destination.note}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _tuile(Icons.access_time, 'Durée', destination.duree),
                    const SizedBox(width: 12),
                    _tuile(Icons.category, 'Type', destination.categorie),
                    const SizedBox(width: 12), //!!!! zid thabet ba3ed !!!!
                    _tuile(Icons.group, 'Groupe', 'Max 12'),

                  ],
                ),
                const SizedBox(height: 24),

                Text('A propos',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(destination.description,
                    style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: Text('Voyageurs', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    IconButton.outlined(onPressed: travelers>1 ? () => setState(() => travelers--) : null,
                      icon: const Icon(Icons.remove),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('$travelers', style: theme.textTheme.titleMedium),
                    ),
                    IconButton.outlined(onPressed: () {
                      if (travelers < 12) setState(() => travelers++);
                    },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total', style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                Text('$tot DT', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: cs.primary)),

              ],
            ),
            const Spacer(),
            FilledButton(onPressed: _reserver, child: const Text('Réserver')),
          ],),
        ),
      ),
    );
  }
}