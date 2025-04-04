import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubirFotosPage extends StatefulWidget {
  @override
  _SubirFotosPageState createState() => _SubirFotosPageState();
}

class _SubirFotosPageState extends State<SubirFotosPage> {
  List<File?> _imagenes = List.filled(10, null);
  final ImagePicker _picker = ImagePicker();

  Future<void> _seleccionarImagen(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagenes[index] = File(pickedFile.path);
      });
    }
  }

  void _eliminarImagen(int index) {
    setState(() {
      _imagenes[index] = null;
    });
  }

  int get cantidadImagenes => _imagenes.where((img) => img != null).length;

  Future<void> _publicar() async {
    String apiUrl =
        "http://192.168.18.3/mystore/gull_ventas_php_project/insert_foto.php"; // Cambia con tu URL real

    for (int i = 0; i < _imagenes.length; i++) {
      if (_imagenes[i] != null) {
        try {
          var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

          // Adjuntar la imagen
          request.files.add(
              await http.MultipartFile.fromPath("foto", _imagenes[i]!.path));

          // Agregar otros datos requeridos
          request.fields["descripcion"] = "Foto ${i + 1}";
          request.fields["cliente_id"] = "3"; // Cambia por el cliente real
          request.fields["estado"] = "pendiente";
          request.fields["fecha_creacion"] = DateTime.now().toIso8601String();

          print("Enviando imagen ${i + 1}");
          print("descripcion: ${request.fields["descripcion"]}");
          print("cliente_id: ${request.fields["cliente_id"]}");
          print("estado: ${request.fields["estado"]}");
          print("fecha_creacion: ${request.fields["fecha_creacion"]}");
          request.files.add(
              await http.MultipartFile.fromPath("imagen", _imagenes[i]!.path));

          // Enviar la solicitud
          var response = await request.send();
          var responseBody = await response.stream.bytesToString();
          print("Respuesta del servidor: $responseBody");
          final jsonResponse = json.decode(responseBody);
          print(jsonResponse);

          if (response.statusCode == 200) {
            var responseData = await response.stream.bytesToString();
            var jsonResponse = json.decode(responseData);
            print(
                "Imagen ${i + 1} subida con éxito: ${jsonResponse['mensaje']}");
          } else {
            print("Error al subir la imagen ${i + 1}");
          }
        } catch (e) {
          print("Error en la subida de imagen ${i + 1}: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir Fotos'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, size: 50, color: Colors.blue),
            ),
            SizedBox(height: 10),
            Text(
              "fredd alcantara david",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Cliente Interno", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: _imagenes[index] != null
                          ? Image.file(_imagenes[index]!,
                              width: 50, height: 50, fit: BoxFit.cover)
                          : Icon(Icons.cloud_upload, color: Colors.blue),
                      title: Text("Foto ${index + 1}"),
                      subtitle: Text(_imagenes[index] != null
                          ? "Imagen seleccionada"
                          : "Haz clic para subir"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _seleccionarImagen(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarImagen(index),
                          ),
                        ],
                      ),
                      onTap: () => _seleccionarImagen(index),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text("Total imágenes seleccionadas: $cantidadImagenes"),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: cantidadImagenes > 0 ? _publicar : null,
              child: Text("PUBLICAR"),
            )
          ],
        ),
      ),
    );
  }
}
