import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:fullventas_app/ui/widget_carrito/user_info.dart';
import 'package:fullventas_app/ui/widget_carrito/payment_service.dart';
import 'package:fullventas_app/ui/widget_carrito/pago_yape.dart';
import 'package:fullventas_app/ui/widget_carrito/ticketScreen.dart';
import 'package:fullventas_app/ui/widget_carrito/libroReclamaciones.dart';
import 'package:fullventas_app/ui/widget_carrito/pago.dart';

class SeleccionMetodoPago extends StatefulWidget {
  final String nombreCliente;
  final String emailCliente;

  const SeleccionMetodoPago({
    Key? key,
    required this.nombreCliente,
    required this.emailCliente,
  }) : super(key: key);

  @override
  _SeleccionMetodoPagoState createState() => _SeleccionMetodoPagoState();
}

class _SeleccionMetodoPagoState extends State<SeleccionMetodoPago> {
  int _metodoPagoSeleccionado = 0;
  final TextEditingController distritoController = TextEditingController();
  final TextEditingController producto1Controller = TextEditingController();
  final TextEditingController producto2Controller = TextEditingController();
  final TextEditingController cantidadProducto1Controller =
      TextEditingController();
  final TextEditingController cantidadProducto2Controller =
      TextEditingController();
  final TextEditingController sucursalController = TextEditingController();
  final TextEditingController tamanoProducto1Controller =
      TextEditingController();
  final TextEditingController tamanoProducto2Controller =
      TextEditingController();
  late TextEditingController nombreClienteController = TextEditingController();
  TextEditingController celularClienteController = TextEditingController();
  TextEditingController emailClienteController = TextEditingController();
  TextEditingController direccionClienteController = TextEditingController();
  TextEditingController referenciaClienteController = TextEditingController();
  TextEditingController recepcionClienteController = TextEditingController();

  final UserService _userService = UserService();
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _clienteData;

  @override
  void initState() {
    super.initState();

    nombreClienteController = TextEditingController(text: widget.nombreCliente);
    emailClienteController = TextEditingController(text: widget.emailCliente);

    _fetchUserData();
  }

  void _fetchUserData() async {
    await _userService
        .fetchUserData(); // Llamar al servicio para obtener los datos
    setState(() {
      _userData = _userService.userData; // Asignar los datos obtenidos
    });
  }

  String _obtenerTextoEstado(int estado) {
    switch (estado) {
      case 0:
        return "Pendiente";
      case 1:
        return "Pagado";
      default:
        return "Desconocido";
    }
  }

  String _obtenerNombreMetodoPago(int metodo) {
    switch (metodo) {
      case 0:
        return "enGym";
      case 1:
        return "Tarjeta";
      case 2:
        return "Yape";
      default:
        return "Desconocido";
    }
  }

