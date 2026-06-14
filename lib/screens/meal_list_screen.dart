import 'package:flutter/material.dart';
import '../models/repas.dart';
import '../widgets/repas_card.dart';

class MealListScreen extends StatefulWidget {
  const MealListScreen({super.key});

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  final List<Repas> _repasList = [];
  String? _filterType;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final now = DateTime.now();
    _repasList.addAll([
      Repas(
        id: '1',
        plat: 'Thiéboudiène',
        portionsPreparees: 120,
        portionsServies: 95,
        date: now.subtract(const Duration(days: 1)),
        type: TypeRepas.dejeuner,
      ),
      Repas(
        id: '2',
        plat: 'Yassa Poulet',
        portionsPreparees: 80,
        portionsServies: 72,
        date: now.subtract(const Duration(days: 2)),
        type: TypeRepas.dejeuner,
      ),
      Repas(
        id: '3',
        plat: 'Mafé',
        portionsPreparees: 100,
        portionsServies: 85,
        date: now.subtract(const Duration(days: 3)),
        type: TypeRepas.dejeuner,
      ),
      Repas(
        id: '4',
        plat: 'Lakh',
        portionsPreparees: 50,
        portionsServies: 40,
        date: now.subtract(const Duration(days: 4)),
        type: TypeRepas.collation,
      ),
      Repas(
        id: '5',
        plat: 'Ceebu jën',
        portionsPreparees: 150,
        portionsServies: 130,
        date: now.subtract(const Duration(days: 5)),
        type: TypeRepas.dejeuner,
      ),
      Repas(
        id: '6',
        plat: 'Thiebou guinar',
        portionsPreparees: 90,
        portionsServies: 80,
        date: now.subtract(const Duration(days: 6)),
        type: TypeRepas.diner,
      ),
      Repas(
        id: '7',
        plat: 'Bassi Saloum',
        portionsPreparees: 70,
        portionsServies: 60,
        date: now.subtract(const Duration(days: 7)),
        type: TypeRepas.dejeuner,
      ),
      Repas(
        id: '8',
        plat: 'Ndambe',
        portionsPreparees: 60,
        portionsServies: 50,
        date: now.subtract(const Duration(days: 8)),
        type: TypeRepas.diner,
      ),
    ]);
  }

  List<Repas> get _filteredRepas {
    if (_filterType == null) return _repasList;
    return _repasList.where((r) => r.type.name == _filterType).toList();
  }

  Future<void> _ajouterRepas() async {
    final result = await Navigator.pushNamed(context, '/form');
    if (result != null && result is Repas) {
      setState(() => _repasList.add(result));
    }
  }

  Future<void> _voirDetail(Repas repas) async {
    final result = await Navigator.pushNamed(context, '/detail', arguments: repas);
    if (result != null && mounted) {
      setState(() {
        if (result is Repas) {
          final index = _repasList.indexWhere((r) => r.id == result.id);
          if (index != -1) _repasList[index] = result;
        } else if (result == true) {
          _repasList.removeWhere((r) => r.id == repas.id);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredRepas;
    final totalGaspillage = Repas.calculerTotalGaspillage(_repasList);
    final tauxCumule = Repas.calculerTauxGaspillageCumule(_repasList);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gaspillage Cantine'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Statistiques cumulées',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn(
                      value: '${Repas.calculerTotalPreparees(_repasList)}',
                      label: 'Préparés',
                      color: theme.colorScheme.primary,
                    ),
                    _StatColumn(
                      value: '${Repas.calculerTotalServies(_repasList)}',
                      label: 'Servis',
                      color: theme.colorScheme.secondary,
                    ),
                    _StatColumn(
                      value: '$totalGaspillage',
                      label: 'Gaspillés',
                      color: tauxCumule > 0.2
                          ? theme.colorScheme.error
                          : theme.colorScheme.tertiary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Taux de gaspillage cumulé',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(tauxCumule * 100).toStringAsFixed(1)}%',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: tauxCumule > 0.2
                        ? theme.colorScheme.error
                        : theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Tous'),
                  selected: _filterType == null,
                  onSelected: (_) => setState(() => _filterType = null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Déjeuner'),
                  selected: _filterType == 'dejeuner',
                  onSelected: (_) => setState(() => _filterType = 'dejeuner'),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Dîner'),
                  selected: _filterType == 'diner',
                  onSelected: (_) => setState(() => _filterType = 'diner'),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Collation'),
                  selected: _filterType == 'collation',
                  onSelected: (_) => setState(() => _filterType = 'collation'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'Aucun repas enregistré',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final repas = filtered[index];
                      return RepasCard(
                        repas: repas,
                        onTap: () => _voirDetail(repas),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ajouterRepas,
        icon: const Icon(Icons.add),
        label: const Text('Ajouter un repas'),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatColumn({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
