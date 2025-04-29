import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/destination_type_data_provider.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/config/providers/sucursales_data_Provder.dart';
import 'package:fullventas_app/config/providers/sugerencias_data_provider.dart';
import 'package:fullventas_app/config/providers/sugerencias_type_data_provider.dart';
import 'package:fullventas_app/config/providers/user_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/cliente_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/destination_type_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/sucursales_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/sugerencias_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/sugerencias_type_data.dart';

class SugerenciasForm extends ConsumerStatefulWidget {
  const SugerenciasForm({super.key});

  @override
  SugerenciasFormState createState() => SugerenciasFormState();
}

class SugerenciasFormState extends ConsumerState<SugerenciasForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _image1UrlController = TextEditingController();
  final TextEditingController _image2UrlController = TextEditingController();

  int? _selectedTypeId;
  int? _selectedLocalId;
  int? _selectedDestinationId;

  List<SugerenciasTypeData> _sugerenciasType = [];
  List<DestinationTypeData> _destinosType = [];
  List<SucursalesData> _sucuralesData = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadSugerenciasType();
      loadDestinosType();
      loadSucurles();
    });
  }

  void loadSugerenciasType() async {
    final userCase = ref.read(sugerenciasTypeDataProvider);
    final types = await userCase.getSugerenciasTypeData();
    setState(() {
      _sugerenciasType = types;
    });
  }

  void loadDestinosType() async {
    final useCase = ref.read(destinationTypeDataProvider);
    final type = await useCase.getDestionationTypeData();
    setState(() {
      _destinosType = type;
    });
  }

  void loadSucurles() async {
    final useCase = ref.read(sucursalesDataProvider);
    final type = await useCase.getSucursalesData();
    setState(() {
      _sucuralesData = type;
    });
  }

  void _subnmitSugerencia() async {
    final ClienteData? usuario = ref.read(userProvider);
    if (usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Debes iniciar sesión para enviar sugerencias")),
      );
      return;
    }

    final int idUsuario = usuario.user_id ?? 0;

    if (_formKey.currentState!.validate()) {
      if (_selectedLocalId == null ||
          _selectedTypeId == null ||
          _selectedDestinationId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Por favor, selecciona todas las opciones")),
        );
        return;
      }

      final SugerenciasDetailUseCase = ref.read(sugerenciasDataProvider);
      final sugerencia = SugerenciasData(
        subject: _subjectController.text,
        description: _descriptionController.text,
        userId: idUsuario,
        localId: _selectedLocalId,
        typeId: _selectedTypeId,
        destinationId: _selectedDestinationId,
        image1Url: _image1UrlController.text,
        image2Url: _image2UrlController.text,
        date: DateTime.now(),
      );
      try {
        await SugerenciasDetailUseCase.execute(sugerencia);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sugerencia enviada con éxito")),
        );
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al enviar la sugerencia: $e")),
        );
      }
    }
  }

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context) {
    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor(colorHex),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          "Sugerencias",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                value: _selectedTypeId,
                decoration: InputDecoration(labelText: "Tipo de Comentario"),
                items: _sugerenciasType.map((type) {
                  return DropdownMenuItem(
                    value: type.id,
                    child: Text(type.description!),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedTypeId = value),
                validator: (value) => value == null ? "Campo requerido" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: "Asunto"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Descripción"),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _selectedLocalId,
                decoration: InputDecoration(labelText: "Local"),
                items: _sucuralesData.map((type) {
                  return DropdownMenuItem(
                    value: type.id,
                    child: Text(type.nombre!),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedLocalId = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _selectedDestinationId,
                decoration: InputDecoration(labelText: "Destino"),
                items: _destinosType.map((type) {
                  return DropdownMenuItem(
                    value: type.id,
                    child: Text(type.description!),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedDestinationId = value),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _image1UrlController,
                decoration: InputDecoration(labelText: "URL de Imagen 1"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _image2UrlController,
                decoration: InputDecoration(labelText: "URL de Imagen 2"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _subnmitSugerencia,
                style: ElevatedButton.styleFrom(
                  backgroundColor: hexToColor(colorHex),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Guardar Feedback",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
