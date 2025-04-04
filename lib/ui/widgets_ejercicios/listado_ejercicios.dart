import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detalle_ejercicio.dart';
import 'package:fullventas_app/ui/widgets_ejercicios/detalle_ejercicio.dart';

class EjerciciosPage extends StatefulWidget {
  @override
  _EjerciciosPageState createState() => _EjerciciosPageState();
}

class _EjerciciosPageState extends State<EjerciciosPage> {
  List<dynamic> ejercicios = [];
  List<dynamic> musculos = [];
  int? selectedMusculoId;

  @override
  void initState() {
    super.initState();
    fetchMusculos();
    fetchEjercicios();
  }

  Future<void> fetchEjercicios() async {
    final response = await http.get(Uri.parse(
        "http://192.168.18.3/mystore/gull_ventas_php_project/get_ejerciciosgym.php"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      setState(() {
        ejercicios = data;
      });
    }
  }

  Future<void> fetchMusculos() async {
    final response = await http.get(Uri.parse(
        "http://192.168.18.3/mystore/gull_ventas_php_project/get_musculo_ejercicios.php"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      setState(() {
        musculos = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredEjercicios = selectedMusculoId == null
        ? ejercicios
        : ejercicios
            .where((e) =>
                int.tryParse(e['id_musculo'].toString()) == selectedMusculoId)
            .toList();

    return Scaffold(
      appBar: AppBar(title: Text("Ejercicios de Gimnasio")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<int>(
                  value: selectedMusculoId,
                  hint: Text("Selecciona un músculo"),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  items: [
                    DropdownMenuItem<int>(
                      value: null,
                      child: Text(
                        "Mostrar Todos (Total: ${ejercicios.length})",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...musculos.map((musculo) {
                      return DropdownMenuItem<int>(
                        value: int.tryParse(musculo['id_musculo'].toString()),
                        child: Text(
                          "${musculo['nombre_musculo']} (${musculo['total_ejercicios']})",
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedMusculoId = value;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: filteredEjercicios.length,
              itemBuilder: (context, index) {
                final ejercicio = filteredEjercicios[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleEjercicio(
                            idEjercicio: ejercicio['id_ejercicio']),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              ejercicio['foto_1'],
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image,
                                    size: 50, color: Colors.grey);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(ejercicio['nombre'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
