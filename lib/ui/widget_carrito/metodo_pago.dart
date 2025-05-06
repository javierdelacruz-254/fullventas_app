import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/user_provider.dart';
import 'package:fullventas_app/ui/pages/home_page.dart';
import 'package:fullventas_app/ui/widget_carrito/pago_yape.dart';
import 'package:fullventas_app/ui/widget_carrito/pago.dart';
import 'package:fullventas_app/domain/models/fullventas_data/services_data.dart';
import 'package:fullventas_app/ui/pages/libro_reclamaciones.dart';
import 'package:fullventas_app/config/providers/carrito_provider.dart';
import 'package:fullventas_app/ui/widget_carrito/ticket_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MetodoPago extends ConsumerStatefulWidget {
  final double total;
  const MetodoPago({super.key, required this.total});

  @override
  MetodoPagoState createState() => MetodoPagoState();
}

class MetodoPagoState extends ConsumerState<MetodoPago> {
  String selectedPayment = "Pago en el mismo Gimnasio";
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController referenciaController = TextEditingController();
  final TextEditingController personaRecibeController = TextEditingController();

  // ==================== DEBUG METHODS ====================
  void _printDebugInfo({String? phase}) {
    debugPrint('\n=== DEBUG $phase ===');
    debugPrint('• Nombre: ${nombreController.text}');
    debugPrint(
        '• WhatsApp: ${whatsappController.text} (Válido: ${whatsappController.text.isPhoneNumber})');
    debugPrint(
        '• Email: ${emailController.text} (Válido: ${emailController.text.isEmail})');
    debugPrint('• Dirección: ${direccionController.text}');
    debugPrint('• Referencia: ${referenciaController.text}');
    debugPrint('• Persona Recibe: ${personaRecibeController.text}');
    debugPrint('• Método Pago: $selectedPayment');
    debugPrint('• Total: ${widget.total}');
  }

  void _printCarrito(List<dynamic> carrito) {
    debugPrint('\n=== PRODUCTOS EN CARRITO ===');
    if (carrito.isEmpty) {
      debugPrint('El carrito está vacío!');
      return;
    }
    for (var item in carrito) {
      debugPrint(
          '• ${item['servicio.title'] ?? 'Producto sin nombre'} x${item['ordered_quantity'] ?? 1}');
    }
  }

  void _printResponse(http.Response response) {
    debugPrint('\n=== RESPUESTA DEL SERVIDOR ===');
    debugPrint('Status: ${response.statusCode}');
    debugPrint('Body: ${response.body}');
  }
  // =======================================================

  Map<String, dynamic> _buildRequestData(List<dynamic> carrito) {
    final data = {
      "user_id": 2,
      "total": widget.total,
      "metodo_pago": _getPaymentMethodCode(),
      "nombre": nombreController.text.cleanInput(),
      "whatsapp": whatsappController.text.cleanInput(),
      "email": emailController.text.cleanInput(),
      "direccion": direccionController.text.cleanInput(),
      "referencia": referenciaController.text.cleanInput(),
      "persona_recibe": personaRecibeController.text.cleanInput(),
      "productos": carrito
          .map((p) => {
                "id": p["product_id"] ?? 0,
                "qty": p["ordered_quantity"] ?? 1,
                "name": p["name"] ?? "Producto sin nombre",
                "precio": p["previousPrice"] ?? 0.0,
                "tipo_categoria": p["tipo_categoria"] ?? "",
                "product_size_id": p["product_size_id"] ?? 0,
              })
          .toList(),
    };

    debugPrint('\n=== JSON ENVIADO ===\n${jsonEncode(data)}');
    return data;
  }

  String _getPaymentMethodCode() {
    switch (selectedPayment) {
      case "Pago en el mismo Gimnasio":
        return "pago_gym";
      case "Pago con yape":
        return "yape";
      case "Pago con tarjeta débito, crédito, etc":
        return "tarjeta";
      default:
        return "otros";
    }
  }

  void cleanInputs() {
    nombreController.text = nombreController.text.trim();
    whatsappController.text = whatsappController.text.trim();
    emailController.text = emailController.text.trim();
    direccionController.text = direccionController.text.trim();
    referenciaController.text = referenciaController.text.trim();
    personaRecibeController.text = personaRecibeController.text.trim();
  }

