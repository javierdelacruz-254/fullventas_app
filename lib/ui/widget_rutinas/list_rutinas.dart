import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/rutinas_data_provider.dart';
import 'package:fullventas_app/config/providers/user_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/rutinas_data.dart';
import 'package:fullventas_app/ui/widget_rutinas/detalle_rutinas.dart';
import 'package:shimmer/shimmer.dart';

class ListRutinas extends ConsumerStatefulWidget {
  const ListRutinas({super.key});

  @override
  ListRutinasState createState() => ListRutinasState();
}

class ListRutinasState extends ConsumerState<ListRutinas> {
  late Future<List<RutinasData>> futureRutinas;
  final Set<int> rutinasCompletas = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final RutinasDetailUseCase = ref.read(rutinasDataProvider);
    final user = ref.read(userProvider);
    futureRutinas = RutinasDetailUseCase.getRutinasById(user!.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RutinasData>>(
      future: futureRutinas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerList();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No se encontró información'));
        } else {
          final rutinas = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: rutinas.length,
              itemBuilder: (context, index) {
                final rutina = rutinas[index];
                final isCompletada = rutinasCompletas.contains(rutina.idRutina);

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          rutina.imagen1 != null && rutina.imagen1!.isNotEmpty
                              ? Image.network(
                                  rutina.imagen1!,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 120,
                                      color: Colors.grey.shade300,
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey.shade600,
                                      ),
                                    );
                                  },
                                )
                              : Image.asset(
                                  "assets/placeholder.png",
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                    ),
                    title: Text(
                      rutina.nombre ?? "Sin título",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Instructor: ${rutina.nombreInstructor}",
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF3391FA)),
                        ),
                        Text(
                          "Frecuencia: ${rutina.frecuencia}",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        Text(
                          "${rutina.fechaInicio?.toLocal().toString().split(' ')[0]} - ${rutina.fechaFin?.toLocal().toString().split(' ')[0]}",
                          style:
                              TextStyle(fontSize: 13, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isCompletada
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isCompletada ? Colors.green : Colors.grey,
                        ),
                        Text(
                          isCompletada ? "Completada" : "Pendiente",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalleRutinas(rutinasData: rutina),
                        ),
                      );
                    },
                    onLongPress: () {
                      setState(() {
                        if (isCompletada) {
                          rutinasCompletas.remove(rutina.idRutina);
                        } else {
                          rutinasCompletas.add(rutina.idRutina!);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          contentPadding: EdgeInsets.all(12),
          leading: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          title: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 16,
              color: Colors.white,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              3,
              (i) => Padding(
                padding: EdgeInsets.only(top: 4),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
