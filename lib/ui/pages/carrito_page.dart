import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/carrito_provider.dart';
import 'package:fullventas_app/config/providers/sucursales_data_Provder.dart';
import 'package:fullventas_app/domain/models/fullventas_data/services_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/sucursales_data.dart';
import 'package:fullventas_app/ui/pages/home_page.dart';
import 'package:fullventas_app/ui/pages/producto_page.dart';
import 'package:fullventas_app/ui/widget_carrito/metodo_pago.dart';

class CarritoPage extends ConsumerStatefulWidget {
  const CarritoPage({super.key});

  @override
  CarritoPageState createState() => CarritoPageState();
}

class CarritoPageState extends ConsumerState<CarritoPage> {
  double envio = 0.00;

  @override
  Widget build(BuildContext context) {
    final carrito = ref.watch(carritoProvider);

    double subtotal =
        carrito.fold(0, (sum, item) => sum + (item['subtotal'] ?? 0));
    double total = subtotal + envio;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Carrito de Compras",
          style: TextStyle(color: Colors.white),
        ),
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
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: carrito.isEmpty
          ? _buildCarritoVacio()
          : _buildCarrito(carrito, subtotal, envio, total),
    );
  }

  Widget _buildCarritoVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text("Tu carrito está vacío",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductoPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3391FA)),
            child: Text(
              "Agregar productos",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // 🛍 Vista cuando hay productos en el carrito
  Widget _buildCarrito(List<Map<String, dynamic>> carrito, double subtotal,
      double envio, double total) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: carrito.length,
            itemBuilder: (context, index) {
              final item = carrito[index];
              final ServicesData producto = item['producto'];
              final int cantidad = item['cantidad'];
              final double subtotalItem = item['subtotal'];

              return Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Image.network(
                        producto.imageName ?? '',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              utf8.decode(latin1.encode(producto.title ?? '')),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "S/. ${subtotalItem.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.scale,
                                title: "¿Eliminar producto?",
                                desc:
                                    "¿Estás seguro de que deseas eliminar este producto del carrito?",
                                btnCancelText: "No",
                                btnCancelOnPress: () {},
                                btnOkText: "Sí, eliminar",
                                btnOkOnPress: () {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.warning,
                                    animType: AnimType.scale,
                                    title: "¡Última advertencia!",
                                    desc:
                                        "Esta acción eliminará el producto permanentemente.",
                                    btnCancelText: "Cancelar",
                                    btnCancelOnPress: () {},
                                    btnOkText: "Eliminar",
                                    btnOkOnPress: () {
                                      ref
                                          .read(carritoProvider.notifier)
                                          .eliminarCarrito(producto);
                                    },
                                  ).show();
                                },
                              ).show();
                            },
                            child: Text(
                              "Eliminar",
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '$cantidad Unidad',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    if (cantidad > 1) {
                                      ref
                                          .read(carritoProvider.notifier)
                                          .addCarrito(producto, -1);
                                    } else {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.scale,
                                        title: "¿Eliminar producto?",
                                        desc:
                                            "Si reduces la cantidad a 0, el producto será eliminado.",
                                        btnCancelText: "No",
                                        btnCancelOnPress: () {},
                                        btnOkText: "Sí, eliminar",
                                        btnOkOnPress: () {
                                          ref
                                              .read(carritoProvider.notifier)
                                              .eliminarCarrito(producto);
                                        },
                                      ).show();
                                    }
                                  },
                                  icon: Icon(Icons.remove, size: 18),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    ref
                                        .read(carritoProvider.notifier)
                                        .addCarrito(producto, 1);
                                  },
                                  icon: Icon(Icons.add, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Subtotal:", style: TextStyle(fontSize: 16)),
                  Text("S/. ${subtotal.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Envío:", style: TextStyle(fontSize: 16)),
                  ElevatedButton(
                      onPressed: () async {
                        double nuevoEnvio = await dialogCalcular(context, ref);
                        setState(() {
                          envio = nuevoEnvio;
                        });
                      },
                      child: Text("Calcular")),
                  Text(
                    "S/. ${envio.toStringAsFixed(2)}",
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    "S/. ${total.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MetodoPago(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Ir a pagar",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<double> dialogCalcular(BuildContext context, WidgetRef ref) async {
    String opcionSeleccionada = "sucursal";
    double envio = 0.00;
    int? sucursalSeleccionada;
    String? ciudadSeleccionada;

    return await showDialog<double>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  titlePadding: EdgeInsets.zero,
                  title: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF3391FA), // Color de fondo del título
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Text("Calcular Envío",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context, envio),
                        ),
                      ],
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Column(
                        children: [
                          RadioListTile(
                            title: Text("Delivery"),
                            value: "delivery",
                            groupValue:
                                opcionSeleccionada, // Puedes hacer que sea dinámico
                            onChanged: (value) {
                              setState(() {
                                opcionSeleccionada = value.toString();
                                envio = 15.00;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text("Recojo en sucursal"),
                            value: "sucursal",
                            groupValue: opcionSeleccionada,
                            onChanged: (value) {
                              setState(() {
                                opcionSeleccionada = value.toString();
                                envio = 0.00;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Consumer(builder: (context, ref, child) {
                        final SucursalesDetailUseCase =
                            ref.watch(sucursalesDataProvider);

                        return FutureBuilder<List<SucursalesData>>(
                            future: SucursalesDetailUseCase.getSucursalesData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text("Error al cargar sucursales");
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Text("No hay sucursales disponibles");
                              }

                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration:
                                    InputDecoration(labelText: "Sucursal"),
                                value: sucursalSeleccionada,
                                onChanged: opcionSeleccionada == "sucursal"
                                    ? null
                                    : (value) {
                                        setState(() {
                                          sucursalSeleccionada = value;
                                        });
                                      },
                                items: snapshot.data!
                                    .map((sucursal) => DropdownMenuItem(
                                          value: sucursal.id,
                                          child: Text(sucursal.nombre!),
                                        ))
                                    .toList(),
                              );
                            });
                      }),

                      SizedBox(height: 10),

                      // Selector de ciudad
                      DropdownButton<String>(
                        isExpanded: true,
                        value: "Lima", // Puedes cambiarlo dinámicamente
                        onChanged: opcionSeleccionada == "sucursal"
                            ? null // Deshabilitado si es sucursal
                            : (value) {},
                        items: ["Lima", "Callao", "Arequipa"]
                            .map((ciudad) => DropdownMenuItem(
                                  value: ciudad,
                                  child: Text(ciudad),
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 10),

                      // Precio de envío
                      Text(
                        "Precio envío: S/. ${envio.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(envio);
                      },
                      child: Text("Aceptar", style: TextStyle(fontSize: 16)),
                    ),
                  ],
                );
              },
            );
          },
        ) ??
        0.00;
  }
}
