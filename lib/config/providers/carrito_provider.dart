import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/models/fullventas_data/services_data.dart';

class CarritoProvider extends StateNotifier<List<Map<String, dynamic>>> {
  CarritoProvider() : super([]);

  int get totalCantidad {
    return state.fold(0, (sum, item) => sum + item['cantidad'] as int);
  }

  void addCarrito(ServicesData producto, int cantidad) {
    final index =
        state.indexWhere((item) => item['producto'].id == producto.id);

    if (producto.category == 2) {
      // Si es un servicio, solo se añade una vez y no se duplica
      final existe = state.any((item) => item['producto'].id == producto.id);
      if (!existe) {
        state = [
          ...state,
          {
            'producto': producto,
            'cantidad': 1, // Siempre es 1
            'subtotal': producto.previousPrice ?? 0.0,
          }
        ];
      }
    } else {
      // Si es un producto, se suma la cantidad si ya existe
      if (index != -1) {
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == index)
              {
                'producto': state[i]['producto'],
                'cantidad': state[i]['cantidad'] + cantidad,
                'subtotal': (state[i]['cantidad'] + cantidad) *
                    state[i]['producto'].previousPrice,
              }
            else
              state[i]
        ];
      } else {
        // Si es un nuevo producto, agregarlo con la cantidad indicada
        state = [
          ...state,
          {
            'producto': producto,
            'cantidad': cantidad,
            'subtotal': cantidad * producto.previousPrice!,
          }
        ];
      }
    }
  }

  void eliminarCarrito(ServicesData producto) {
    state = state.where((item) => item['producto'].id != producto.id).toList();
  }

  void limpiarCarrito() {
    state = [];
  }
}

final carritoProvider =
    StateNotifierProvider<CarritoProvider, List<Map<String, dynamic>>>((ref) {
  return CarritoProvider();
});
