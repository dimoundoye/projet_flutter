import 'package:flutter/material.dart';
import '../models/repas.dart';

class MealFormScreen extends StatefulWidget {
  final Repas? repas;

  const MealFormScreen({super.key, this.repas});

  @override
  State<MealFormScreen> createState() => _MealFormScreenState();
}

class _MealFormScreenState extends State<MealFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _platController;
  late final TextEditingController _prepareesController;
  late final TextEditingController _serviesController;
  late DateTime _selectedDate;
  late TypeRepas _selectedType;
  bool get _isEditing => widget.repas != null;

  @override
  void initState() {
    super.initState();
    _platController = TextEditingController(text: widget.repas?.plat ?? '');
    _prepareesController = TextEditingController(
      text: widget.repas?.portionsPreparees.toString() ?? '',
    );
    _serviesController = TextEditingController(
      text: widget.repas?.portionsServies.toString() ?? '',
    );
    _selectedDate = widget.repas?.date ?? DateTime.now();
    _selectedType = widget.repas?.type ?? TypeRepas.dejeuner;
  }

  @override
  void dispose() {
    _platController.dispose();
    _prepareesController.dispose();
    _serviesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final repas = Repas(
      id: _isEditing
          ? widget.repas!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      plat: _platController.text.trim(),
      portionsPreparees: int.parse(_prepareesController.text.trim()),
      portionsServies: int.parse(_serviesController.text.trim()),
      date: _selectedDate,
      type: _selectedType,
    );

    Navigator.pop(context, repas);
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditing ? 'Modifier le repas' : 'Nouveau repas';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text('Enregistrer'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _platController,
                decoration: const InputDecoration(
                  labelText: 'Plat',
                  hintText: 'Ex: Thiéboudiène',
                  prefixIcon: Icon(Icons.restaurant_menu),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer un plat';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _prepareesController,
                      decoration: const InputDecoration(
                        labelText: 'Portions préparées',
                        prefixIcon: Icon(Icons.restaurant),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Requis';
                        }
                        final n = int.tryParse(value.trim());
                        if (n == null || n < 0) {
                          return 'Nombre valide';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _serviesController,
                      decoration: const InputDecoration(
                        labelText: 'Portions servies',
                        prefixIcon: Icon(Icons.people),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Requis';
                        }
                        final n = int.tryParse(value.trim());
                        if (n == null || n < 0) {
                          return 'Nombre valide';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TypeRepas>(
                initialValue: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type de repas',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: TypeRepas.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.label),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedType = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    '${_selectedDate.day.toString().padLeft(2, '0')}/'
                    '${_selectedDate.month.toString().padLeft(2, '0')}/'
                    '${_selectedDate.year}',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submit,
                icon: Icon(_isEditing ? Icons.save : Icons.add),
                label: Text(
                  _isEditing
                      ? 'Enregistrer les modifications'
                      : 'Ajouter le repas',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
