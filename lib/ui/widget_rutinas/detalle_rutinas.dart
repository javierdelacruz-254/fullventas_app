import 'package:flutter/material.dart';
import 'package:fullventas_app/domain/models/fullventas_data/rutinas_data.dart';
import 'package:intl/intl.dart';

class DetalleRutinas extends StatelessWidget {
  final RutinasData rutinasData;

  const DetalleRutinas({super.key, required this.rutinasData});

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat("dd/MM/yyyy").format(date) : "Sin fecha";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rutinasData.nombre ?? "Detalles de Rutina",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF3391FA),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: rutinasData.imagen1 != null &&
                          rutinasData.imagen1!.isNotEmpty
                      ? Image.network(
                          rutinasData.imagen1!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/placeholder.png",
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          "assets/placeholder.png",
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                rutinasData.nombre ?? "Sin título",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "Tipo: ${rutinasData.tipoRutina ?? 'No especificado'}",
                style: TextStyle(fontSize: 18, color: Color(0xFF3391FA)),
              ),
              Divider(),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blueGrey, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Fechas: ${_formatDate(rutinasData.fechaInicio)} - ${_formatDate(rutinasData.fechaFin)}",
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.person, color: Colors.black54, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Instructor: ${rutinasData.nombreInstructor ?? 'No especificado'}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Divider(),

              _buildSection("🎯 Objetivos", rutinasData.objetivos),
              SizedBox(height: 15),

              // Metas
              _buildSection("🏆 Metas", rutinasData.metas),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String? content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          content ?? "No especificado",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        Divider(),
      ],
    );
  }
}
