import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class UbicacionService {
  static const String baseUrl =
      "http://192.168.1.2/gull_ventas_php_project-master/get_ubicaciones.php";

  static Future<List<Map<String, String>>> obtenerDepartamentos() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl?tipo=departamentos"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((d) =>
                {"id": d["id"].toString(), "nombre": d["name"].toString()})
            .toList();
      } else {
        print("Error en la solicitud: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en obtenerDepartamentos: $e");
    }
    return [];
  }

  static Future<List<Map<String, String>>> obtenerProvincias(
      String idDepartamento) async {
    try {
      final response = await http.get(Uri.parse(
          "$baseUrl?tipo=provincias&id_departamento=$idDepartamento"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((p) =>
                {"id": p["id"].toString(), "nombre": p["name"].toString()})
            .toList();
      } else {
        print("Error en la solicitud: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en obtenerProvincias: $e");
    }
    return [];
  }

  static Future<List<Map<String, String>>> obtenerDistritos(
      String idProvincia) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl?tipo=distritos&id_provincia=$idProvincia"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((d) =>
                {"id": d["id"].toString(), "nombre": d["name"].toString()})
            .toList();
      } else {
        print("Error en la solicitud: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en obtenerDistritos: $e");
    }
    return [];
  }
}

class ReclamoService {
  static const String baseUrl =
      "http://192.168.1.2/gull_ventas_php_project-master/insert_reclamo.php";

  static Future<bool> registrarReclamo(
      Map<String, dynamic> datosReclamo) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(datosReclamo),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['status'] == 'success';
      } else {
        print("Error en la solicitud: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en registrarReclamo: $e");
    }
    return false;
  }
}

class LibroReclamacionesScreen extends StatefulWidget {
  @override
  _LibroReclamacionesScreenState createState() =>
      _LibroReclamacionesScreenState();
}

class _LibroReclamacionesScreenState extends State<LibroReclamacionesScreen> {
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

  List<Map<String, String>> departamentos = [];
  List<Map<String, String>> provincias = [];
  List<Map<String, String>> distritos = [];

  @override
  void initState() {
    super.initState();
    cargarDepartamentos();
  }

  void cargarDepartamentos() async {
    final data = await UbicacionService.obtenerDepartamentos();
    setState(() {
      departamentos = data;
    });
  }

  void cargarProvincias(String idDepartamento) async {
    final data = await UbicacionService.obtenerProvincias(idDepartamento);
    setState(() {
      provincias = data;
      provinciaSeleccionada = null;
      distritoSeleccionado = null;
    });
  }

  void cargarDistritos(String idProvincia) async {
    final data = await UbicacionService.obtenerDistritos(idProvincia);
    setState(() {
      distritos = data;
      distritoSeleccionado = null;
    });
  }

  String tipoDocumento = "DNI";
  String identificacionBien = "Producto";
  String tipoReclamo = "Reclamo";
  String motivoReclamo = "Producto defectuoso";
  final String fechaActual = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final String fechaRespuesta =
      DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 7)));

  String obtenerNombrePorId(List<Map<String, String>> lista, String? id) {
    return lista.firstWhere((elemento) => elemento["id"] == id,
        orElse: () => {"nombre": ""})["nombre"]!;
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
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF3391FA),
          title: Text("Libro de Reclamaciones")),
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
                DropdownButtonFormField<String>(
                  value: departamentoSeleccionado,
                  decoration: InputDecoration(labelText: "Departamento"),
                  items: departamentos.map((dep) {
                    return DropdownMenuItem(
                        value: dep["id"], child: Text(dep["nombre"]!));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        departamentoSeleccionado = value;
                        cargarProvincias(value!);
                      });
                    }
                  },
                  validator: (value) =>
                      value == null ? "Seleccione un departamento" : null,
                ),

                // ComboBox de Provincia
                DropdownButtonFormField<String>(
                  value: provinciaSeleccionada,
                  decoration: InputDecoration(labelText: "Provincia"),
                  items: provincias.map((prov) {
                    return DropdownMenuItem(
                        value: prov["id"], child: Text(prov["nombre"]!));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        provinciaSeleccionada = value;
                        cargarDistritos(value!);
                      });
                    }
                  },
                  validator: (value) =>
                      value == null ? "Seleccione una provincia" : null,
                ),

                // ComboBox de Distrito
                DropdownButtonFormField<String>(
                  value: distritoSeleccionado,
                  decoration: InputDecoration(labelText: "Distrito"),
                  items: distritos.map((dist) {
                    return DropdownMenuItem(
                        value: dist["id"], child: Text(dist["nombre"]!));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      distritoSeleccionado = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Seleccione un distrito" : null,
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
                  onPressed: seleccionarImagen,
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String departamentoNombre = obtenerNombrePorId(
                          departamentos, departamentoSeleccionado);
                      String provinciaNombre =
                          obtenerNombrePorId(provincias, provinciaSeleccionada);
                      String distritoNombre =
                          obtenerNombrePorId(distritos, distritoSeleccionado);

                      Map<String, dynamic> reclamoData = {
                        "tipo_documento": tipoDocumento,
                        "numero_documento": numeroDocumentoController.text,
                        "nombres_completos": nombresController.text,
                        "apellidos": apellidosController.text,
                        "tipo_respuesta": "Correo Electrónico",
                        "direccion": direccionController.text,
                        "departamento": departamentoNombre,
                        "provincia": provinciaNombre,
                        "distrito": distritoNombre,
                        "telefono": telefonoController.text,
                        "email": emailController.text,
                        "orden_compra": ordenCompraController.text,
                        "tipo_bien": identificacionBien,
                        "monto_reclamado": montoController.text,
                        "descripcion": descripcionController.text,
                        "tipo": tipoReclamo,
                        "motivo": motivoReclamo,
                        "detalle_reclamo": detalleReclamoController.text,
                        "pedido": pedidoController.text,
                        "imagen": nombreArchivo ?? "", // De momento vacío
                      };
                      bool exito =
                          await ReclamoService.registrarReclamo(reclamoData);
                      if (exito) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Reclamo registrado")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Error al registrar reclamo")));
                      }
                    }
                  },
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
