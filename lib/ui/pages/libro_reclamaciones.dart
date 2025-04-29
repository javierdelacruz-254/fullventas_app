import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/reclamo_data_provider.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/config/providers/ubigeo_data_provider.dart';
import 'package:fullventas_app/config/providers/user_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/reclamo_data.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

class LibroReclamaciones extends ConsumerStatefulWidget {
  const LibroReclamaciones({super.key});

  @override
  LibroReclamacionesState createState() => LibroReclamacionesState();
}

class LibroReclamacionesState extends ConsumerState<LibroReclamaciones> {
  final _formKey = GlobalKey<FormState>();
  File? _imagenReclamo;
  String? nombreArchivo;

  final TextEditingController numeroDocumentoController =
      TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController tipoRespuestaController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ordenCompraController = TextEditingController();
  final TextEditingController montoController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController detalleReclamoController =
      TextEditingController();
  final TextEditingController pedidoController = TextEditingController();

  String? departamentoSeleccionado;
  String? provinciaSeleccionada;
  String? distritoSeleccionado;

  String tipoDocumento = "DNI";
  String identificacionBien = "Producto";
  String tipoReclamo = "Reclamo";
  String motivoReclamo = "Producto defectuoso";
  final String fechaActual = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final String fechaRespuesta =
      DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 7)));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tipoRespuestaController.text = "Correo Electrónico";
    Future.delayed(Duration.zero, () {
      final cliente = ref.read(userProvider);
      if (cliente != null) {
        setState(() {
          nombresController.text = cliente.nombres ?? "";
          apellidosController.text = cliente.apellidos ?? "";
          direccionController.text = cliente.direccion ?? "";
          telefonoController.text = cliente.celular.toString() ?? "";
          emailController.text = cliente.email ?? "";
        });
      }
    });
  }

  Future<void> seleccionarImagen() async {
    final picker = ImagePicker();
    final XFile? imagenSeleccionada = await picker.pickImage(
        source: ImageSource.gallery); // O usa .camera para tomar una foto

    if (imagenSeleccionada != null) {
      setState(() {
        _imagenReclamo = File(imagenSeleccionada.path);
        nombreArchivo = path.basename(_imagenReclamo!.path);
      });
      print("Archivo seleccionado: $nombreArchivo");
    }
  }

  Future<void> registrarReclamo() async {
    if (!_formKey.currentState!.validate()) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: "Campos incompletos",
        desc: "Por favor, completa todos los campos obligatorios.",
        btnOkOnPress: () {},
      ).show();
      return;
    }

    final ReclamoData reclamo = ReclamoData(
      tipoDocumento: tipoDocumento,
      numeroDocumento: numeroDocumentoController.text,
      nombresCompletos: nombresController.text,
      apellidos: apellidosController.text,
      tipoRespuesta: tipoRespuestaController.text,
      fecha: DateTime.parse(fechaActual),
      direccion: direccionController.text,
      departamento: departamentoSeleccionado,
      provincia: provinciaSeleccionada,
      distrito: distritoSeleccionado,
      telefono: telefonoController.text,
      email: emailController.text,
      ordenCompra: ordenCompraController.text,
      bienContratado: identificacionBien,
      montoReclamado: double.tryParse(montoController.text) ?? 0.0,
      descripcion: descripcionController.text,
      fechaComunicacion: DateTime.parse(fechaRespuesta),
      tipo: tipoReclamo,
      motivo: motivoReclamo,
      detalleReclamo: detalleReclamoController.text,
      pedido: pedidoController.text,
      imagen: nombreArchivo,
    );

    try {
      await ref.read(reclamoDataProvider).execute(reclamo);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: "Éxito",
        desc: "✅ Reclamo enviado correctamente.",
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: "Error",
        desc: "❌ Ocurrió un error al enviar el reclamo. Inténtalo nuevamente.",
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cliente = ref.watch(userProvider);

    final departamentoProvider = ref.watch(departamentosDataProvider);
    final provinciaProvider =
        ref.watch(provinciasDataProvider(departamentoSeleccionado ?? ""));
    final distritosProvider =
        ref.watch(distritosDataProvider(provinciaSeleccionada ?? ""));
    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";

    Color hexToColor(String hex) {
      hex = hex.replaceAll("#", "");
      if (hex.length == 6) {
        hex = "FF$hex";
      }
      return Color(int.parse("0x$hex"));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor(colorHex),
        title: Text(
          "Libro de Reclamaciones",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección 1: Datos del Cliente
                Text("Datos del Cliente",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                DropdownButtonFormField<String>(
                  value: tipoDocumento,
                  onChanged: (value) => setState(() => tipoDocumento = value!),
                  items: ["DNI", "Carné de extranjería"].map((doc) {
                    return DropdownMenuItem(value: doc, child: Text(doc));
                  }).toList(),
                  decoration: InputDecoration(labelText: "Tipo de Documento"),
                ),
                campoTexto("N° de Documento", "Ingrese su documento",
                    numeroDocumentoController),
                TextFormField(
                  controller: nombresController,
                  decoration: InputDecoration(
                      labelText: "Nombres",
                      hintText: "Ingrese sus nombres completos"),
                  validator: (value) {
                    if (value!.isEmpty) return "Este campo es obligatorio";
                    return null;
                  },
                  enabled: cliente == null,
                ),
                TextFormField(
                  controller: apellidosController,
                  decoration: InputDecoration(
                      labelText: "Apellidos",
                      hintText: "Ingrese sus apellidos completos"),
                  validator: (value) {
                    if (value!.isEmpty) return "Este campo es obligatorio";
                    return null;
                  },
                  enabled: cliente == null,
                ),
                TextFormField(
                  controller: tipoRespuestaController,
                  decoration: InputDecoration(labelText: "Tipo de Respuesta"),
                  readOnly: true,
                  enabled: false,
                ),
                TextFormField(
                  initialValue: fechaActual,
                  decoration: InputDecoration(labelText: "Fecha"),
                  readOnly: true,
                  enabled: false,
                ),
                TextFormField(
                  controller: direccionController,
                  decoration: InputDecoration(
                      labelText: "Direccion", hintText: "Ingrese su direccion"),
                  validator: (value) {
                    if (value!.isEmpty) return "Este campo es obligatorio";
                    return null;
                  },
                  enabled: cliente == null,
                ),
                //ComboBox Departamento
                departamentoProvider.when(
                  data: (departamentos) => DropdownButtonFormField<String>(
                    value: departamentoSeleccionado,
                    decoration: InputDecoration(labelText: "Departamento"),
                    items: departamentos.map((dep) {
                      return DropdownMenuItem(
                        value: dep.id,
                        child: Text(
                          dep.name!,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        departamentoSeleccionado = value;
                        provinciaSeleccionada = null;
                        distritoSeleccionado = null;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Seleccione un departamento" : null,
                  ),
                  loading: () => CircularProgressIndicator(),
                  error: (err, stack) => Text("Error al cargar departamentos"),
                ),
                // ComboBox de Provincia
                provinciaProvider.when(
                  data: (provincias) => DropdownButtonFormField<String>(
                    value: provinciaSeleccionada,
                    decoration: InputDecoration(labelText: "Provincia"),
                    items: provincias.isEmpty
                        ? []
                        : provincias.map((prov) {
                            return DropdownMenuItem(
                              value: prov.id,
                              child: Text(prov.name!),
                            );
                          }).toList(),
                    onChanged: provincias.isEmpty
                        ? null
                        : (value) {
                            setState(() {
                              provinciaSeleccionada = value;
                              distritoSeleccionado = null;
                            });
                          },
                    validator: (value) =>
                        value == null ? "Seleccione una provincia" : null,
                  ),
                  loading: () => DropdownButtonFormField<String>(
                    value: null,
                    decoration: InputDecoration(labelText: "Provincia"),
                    items: [],
                    onChanged: null,
                  ),
                  error: (err, stack) => DropdownButtonFormField<String>(
                    value: null,
                    decoration: InputDecoration(labelText: "Provincia"),
                    items: [],
                    onChanged: null,
                  ),
                ),

                // ComboBox de Distrito
                distritosProvider.when(
                  data: (distritos) => DropdownButtonFormField<String>(
                    value: distritoSeleccionado,
                    decoration: InputDecoration(labelText: "Distrito"),
                    items: distritos.isEmpty
                        ? []
                        : distritos.map((dist) {
                            return DropdownMenuItem(
                                value: dist.id,
                                child: Text(
                                  dist.name!,
                                ));
                          }).toList(),
                    onChanged: distritos.isEmpty
                        ? null
                        : (value) {
                            setState(() {
                              distritoSeleccionado = value;
                            });
                          },
                    validator: (value) =>
                        value == null ? "Seleccione un distrito" : null,
                  ),
                  loading: () => DropdownButtonFormField<String>(
                    value: null,
                    decoration: InputDecoration(labelText: "Distrito"),
                    items: [],
                    onChanged: null,
                  ),
                  error: (err, stack) => DropdownButtonFormField<String>(
                    value: null,
                    decoration: InputDecoration(labelText: "Distrito"),
                    items: [],
                    onChanged: null,
                  ),
                ),

                TextFormField(
                  controller: telefonoController,
                  decoration: InputDecoration(
                      labelText: "Teléfono",
                      hintText: "Ingrese su número de teléfono"),
                  validator: (value) {
                    if (value!.isEmpty) return "Este campo es obligatorio";
                    return null;
                  },
                  enabled: cliente == null,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Ingrese su correo electronico"),
                  validator: (value) {
                    if (value!.isEmpty) return "Este campo es obligatorio";
                    return null;
                  },
                  enabled: cliente == null,
                ),

                SizedBox(height: 40),

                // Sección 2: Datos de Compra
                Text("Datos de Compra",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                campoTexto("Orden de compra", "Ingrese la orden",
                    ordenCompraController),
                SizedBox(
                  height: 10,
                ),
                Text("Identificación del bien contratado"),
                Row(
                  children: [
                    Radio(
                      value: "Producto",
                      groupValue: identificacionBien,
                      onChanged: (value) =>
                          setState(() => identificacionBien = value!),
                    ),
                    Text("Producto"),
                    Radio(
                      value: "Servicio",
                      groupValue: identificacionBien,
                      onChanged: (value) =>
                          setState(() => identificacionBien = value!),
                    ),
                    Text("Servicio"),
                  ],
                ),
                campoTexto("Monto S/", "Ingrese el monto", montoController),
                campoTexto("Descripción", "Nombre del producto o servicio",
                    descripcionController),
                SizedBox(height: 40),

                // Sección 3: Datos del Reclamo
                Text("Datos del Reclamo",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  initialValue: fechaRespuesta,
                  decoration: InputDecoration(labelText: "Fecha de respuesta"),
                  readOnly: true,
                  enabled: false,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Tipo"),
                Row(
                  children: [
                    Radio(
                      value: "Reclamo",
                      groupValue: tipoReclamo,
                      onChanged: (value) =>
                          setState(() => tipoReclamo = value!),
                    ),
                    Text("Reclamo"),
                    Radio(
                      value: "Queja",
                      groupValue: tipoReclamo,
                      onChanged: (value) =>
                          setState(() => tipoReclamo = value!),
                    ),
                    Text("Queja"),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: motivoReclamo,
                  onChanged: (value) => setState(() => motivoReclamo = value!),
                  items: [
                    "Producto defectuoso",
                    "Retraso en la entrega",
                    "Producto incorrecto",
                    "Problemas con la garantía",
                    "Mala atención al cliente",
                    "Problema con el reembolso",
                    "Otros"
                  ].map((motivo) {
                    return DropdownMenuItem(value: motivo, child: Text(motivo));
                  }).toList(),
                  decoration: InputDecoration(labelText: "Motivo"),
                ),
                campoTexto("Detalle del reclamo", "Explique el problema",
                    detalleReclamoController),
                campoTexto("Pedido", "Ingrese su solicitud", pedidoController),
                SizedBox(height: 10),
                Text("Imagen referente al reclamo",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: seleccionarImagen,
                  child: Center(
                    child: Text("Seleccionar imagen",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                if (_imagenReclamo != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(_imagenReclamo!, height: 150),
                    ),
                  ),

                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: registrarReclamo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hexToColor(colorHex),
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Center(
                    child: Text("Registrar Reclamo",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget campoTexto(
      String label, String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, hintText: hint),
      validator: (value) {
        if (value!.isEmpty) return "Este campo es obligatorio";
        return null;
      },
    );
  }
}
