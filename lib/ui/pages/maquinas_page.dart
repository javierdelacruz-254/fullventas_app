import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/ui/widget_maquinas/list_grupo_musculares.dart';

class MaquinasPage extends ConsumerWidget {
  const MaquinasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          'Maquinas',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListGrupoMusculares(),
    );
  }
}
