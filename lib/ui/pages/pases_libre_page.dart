import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/ui/widgets_paseslibres/agregar_pase_libre.dart';
import 'package:fullventas_app/ui/widgets_paseslibres/list_paseslibre.dart';

class PasesLibrePage extends ConsumerWidget {
  const PasesLibrePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF3391FA),
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
        backgroundColor: Color(0xFF3391FA),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
