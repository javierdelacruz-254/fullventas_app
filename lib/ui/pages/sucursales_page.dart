import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/ui/widget_sucursales/list_sucursales.dart';

class SucursalesPage extends ConsumerWidget {
  const SucursalesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Color(0xFF3391FA),
      appBar: AppBar(
        elevation: 0,
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
          'Sucursales',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListSucursales(),
    );
  }
}