  bool isFormValid() {
    cleanInputs();
    _printDebugInfo(phase: 'VALIDACIÓN');

    if (nombreController.text.isEmpty) {
      _showFieldError("Ingrese su nombre completo");
      return false;
    }
    if (!whatsappController.text.isPhoneNumber) {
      _showFieldError("WhatsApp debe tener 9-12 dígitos");
      return false;
    }
    if (!emailController.text.isEmail) {
      _showFieldError("Ingrese un email válido");
      return false;
    }
    if (direccionController.text.isEmpty) {
      _showFieldError("Ingrese su dirección");
      return false;
    }
    if (referenciaController.text.isEmpty) {
      _showFieldError("Ingrese una referencia");
      return false;
    }
    if (personaRecibeController.text.isEmpty) {
      _showFieldError("Ingrese quien recibirá el pedido");
      return false;
    }
    return true;
  }

  void _showFieldError(String message) {
    debugPrint('Error de validación: $message');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
    ));
  }

  Future<void> handlePago() async {
    _printDebugInfo(phase: 'INICIO PAGO');

    if (!isFormValid()) return;

    final carrito = ref.read(carritoProvider);
    _printCarrito(carrito);

    if (carrito.isEmpty) {
      mostrarError("No hay productos en el carrito");
      return;
    }

    try {
      if (selectedPayment == "Pago con yape") {
        _redirectToYape(carrito);
      } else if (selectedPayment == "Pago con tarjeta débito, crédito, etc") {
        _redirectToCardPayment(carrito);
      } else if (selectedPayment == "Pago en el mismo Gimnasio") {
        await _processGymPayment(carrito);
      }
    } catch (e) {
      debugPrint('\n!!! ERROR CRÍTICO !!!\n$e\n');
      _printDebugInfo(phase: 'ERROR');
      mostrarError("Error al procesar el pago. Por favor intente nuevamente.");
    }
  }

  void _redirectToYape(List<dynamic> carrito) {
    debugPrint('Redirigiendo a pago Yape');
    final carrito = ref.read(carritoProvider);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PagoYapePage(
            userData: {"id": 2},
            distrito: "Lima",
            productos: carrito,
            total: widget.total,
            metodoPago: 2,
            estadoPago: 0,
            sucursal: {"id": 1},
          ),
        ));
  }

  void _redirectToCardPayment(List<dynamic> carrito) {
    debugPrint('Redirigiendo a pago con tarjeta');
    final carrito = ref.read(carritoProvider);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            userData: {"id": 2},
            distrito: "Lima",
            productos: carrito,
            amount: widget.total,
            metodoPago: 1,
            estadoPago: 0,
            sucursal: {"id": 2},
          ),
        ));
  }

  Future<void> _processGymPayment(List<dynamic> carrito) async {
    const url =
        "http://192.168.18.3/mystore/gull_ventas_php_project/insert_order.php";
    debugPrint('Enviando datos a: $url');

    // Construimos los datos en el formato correcto
    final requestData = {
      "order_method":
          "Pago en el mismo gym", // Puedes modificar esto según el método de pago
      "order_amount": widget.total, // Total de la compra
      "order_costo_envio": 0.0, // Si hay costo de envío
      "order_comision_culqui": 2.96, // Comisión de Culqi o el servicio de pago
      "order_user_id": 2, // El ID del usuario
      "order_client_id": 1, // El ID del cliente, ajusta según sea necesario
      "order_time": DateTime.now().toIso8601String(), // Hora de la orden
      "status": 0, // Estado de la orden, lo puedes modificar según el flujo
      "order_noti": 1, // Si se notificará
      "order_sucursal_id": 2, // ID de la sucursal
      "order_distrito": "Lima", // Distrito donde se hace el pedido
      "ordered_products": carrito.map((producto) {
        final servicio = producto['producto'] as ServicesData;
        final cantidad = producto['cantidad'] ?? 1;
        final categoria =
            producto['tipo_categoria'] ?? servicio.category?.toString() ?? '0';
        final previousPrice =
            producto['previousPrice'] ?? servicio.previousPrice ?? 0.0;

        final totalProducto = previousPrice * cantidad;

        print('[DEBUG] Producto:');
        print('- ID: ${servicio.id}');
        print('- Nombre: ${servicio.title}');
        print('- Cantidad: $cantidad');
        print('- Tipo categoría: $categoria');
        print('- Precio unitario: $previousPrice');
        print('- Precio total: $totalProducto');

        return {
          'product_id': servicio.id ?? 0,
          'ordered_quantity': cantidad,
          'categoria': categoria,
          'previousPrice': previousPrice,
          'name': servicio.title ?? 'Producto sin nombre',
          'product_size_id': null, // Campo requerido por la API
        };
      }).toList(),
    };

    // Enviamos la solicitud
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestData),
    );

    // Llamamos a la función para manejar la respuesta del servidor
    _handleServerResponse(response, carrito);
  }

  void _handleServerResponse(http.Response response, List<dynamic> carrito) {
    final cleanedResponse =
        response.body.replaceAll(RegExp(r'<[^>]*>|br|\/'), '');
    debugPrint('Respuesta limpia: $cleanedResponse');

    try {
      final data = jsonDecode(cleanedResponse);

      if (response.statusCode == 200 && data["status"] == "success") {
        if (data["order_id"] == null) {
          throw Exception("El servidor no devolvió un ID de orden válido");
        }
        final carrito = ref.read(carritoProvider);

        _showSuccessScreen(data["order_id"], carrito);
      } else {
        throw Exception(data["message"] ?? "Error desconocido del servidor");
      }
    } catch (e) {
      debugPrint('Error al procesar respuesta: $e');
      throw Exception("Error al interpretar la respuesta del servidor");
    }
  }

  void _showSuccessScreen(
      dynamic orderId, List<Map<String, dynamic>> orderedProducts) {
    debugPrint('Pedido exitoso! ID: $orderId');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketScreen(
          userData: {"id": 2},
          distrito: "Lima",
          productos: orderedProducts, // Usamos orderedProducts aquí
          total: widget.total,
          fechaHora: DateTime.now().toIso8601String(),
          orderCostoEnvio: 0,
          orderStatus: "Pendiente",
          orderID: orderId,
          orderMethod: "En el mismo GYM",
          sucursalTicket: {"id": 2},
        ),
      ),
    );
  }

  void mostrarError(String mensaje) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: "Error",
      desc: mensaje,
      btnOkText: "Aceptar",
      btnOkOnPress: () {},
    ).show();
  }

  Widget buildTextField(
      String label, TextEditingController controller, bool enabled,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: label,
              border: const OutlineInputBorder(),
              errorText: _getFieldError(controller),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  String? _getFieldError(TextEditingController controller) {
    if (controller == whatsappController &&
        controller.text.isNotEmpty &&
        !controller.text.isPhoneNumber) {
      return 'Número inválido';
    }
    if (controller == emailController &&
        controller.text.isNotEmpty &&
        !controller.text.isEmail) {
      return 'Email inválido';
    }
    return null;
  }

  Widget buildRadioButton(String value) {
    return RadioListTile<String>(
      title: Text(value, style: const TextStyle(color: Colors.white)),
      value: value,
      groupValue: selectedPayment,
      onChanged: (String? newValue) =>
          setState(() => selectedPayment = newValue!),
      activeColor: const Color(0xFFD0E4FF),
    );
  }

  @override
  void initState() {
    super.initState();
    final cliente = ref.read(userProvider);
    nombreController.text = cliente?.nombres ?? "";
    whatsappController.text = cliente?.celular?.toString() ?? "";
    emailController.text = cliente?.email ?? "";
    direccionController.text = cliente?.direccion ?? "";
    _printDebugInfo(phase: 'INICIALIZACIÓN');
  }

  @override
  Widget build(BuildContext context) {
    final isGoogleUser = ref.watch(userProvider.notifier).isGoogleUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3391FA),
        title: const Text("Datos del Cliente",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField("Nombre Completo", nombreController, true),
              buildTextField("Whatsapp", whatsappController, !isGoogleUser,
                  keyboardType: TextInputType.phone),
              buildTextField("Email", emailController, true,
                  keyboardType: TextInputType.emailAddress),
              buildTextField("Dirección", direccionController, !isGoogleUser),
              buildTextField("Referencia", referenciaController, true),
              buildTextField(
                  "Persona que recibe", personaRecibeController, true),
              const SizedBox(height: 10),
              const Text("Distrito: Lima", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              const Divider(),
              const Center(
                child: Text("Forma de pago",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF3391FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    buildRadioButton("Pago en el mismo Gimnasio"),
                    buildRadioButton("Pago con tarjeta débito, crédito, etc"),
                    buildRadioButton("Pago con yape"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3391FA),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: handlePago,
                  child: const Text("Pagar",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3391FA),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LibroReclamaciones()),
                  ),
                  child: const Text("Libro de reclamaciones",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtensions on String {
  bool get isPhoneNumber => RegExp(r'^[0-9]{9,12}$').hasMatch(this);

  bool get isEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  String cleanInput() {
    return trim()
        .replaceAll('\n', ' ')
        .replaceAll('\r', ' ')
        .replaceAll('"', "'")
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
