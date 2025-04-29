import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/ui/widgets_paseslibres/agregar_pase_libre.dart';
import 'package:fullventas_app/ui/widgets_paseslibres/list_paseslibre.dart';

class PasesLibrePage extends ConsumerWidget {
  const PasesLibrePage({super.key});

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: hexToColor(colorHex),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Pases Libres',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListPasesLibre(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarPaseLibre(),
            ),
          );
        },
        backgroundColor: hexToColor(colorHex),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
