import 'package:flutter/material.dart';

class GaspillageBar extends StatelessWidget {
  final double taux;
  final double height;

  const GaspillageBar({
    super.key,
    required this.taux,
    this.height = 24,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clampedTaux = taux.clamp(0.0, 1.0);
    final isHigh = taux > 0.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                FractionallySizedBox(
                  widthFactor: clampedTaux,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isHigh
                            ? [Colors.orange, theme.colorScheme.error]
                            : [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withValues(alpha: 0.7),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '${(clampedTaux * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: isHigh
                          ? theme.colorScheme.onError
                          : theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
