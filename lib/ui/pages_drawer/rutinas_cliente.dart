import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/ui/widget_rutinas/list_rutinas.dart';

class RutinasCliente extends ConsumerWidget {
  const RutinasCliente({super.key});

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
          'Rutinas asignadas',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListRutinas(),
    );
  }
}
