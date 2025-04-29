import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/calificacion_instructor_data_provider.dart';
import 'package:fullventas_app/config/providers/instructor_data_provider.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/config/providers/user_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/calificacion_instructor_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/instructor_data.dart';

class CalificacionPage extends ConsumerStatefulWidget {
  const CalificacionPage({super.key});

  @override
  CalificacionPageState createState() => CalificacionPageState();
}

class CalificacionPageState extends ConsumerState<CalificacionPage> {
  int? _selectedInstructor;
  String? _comentario;
  int _puntaje = 3;
  final String _fechaRegistro = DateTime.now().toString().split(' ')[0];

  @override
  Widget build(BuildContext context) {
    final InstructorDetailUseCase = ref.watch(instructorDataProvider);
    final user = ref.watch(userProvider);

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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          "Calificar Instructor",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Fecha de Registro: $_fechaRegistro'),
            FutureBuilder<List<InstructorData>>(
              future: InstructorDetailUseCase.getInstructorData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text("Error al cargar instructores");
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("No hay instructores disponibles");
                }

                final instructores = snapshot.data!;

                return DropdownButtonFormField<int>(
                  value: _selectedInstructor,
                  items: instructores.map((instructor) {
                    return DropdownMenuItem(
                      value: instructor.idInstructor,
                      child: Text(instructor.nombre!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(
                      () {
                        _selectedInstructor = value;
                      },
                    );
                  },
                  decoration:
                      InputDecoration(labelText: 'Selecciona un Instructor'),
                );
              },
            ),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Comentario'),
              onChanged: (value) {
                _comentario = value;
              },
            ),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _puntaje ? Icons.star : Icons.star_border,
                    color: hexToColor(colorHex),
                  ),
                  onPressed: () {
                    setState(() {
                      _puntaje = index + 1;
                    });
                  },
                );
              }),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_selectedInstructor == null ||
                    _comentario == null ||
                    _comentario!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Por favor completa todos los campos")),
                  );
                  return;
                }

                final calificacion = CalificacionInstructorData(
                  ID_Instructor: _selectedInstructor,
                  Comentario: _comentario,
                  Fecha_Publicada: DateTime.now(),
                  puntaje: _puntaje,
                  ID_Detalle_Calificacion: _puntaje,
                  ID_Cliente: user!.id,
                );

                try {
                  await ref
                      .read(calificacionInstructorDataProvider)
                      .execute(calificacion);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Calificación enviada con éxito")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error al enviar calificación: $e")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: hexToColor(colorHex),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Enviar Calificación',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
