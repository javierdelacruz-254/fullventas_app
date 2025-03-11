import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/pase_libre_cliente_data_provider.dart';
import 'package:fullventas_app/config/providers/pases_libre_data_provider.dart';
import 'package:fullventas_app/config/providers/user_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/pase_libre_cliente_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/pases_libre_data.dart';
import 'package:intl/intl.dart';

class AgregarPaseLibre extends ConsumerStatefulWidget {
  const AgregarPaseLibre({super.key});

  @override
  AgregarPaseLibreState createState() => AgregarPaseLibreState();
}

class AgregarPaseLibreState extends ConsumerState<AgregarPaseLibre> {
  final _formKey = GlobalKey<FormState>();
  PasesLibreData? selectedPase;

  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _fechaIniController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();
  final TextEditingController _numPaseController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  String fecha = '';
  String numpase = '';
  String nombre = '';
  int edad = 0;
  String whatsapp = '';
  String estado = 'Activo';
  String fechaIni = '';
  String fechaFin = '';
  String nombrePase = '';
  int idPase = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fechaController.text = DateFormat('yyyy/MM/dd').format(DateTime.now());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProvider);
      if (user != null) {
        setState(() {
          _nombreController.text = user.nombres ?? "";
          _whatsappController.text = user.celular.toString() ?? "";
        });
      }
    });
  }

  void generarNumeroPase(PasesLibreData pase) {
    int stockDisponible = pase.StockDisponible ?? 0;

    if (stockDisponible > 0) {
      setState(() {
        numpase = "PASS-${stockDisponible.toString().padLeft(4, '0')}";
        _numPaseController.text = numpase;
      });
    } else {
      setState(() {
        numpase = "Sin stock disponible";
        _numPaseController.text = numpase;
      });
    }
  }

  void _guardarPaseLibre() async {
    if (_formKey.currentState!.validate()) {
      final paseLibreClienteData = PaseLibreClienteData(
        fecha: DateTime.now(),
        numpase: _numPaseController.text,
        nombre: _nombreController.text,
        edad: int.tryParse(_edadController.text) ?? 0,
        whatsapp: _whatsappController.text,
        estado: estado,
        fechaIni: _fechaIniController.text,
        fechaFin: _fechaFinController.text,
        nombrePase: selectedPase?.NombrePase,
        idPase: selectedPase?.id ?? 0,
      );

      try {
        await ref
            .read(paseLibreClienteDataProvider)
            .execute(paseLibreClienteData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Pase libre guardado exitosamente")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error al guardar el pase libre: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final PasesLibreDetailUseCase = ref.watch(paseslibreDataProvider);
    final user = ref.watch(userProvider);

    if (user != null) {
      _nombreController.text = user.nombres ?? "";
      _whatsappController.text = user.celular.toString() ?? "";
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'Confirmar pase',
        ),
        backgroundColor: Color(0xFF3391FA),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: FutureBuilder<List<PasesLibreData>>(
            future: PasesLibreDetailUseCase.getPasesLibresData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error al cargar pases"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No hay pases disponibles"));
              }

              List<PasesLibreData> pasesLibres = snapshot.data!;

              return ListView(
                children: [
                  SizedBox(height: 20),
                  DropdownButtonFormField<int>(
                    value: selectedPase?.id,
                    decoration: InputDecoration(
                      labelText: 'Selecciona un pase libre',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.card_giftcard),
                    ),
                    items: pasesLibres.map((pase) {
                      return DropdownMenuItem(
                        value: pase.id,
                        child:
                            Text(utf8.decode(latin1.encode(pase.NombrePase!))),
                      );
                    }).toList(),
                    onChanged: (int? paseId) {
                      if (paseId != null) {
                        setState(() {
                          selectedPase =
                              pasesLibres.firstWhere((p) => p.id == paseId);
                          nombrePase = selectedPase!.NombrePase!;
                          idPase = selectedPase!.id!;
                          _fechaIniController.text = DateFormat('yyyy/MM/dd')
                              .format(selectedPase!.FechaCanjeInicio!);
                          _fechaFinController.text = DateFormat('yyyy/MM/dd')
                              .format(selectedPase!.FechaCanjeFinal!);
                        });
                        generarNumeroPase(selectedPase!);
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: _fechaController,
                    decoration: InputDecoration(
                      labelText: 'Fecha de registro:',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    enableInteractiveSelection: false,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _fechaIniController,
                          decoration: InputDecoration(
                            labelText: 'Fecha de inicio de canje',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: Icon(Icons.date_range),
                          ),
                          readOnly: true,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _fechaFinController,
                          decoration: InputDecoration(
                            labelText: 'Fecha final de canje',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: Icon(Icons.date_range),
                          ),
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _numPaseController,
                    decoration: InputDecoration(
                      labelText: 'Número de Pase',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.confirmation_number),
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Ingresa tu nombre',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Campo requerido" : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _edadController,
                    decoration: InputDecoration(
                      labelText: 'Ingresa tu edad',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.cake),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? "Campo requerido" : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _whatsappController,
                    decoration: InputDecoration(
                      labelText: 'Ingresa tu número de WhatsApp',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.phone_android_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value!.isEmpty ? "Campo requerido" : null,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _guardarPaseLibre,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: Text('Confirmar Pase',
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