  Future<Map<String, dynamic>> getProductInfo(int productId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.2/gull_ventas_php_project-master/get_product_prices.php?producto_id=$productId'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'error') {
        // Manejar error
        throw Exception(data['message']);
      }
      return {
        "price": double.tryParse(data["precio"]["price"]) ?? 0.0,
        "category": int.tryParse(data["precio"]["category"]) ??
            0, // Retorna el precio del producto
        "title": data["precio"]["title"] ?? '',
      };
    } else {
      throw Exception('Error al obtener la información del producto');
    }
  }

  Future<Map<String, dynamic>> obtenerSucursal(int sucursalId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.2/gull_ventas_php_project-master/get_sucursal.php?sucursal_id=$sucursalId'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'error') {
        // Manejar error
        throw Exception(data['message']);
      }
      return data;
    } else {
      throw Exception('Error al obtener la información del producto');
    }
  }

  Future<Map<String, dynamic>> obtenerSize(int sizeId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.2/gull_ventas_php_project-master/get_size.php?size_id=$sizeId'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'error') {
        // Manejar error
        throw Exception(data['message']);
      }
      return data;
    } else {
      throw Exception('Error al obtener la información del producto');
    }
  }

  Future<Map<String, dynamic>> _sendOrderData({
    required String orderUserId,
    required int orderClientId,
    required String orderNoti,
    required int orderSucursalId,
    required String orderDistrito,
    required double amount,
    required int orderCostoEnvio,
    required int orderComisionCulqi,
    required List<Map<String, dynamic>> orderedProducts,
    required String orderMethod,
    required int orderStatus,
  }) async {
    final body = {
      "order_user_id": orderUserId,
      "order_client_id": orderClientId,
      "order_noti": orderNoti,
      "order_sucursal_id": orderSucursalId,
      "order_distrito": orderDistrito,
      "amount": amount / 100,
      "order_costo_envio": orderCostoEnvio,
      "order_comision_culqui": orderComisionCulqi,
      "ordered_products": orderedProducts,
      "order_method": orderMethod,
      "order_status": orderStatus,
    };

    print("Enviando datos de la orden: $body");

    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.1.2/gull_ventas_php_project-master/insert_order.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("Respuesta de insert_order.php: ${response.body}");

      if (response.statusCode == 200) {
        final orderResponse = jsonDecode(response.body);
        return orderResponse;
      } else {
        return {"status": "error", "message": "Error al insertar la orden"};
      }
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  Future<void> procesarPago(BuildContext context) async {
    final producto1Id = int.tryParse(producto1Controller.text) ?? 0;
    final producto2Id = int.tryParse(producto2Controller.text) ?? 0;

    final producto1Info = await getProductInfo(producto1Id);
    final producto2Info = await getProductInfo(producto2Id);

    final cantProd1 = int.tryParse(cantidadProducto1Controller.text) ?? 0;
    final cantProd2 = int.tryParse(cantidadProducto2Controller.text) ?? 0;
    final totalAmount = (producto1Info["price"] * cantProd1 +
            producto2Info["price"] * cantProd2) *
        100;

    String distrito = distritoController.text;
    int estadoCompra = (_metodoPagoSeleccionado == 0) ? 0 : 1;
    String fechaHora = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    String estado = _obtenerTextoEstado(estadoCompra);
    String metodo = _obtenerNombreMetodoPago(_metodoPagoSeleccionado);

    final sucursalId = int.tryParse(sucursalController.text) ?? 0;
    final _sucursalData = await obtenerSucursal(sucursalId);
    final sizeData1 =
        await obtenerSize(int.tryParse(tamanoProducto1Controller.text) ?? 0);
    final sizeData2 =
        await obtenerSize(int.tryParse(tamanoProducto2Controller.text) ?? 0);

    final productos = [
      {
        "product_id": producto1Id,
        "product_nombre": producto1Info["title"],
        "ordered_quantity": cantProd1,
        "product_price": producto1Info["price"],
        "tipo_categoria": producto1Info["category"],
        "size_id": sizeData1['size_id'],
        "size_nombre": sizeData1['size_name']
      },
      {
        "product_id": producto2Id,
        "product_nombre": producto2Info["title"],
        "ordered_quantity": cantProd2,
        "product_price": producto2Info["price"],
        "tipo_categoria": producto2Info["category"],
        "size_id": sizeData2["size_id"],
        "size_nombre": sizeData2["size_name"]
      }
    ];

    if (_metodoPagoSeleccionado == 1) {
      // Pago con tarjeta
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            userData: _userData!,
            distrito: distrito,
            productos: productos,
            total: totalAmount,
            metodoPago: _metodoPagoSeleccionado,
            estadoPago: estadoCompra,
            sucursal: _sucursalData,
          ),
        ),
      );
    } else if (_metodoPagoSeleccionado == 2) {
      // Pago con Yape
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PagoYapePage(
            userData: _userData!,
            distrito: distrito,
            productos: productos,
            total: totalAmount,
            metodoPago: _metodoPagoSeleccionado,
            estadoPago: estadoCompra,
            sucursal: _sucursalData,
          ),
        ),
      );
    } else {
      // Pago en el gimnasio
      final orderResponse = await _sendOrderData(
        orderUserId: _userData!['user_id'],
        orderClientId: 4,
        orderNoti: '1',
        orderSucursalId: sucursalId,
        orderDistrito: distrito,
        amount: totalAmount,
        orderCostoEnvio: 0,
        orderComisionCulqi: 0,
        orderedProducts: productos,
        orderMethod: metodo,
        orderStatus: estadoCompra,
      );

      final int orderId = orderResponse['ticket_number'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TicketScreen(
            distrito: distrito,
            total: totalAmount / 100,
            fechaHora: fechaHora,
            userData: _userData!,
            productos: productos,
            orderCostoEnvio: 0,
            orderStatus: estado,
            orderID: orderId,
            orderMethod: metodo,
            sucursalTicket: _sucursalData,
          ),
        ),
      );
    }
  }

  Future<void> guardarCliente(BuildContext context) async {
    final urlInsert = Uri.parse(
        'http://192.168.1.2/gull_ventas_php_project-master/insert_cliente1.php');
    final urlUpdate = Uri.parse(
        'http://192.168.1.2/gull_ventas_php_project-master/update_cliente1.php');

    final producto1Id = int.tryParse(producto1Controller.text) ?? 0;
    final producto2Id = int.tryParse(producto2Controller.text) ?? 0;

    final producto1Info = await getProductInfo(producto1Id);
    final producto2Info = await getProductInfo(producto2Id);

    String email = emailClienteController.text;
    String celular = celularClienteController.text;

    bool existe = false;
    String clienteID = '';

    final urlCheck = Uri.parse(
        'http://192.168.1.2/gull_ventas_php_project-master/get_cliente.php?email=$email&celular=$celular');
    final responseCheck = await http.get(urlCheck);
    if (responseCheck.statusCode == 200) {
      final data = json.decode(responseCheck.body);
      existe = data['exists'] == true;
      clienteID = data['id'] ?? ''; // Guardamos el ID del cliente si existe
    }

    String tipoCliente =
        (producto1Info['category'] == 2 || producto2Info['category'] == 2)
            ? 'interno'
            : 'externo';
    String nombreCompleto = nombreClienteController.text.trim();
    List<String> partesNombre = nombreCompleto.split(' ');

    String nombres = '';
    String apellidos = '';

    if (partesNombre.length == 2) {
      // Ejemplo: "Carlos Pérez"
      nombres = partesNombre[0]; // Nombre
      apellidos = partesNombre[1]; // Apellido
    } else if (partesNombre.length == 3) {
      // Ejemplo: "Carlos Pérez Gómez"
      nombres = partesNombre[0]; // Primer nombre
      apellidos = "${partesNombre[1]} ${partesNombre[2]}"; // Dos apellidos
    } else if (partesNombre.length >= 4) {
      // Ejemplo: "Carlos Andrés Pérez Gómez"
      nombres = "${partesNombre[0]} ${partesNombre[1]}"; // Dos nombres
      apellidos = "${partesNombre[2]} ${partesNombre[3]}"; // Dos apellidos
    } else {
      // Si solo hay un nombre o un solo apellido
      nombres = nombreCompleto;
      apellidos = '';
    }

    final body = {
      'cliente_id': clienteID,
      'cliente_id_admin': _userData?['user_id'] ?? '',
      'codigo': '',
      'nombres': nombres,
      'apellidos': apellidos,
      'celular': celular,
      'email': email,
      'direccion': direccionClienteController.text,
      'tipo_cliente': tipoCliente,
      'status': '1',
      'image_name': '',
    };

    final response = await http.post(
      existe ? urlUpdate : urlInsert,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: body,
    );

    print("Respuesta del servidor: ${response.body}");
    try {
      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        print('Cliente ${existe ? "actualizado" : "registrado"} con éxito');
        await procesarPago(context);
      } else {
        print('Error al guardar cliente: ${responseData['message']}');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3391FA),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nombreClienteController,
                decoration: InputDecoration(labelText: 'Nombre Completo'),
              ),
              TextField(
                controller: celularClienteController,
                decoration: InputDecoration(labelText: 'Whatsapp'),
              ),
              TextField(
                controller: emailClienteController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: direccionClienteController,
                decoration: InputDecoration(labelText: 'Dirección'),
              ),
              TextField(
                controller: referenciaClienteController,
                decoration: InputDecoration(labelText: 'Referencia'),
              ),
              TextField(
                controller: recepcionClienteController,
                decoration:
                    InputDecoration(labelText: 'Persona que recibe/recoge'),
              ),
              TextField(
                controller: sucursalController,
                decoration: InputDecoration(labelText: 'Sucursal ID'),
              ),
              TextField(
                controller: distritoController,
                decoration: InputDecoration(labelText: 'Distrito de envio'),
              ),
              TextField(
                controller: producto1Controller,
                decoration: InputDecoration(labelText: 'Producto 1'),
              ),
              TextField(
                controller: tamanoProducto1Controller,
                decoration: InputDecoration(labelText: 'Tamaño 1'),
              ),
              TextField(
                controller: cantidadProducto1Controller,
                decoration: InputDecoration(labelText: 'Cant. 1'),
              ),
              TextField(
                controller: producto2Controller,
                decoration: InputDecoration(labelText: 'Producto 2'),
              ),
              TextField(
                controller: tamanoProducto2Controller,
                decoration: InputDecoration(labelText: 'Tamaño 2'),
              ),
              TextField(
                controller: cantidadProducto2Controller,
                decoration: InputDecoration(labelText: 'Cant. 2'),
              ),
              SizedBox(height: 20.0),
              Center(
                child: Text('Forma de Pago',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF3391FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    RadioListTile(
                      activeColor: Colors.white,
                      title: Text('Pago en el mismo gimnasio',
                          style: TextStyle(color: Colors.white)),
                      value: 0,
                      groupValue: _metodoPagoSeleccionado,
                      onChanged: (value) {
                        setState(() {
                          _metodoPagoSeleccionado = value as int;
                        });
                      },
                    ),
                    RadioListTile(
                      activeColor: Colors.white,
                      title: Text('Pago con tarjeta de débito/crédito',
                          style: TextStyle(color: Colors.white)),
                      value: 1,
                      groupValue: _metodoPagoSeleccionado,
                      onChanged: (value) {
                        setState(() {
                          _metodoPagoSeleccionado = value as int;
                        });
                      },
                    ),
                    RadioListTile(
                      activeColor: Colors.white,
                      title: Text('Pago con Yape',
                          style: TextStyle(color: Colors.white)),
                      value: 2,
                      groupValue: _metodoPagoSeleccionado,
                      onChanged: (value) {
                        setState(() {
                          _metodoPagoSeleccionado = value as int;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await guardarCliente(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3391FA),
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Center(
                  child: Text('Pagar', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LibroReclamacionesScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3391FA),
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Center(
                  child: Text("Libro de Reclamaciones",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
