import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/pase_libre_cliente_data_provider.dart';
import 'package:fullventas_app/config/providers/user_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/pase_libre_cliente_data.dart';
import 'package:intl/intl.dart';

class ListPlanesCliente extends ConsumerWidget {
  const ListPlanesCliente({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PaseLibreClienteDetailUseCase =
        ref.watch(paseLibreClienteDataProvider);
    final user = ref.watch(userProvider);

    return FutureBuilder<List<PaseLibreClienteData>>(
      future: PaseLibreClienteDetailUseCase.getPaseLibreClienteById(
          user!.nombres ?? "No hay nombre"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No se encontró información'));
        } else {
          final pasesLibresCliente = snapshot.data!;
          return pasesLibresCliente.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: pasesLibresCliente.length,
                  itemBuilder: (context, index) {
                    final pase = pasesLibresCliente[index];

                    return PaseCard(pase: pase);
                  },
                );
        }
      },
    );
  }
}

class PaseCard extends StatelessWidget {
  final PaseLibreClienteData pase;

  const PaseCard({super.key, required this.pase});

  @override
  Widget build(BuildContext context) {
    final formatoFecha = DateFormat('dd/MM/yyyy');
    final estadoColor = pase.estado == "activo" ? Colors.green : Colors.red;
    final iconoEstado =
        pase.estado == "activo" ? Icons.check_circle : Icons.cancel;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: estadoColor, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(iconoEstado, color: estadoColor, size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      pase.nombrePase ?? "Pase sin nombre",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoItem(Icons.person, "Edad: ${pase.edad ?? 'N/A'}"),
                  _infoItem(Icons.phone, "WhatsApp: ${pase.whatsapp ?? 'N/A'}"),
                ],
              ),
              const Divider(height: 20, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoItem(Icons.calendar_today, pase.fechaIni!),
                  _infoItem(Icons.event, pase.fechaFin!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}
