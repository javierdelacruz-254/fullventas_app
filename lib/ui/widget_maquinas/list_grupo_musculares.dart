import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/grupo_musculares_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/grupo_musculares_data.dart';
import 'package:fullventas_app/ui/widget_maquinas/detalle_maquinas.dart';

class ListGrupoMusculares extends ConsumerWidget {
  const ListGrupoMusculares({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final GrupoMuscularesDetailUseCase = ref.watch(grupoMuscularesDataProvider);

    return FutureBuilder<List<GrupoMuscularesData>>(
      future: GrupoMuscularesDetailUseCase.getGrupoMuscularesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No se encontró información'));
        } else {
          final gruposMusculares = snapshot.data!;

          return gruposMusculares.isEmpty
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: gruposMusculares.length,
                  itemBuilder: (context, index) {
                    final grupo = gruposMusculares[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetalleMaquinas(idGrupo: grupo.id_grupo!),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(2, 2)),
                          ],
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: grupo.image_name != null &&
                                        grupo.image_name!.isNotEmpty
                                    ? FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/img/placeholder.png',
                                        image: grupo.image_name!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: double.infinity,
                                            height: 120,
                                            color: Colors.grey.shade300,
                                            child: Center(
                                              child: Icon(
                                                Icons.fitness_center,
                                                size: 50,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 120,
                                        color: Colors.grey.shade300,
                                        child: Center(
                                          child: Icon(
                                            Icons.fitness_center,
                                            size: 50,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                grupo.nombre_grupo ?? 'Sin nombre',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
        }
      },
    );
  }
}
