import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/ubigeo_data_provider.dart';
import 'package:fullventas_app/config/providers/user_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final cliente = ref.watch(userProvider);

    final departamentoProvider = ref.watch(departamentosDataProvider);
    final provinciaProvider =
        ref.watch(provinciasDataProvider(departamentoSeleccionado ?? ""));
    final distritosProvider =
        ref.watch(distritosDataProvider(provinciaSeleccionada ?? ""));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3391FA),
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
                campoTexto("Nombres", "Ingrese su nombre", nombresController),
                campoTexto(
                    "Apellidos", "Ingrese sus apellidos", apellidosController),
                TextFormField(
                  initialValue: 'Correo electrónico',
                  decoration: InputDecoration(labelText: "Tipo de Respuesta"),
                  readOnly: true,
                ),
                TextFormField(
                  initialValue: fechaActual,
                  decoration: InputDecoration(labelText: "Fecha"),
                  readOnly: true,
                ),
                campoTexto(
                    "Dirección", "Ingrese su dirección", direccionController),
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
                    items: provincias.map((prov) {
                      return DropdownMenuItem(
                        value: prov.id,
                        child: Text(prov.name!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        provinciaSeleccionada = value;
                        distritoSeleccionado = null;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Seleccione una provincia" : null,
                  ),
                  loading: () => CircularProgressIndicator(),
                  error: (err, stack) => Text("Error al cargar provincias"),
                ),

                // ComboBox de Distrito
                distritosProvider.when(
                  data: (distritos) => DropdownButtonFormField<String>(
                    value: distritoSeleccionado,
                    decoration: InputDecoration(labelText: "Distrito"),
                    items: distritos.map((dist) {
                      return DropdownMenuItem(
                          value: dist.id,
                          child: Text(
                            dist.name!,
                          ));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        distritoSeleccionado = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Seleccione un distrito" : null,
                  ),
                  loading: () => CircularProgressIndicator(),
                  error: (err, stack) => Text("Error al cargar distritos"),
                ),

                campoTexto("Teléfono", "Ingrese su número", telefonoController),
                campoTexto("Email", "Ingrese su correo", emailController),
                SizedBox(height: 10),

                // Sección 2: Datos de Compra
                Text("Datos de Compra",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                campoTexto("Orden de compra", "Ingrese la orden",
                    ordenCompraController),
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
                SizedBox(height: 10),

                // Sección 3: Datos del Reclamo
                Text("Datos del Reclamo",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
                  initialValue: fechaRespuesta,
                  decoration: InputDecoration(labelText: "Fecha de respuesta"),
                  readOnly: true,
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
                  onPressed: () {},
                  child: Center(
                    child: Text("Seleccionar imagen",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                if (_imagenReclamo != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(_imagenReclamo!, height: 150),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3391FA),
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
