import 'package:flutter/material.dart';
import '../models/repas.dart';
import '../widgets/gaspillage_bar.dart';

class MealDetailScreen extends StatelessWidget {
  final Repas repas;

  const MealDetailScreen({super.key, required this.repas});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taux = repas.tauxGaspillage;
    final isHigh = taux > 0.2;

    return Scaffold(
      appBar: AppBar(
        title: Text(repas.plat),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                '/form',
                arguments: repas,
              );
              if (result != null && context.mounted) {
                Navigator.pop(context, result);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(repas.type.label),
                  avatar: Icon(
                    repas.type == TypeRepas.dejeuner
                        ? Icons.wb_sunny
                        : repas.type == TypeRepas.diner
                            ? Icons.nightlight_round
                            : Icons.cookie,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Chip(
                  label: Text(
                    '${repas.date.day}/${repas.date.month}/${repas.date.year}',
                  ),
                  avatar: const Icon(Icons.calendar_today, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    label: 'Portions préparées',
                    value: '${repas.portionsPreparees}',
                    icon: Icons.restaurant,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    label: 'Portions servies',
                    value: '${repas.portionsServies}',
                    icon: Icons.people,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    label: 'Gaspillage',
                    value: '${repas.gaspillage}',
                    icon: Icons.delete_outline,
                    color: isHigh
                        ? theme.colorScheme.error
                        : theme.colorScheme.tertiary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    label: 'Taux',
                    value: '${(taux * 100).toStringAsFixed(1)}%',
                    icon: Icons.pie_chart,
                    color: isHigh
                        ? theme.colorScheme.error
                        : theme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Barre de gaspillage',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            GaspillageBar(taux: taux),
            const SizedBox(height: 8),
            if (isHigh)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber,
                        color: theme.colorScheme.onErrorContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Taux de gaspillage élevé !',
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Voulez-vous vraiment supprimer "${repas.plat}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, true);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
