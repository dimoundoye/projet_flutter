enum TypeRepas {
  dejeuner,
  diner,
  collation;

  String get label {
    switch (this) {
      case TypeRepas.dejeuner:
        return 'Déjeuner';
      case TypeRepas.diner:
        return 'Dîner';
      case TypeRepas.collation:
        return 'Collation';
    }
  }
}

class Repas {
  final String id;
  final String plat;
  final int portionsPreparees;
  final int portionsServies;
  final DateTime date;
  final TypeRepas type;

  Repas({
    required this.id,
    required this.plat,
    required this.portionsPreparees,
    required this.portionsServies,
    required this.date,
    this.type = TypeRepas.dejeuner,
  }) : assert(portionsPreparees >= 0),
       assert(portionsServies >= 0);

  int get gaspillage => portionsPreparees - portionsServies;

  double get tauxGaspillage =>
      portionsPreparees > 0 ? gaspillage / portionsPreparees : 0.0;

  Map<String, dynamic> toMap() => {
        'id': id,
        'plat': plat,
        'portionsPreparees': portionsPreparees,
        'portionsServies': portionsServies,
        'date': date.toIso8601String(),
        'type': type.name,
      };

  factory Repas.fromMap(Map<String, dynamic> map) => Repas(
        id: map['id'] as String,
        plat: map['plat'] as String,
        portionsPreparees: map['portionsPreparees'] as int,
        portionsServies: map['portionsServies'] as int,
        date: DateTime.parse(map['date'] as String),
        type: TypeRepas.values.firstWhere(
          (t) => t.name == map['type'],
          orElse: () => TypeRepas.dejeuner,
        ),
      );

  static int calculerTotalPreparees(List<Repas> repas) =>
      repas.fold(0, (sum, r) => sum + r.portionsPreparees);

  static int calculerTotalServies(List<Repas> repas) =>
      repas.fold(0, (sum, r) => sum + r.portionsServies);

  static int calculerTotalGaspillage(List<Repas> repas) =>
      calculerTotalPreparees(repas) - calculerTotalServies(repas);

  static double calculerTauxGaspillageCumule(List<Repas> repas) {
    final totalPrep = calculerTotalPreparees(repas);
    if (totalPrep == 0) return 0.0;
    return calculerTotalGaspillage(repas) / totalPrep;
  }
}
