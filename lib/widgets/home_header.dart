import 'package:flutter/material.dart';
 
class HomeHeader extends StatelessWidget {
  final String prenom;
 
  const HomeHeader({super.key, required this.prenom});
 
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme; // la palette Material 3 du thème
 
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text( 
                "Ahlan, $prenom 👋",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text( 
                "Où partez-vous\naujourd'hui ?",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          backgroundColor: cs.primaryContainer,
          child: Text(
            prenom.isNotEmpty ? prenom[0].toUpperCase() : '?',
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold,
              color: cs.onPrimaryContainer,
            ), 
          ),
        ),
      ],
    );
  }
}
