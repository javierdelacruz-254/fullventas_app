import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/maquinas_data_provider.dart';
import 'package:fullventas_app/config/providers/musculos_data_Provider.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/maquinas_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/musculos_data.dart';
import 'package:fullventas_app/ui/widget_maquinas/vista_image_maquina.dart';

class DetalleMaquinas extends ConsumerStatefulWidget {
  final int idGrupo;

  const DetalleMaquinas({super.key, required this.idGrupo});

  @override
  DetalleMaquinasState createState() => DetalleMaquinasState();
}

class DetalleMaquinasState extends ConsumerState<DetalleMaquinas> {
  int? selectedMusculo;

  @override
  Widget build(BuildContext context) {
    final MaquinasDetailUseCase = ref.watch(maquinasDataProvider);
    final MusculosDetailUseCase = ref.watch(musculosDataProvider);
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
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            FutureBuilder<List<MusculosData>>(
              future: MusculosDetailUseCase.getMusculosById(widget.idGrupo),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No hay músculos disponibles'));
                }

                final musculos = snapshot.data!;

                final musculosOpciones = [
                  MusculosData(
                      id_musculo: 0, nombre_musculo: "Todos los musculos"),
                  ...musculos
                ];

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: DropdownButton<int>(
                    value: selectedMusculo,
                    hint: Text('Selecciona un músculo'),
                    isExpanded: true,
                    items: musculosOpciones.map((musculo) {
                      return DropdownMenuItem<int>(
                        value: musculo.id_musculo,
                        child: Text(utf8
                            .decode(latin1.encode(musculo.nombre_musculo!))),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedMusculo = newValue;
                      });
                    },
                  ),
                );
              },
            ),
            Expanded(
              child: FutureBuilder<List<MaquinasData>>(
                  future: MaquinasDetailUseCase.getMaquinasById(widget.idGrupo),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No hay máquinas disponibles'));
                    }

                    final maquinas = snapshot.data!;

                    final maquinasFiltradas =
                        selectedMusculo == null || selectedMusculo == 0
                            ? maquinas
                            : maquinas
                                .where((maquina) =>
                                    maquina.idMusculo == selectedMusculo)
                                .toList();

                    return maquinasFiltradas.isEmpty
                        ? const Center(
                            child: Text('No hay máquinas para este músculo'))
                        : GridView.builder(
                            padding: EdgeInsets.all(10),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: maquinasFiltradas.length,
                            itemBuilder: (context, index) {
                              final maquina = maquinasFiltradas[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VistaImageMaquina(maquina: maquina),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          child: maquina.foto1 != null &&
                                                  maquina.foto1
                                                      .toString()
                                                      .isNotEmpty
                                              ? Image.network(
                                                  maquina.foto1!,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  'assets/no_image.png',
                                                  fit: BoxFit.cover),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            maquina.nombreMaquina!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                  }),
            )
          ],
        ));
  }
}
