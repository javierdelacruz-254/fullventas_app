import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/models/fullventas_data/estrategia_ventas_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/planes_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/services_data.dart';

class CarritoProvider extends StateNotifier<List<Map<String, dynamic>>> {
  CarritoProvider() : super([]);

  int get totalCantidad {
    return state.fold(0, (sum, item) => sum + item['cantidad'] as int);
  }

  void addCarrito(dynamic producto, int cantidad) {
    final bool isService = producto is ServicesData;
    final bool isPlan = producto is PlanesData;
    final bool isEstretegia = producto is EstrategiaVentasData;

    print("🔍 Intentando agregar producto al carrito:");
    print("📌 Producto: ${producto.runtimeType}, ID: ${producto.id}");
    print(
        "📌 Tipo Estrategia: ${isEstretegia ? producto.tipo_producto : 'N/A'}");

    final index =
        state.indexWhere((item) => item['producto'].id == producto.id);

    double obtenerPrecio(dynamic producto) {
      if (producto is PlanesData) {
        return producto.precio_plan ?? 0.0;
      } else if (producto is ServicesData) {
        return producto.previousPrice ?? 0.0;
      } else if (producto is EstrategiaVentasData) {
        return producto.precio_normal ?? 0.0;
      }
      return 0.0; // Default en caso de tipo desconocido
    }

    double precioUnitario = obtenerPrecio(producto);
    print("💰 Precio Unitario: $precioUnitario");

    if (isService && producto.category == 2 ||
        isPlan ||
        (isEstretegia && producto.tipo_producto == 2)) {
      if (!state.any((item) => item['producto'].id == producto.id)) {
        print("🆕 Producto NO estaba en el carrito. Se agrega.");
        state = [
          ...state,
          {
            'producto': producto,
            'cantidad': 1,
            'subtotal': precioUnitario,
          }
        ];
      } else {
        print("⚠️ Producto YA estaba en el carrito. No se agrega duplicado.");
      }
    } else {
      print("🔄 Producto tipo diferente. Se maneja con cantidad.");
      // Si es un producto, se suma la cantidad si ya existe
      if (index != -1) {
        print("📌 Producto YA existe en el carrito. Aumentando cantidad.");
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == index)
              {
                'producto': state[i]['producto'],
                'cantidad': state[i]['cantidad'] + cantidad,
                'subtotal': (state[i]['cantidad'] + cantidad) * precioUnitario,
              }
            else
              state[i]
        ];
      } else {
        print("🆕 Producto NO estaba en el carrito. Se agrega.");
        state = [
          ...state,
          {
            'producto': producto,
            'cantidad': cantidad,
            'subtotal': cantidad * precioUnitario,
          }
        ];
      }
    }
  }

  void eliminarCarrito(dynamic producto) {
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
