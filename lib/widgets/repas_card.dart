import 'package:flutter/material.dart';
import '../models/repas.dart';

class RepasCard extends StatelessWidget {
  final Repas repas;
  final VoidCallback? onTap;

  const RepasCard({super.key, required this.repas, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gaspillage = repas.gaspillage;
    final taux = repas.tauxGaspillage;
    final isHigh = taux > 0.2;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      repas.plat,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isHigh)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Taux élevé',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${repas.type.label} - ${_formatDate(repas.date)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _StatChip(
                    label: 'Préparé',
                    value: '${repas.portionsPreparees}',
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  _StatChip(
                    label: 'Servi',
                    value: '${repas.portionsServies}',
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  _StatChip(
                    label: 'Perte',
                    value: '$gaspillage',
                    color: isHigh
                        ? theme.colorScheme.error
                        : theme.colorScheme.tertiary,
                  ),
                ],
              ),
              if (repas.portionsPreparees > 0) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: taux.clamp(0.0, 1.0),
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    color: isHigh
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(taux * 100).toStringAsFixed(1)}% de gaspillage',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
