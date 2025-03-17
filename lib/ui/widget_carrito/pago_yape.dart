import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fullventas_app/ui/widget_carrito/ticket_screen.dart';
import 'package:intl/intl.dart';

class PagoYapePage extends StatelessWidget {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  double _totalAmount = 0.0;

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<String> _message = ValueNotifier("");

  final String distrito;
  final Map<String, dynamic> userData;
  final List<Map<String, dynamic>> productos;
  final double total;
  final int metodoPago;
  final int estadoPago;
  final Map<String, dynamic> sucursal;
  PagoYapePage({
    required this.userData,
    required this.distrito,
    required this.productos,
    required this.total,
    required this.metodoPago,
    required this.estadoPago,
    required this.sucursal,
  });

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

  Future<void> generarTokenYape(BuildContext context) async {
    final String otp = _otpController.text.trim();
    final String phone = _phoneController.text.trim();

    if (otp.length != 6 || phone.length != 9) {
      _message.value = "Por favor, ingrese datos válidos.";
      return;
    }

    _isLoading.value = true;
    _message.value = "";

    try {
      final url = Uri.parse(
          'http://192.168.1.5/gull_ventas_php_project-master/token_yape.php');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "otp": otp,
          "number_phone": phone,
          "amount": total,
          "id_negocio": int.parse(userData['user_id']),
        }),
      );

      print("Respuesta completa del servidor: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data.containsKey("id")) {
          await generarCargoYape(
            data["id"],
            productos,
            context,
          );
        } else {
          _message.value = "Error al generar el token Yape.";
        }
      } else {
        _message.value = "Error en el pago: ${response.body}";
      }
    } catch (e) {
      print("Error de conexión token.:$e");
      _message.value = "Error de conexión token.:$e";
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> generarCargoYape(
    String tokenYape,
    List<Map<String, dynamic>> productos,
    BuildContext context,
  ) async {
    final String email = _emailController.text.trim();
    if (email.isEmpty) {
      _message.value = "Por favor, ingrese su correo.";
      return;
    }

    final url = Uri.parse(
        'http://192.168.1.5/gull_ventas_php_project-master/cargo_yape.php');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "token_yape": tokenYape,
          "email": email,
          "amount": total,
          "id_negocio": int.parse(userData['user_id']),
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _message.value = "Pago exitoso.";
        await insertarOrdenYape(
          productos,
          context,
        );
      } else {
        _message.value = "Error en el pago: ${response.body}";
      }
    } catch (e) {
      _message.value = "Error de conexión cargo.";
    }
  }

  Future<void> insertarOrdenYape(
    List<Map<String, dynamic>> productos,
    BuildContext context,
  ) async {
    String metodo = _obtenerNombreMetodoPago(metodoPago);
    String fechaHora = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    String statusText = _obtenerTextoEstado(estadoPago);

    final url = Uri.parse(
        'http://192.168.1.5/gull_ventas_php_project-master/insert_order.php');
    final Map<String, dynamic> data = {
      "amount": total / 100,
      "order_method": metodo,
      "order_user_id": userData['user_id'],
      "order_client_id": 4,
      "order_costo_envio": 10,
      "order_comision_culqui": 2,
      "order_noti": "1",
      "order_sucursal_id": sucursal['id'],
      "order_distrito": distrito,
      "ordered_products": productos,
      "order_status": estadoPago,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      print("Respuesta de insert_order.php: ${response.body}");
      if (response.statusCode == 200) {
        _message.value = "✅ Pago y orden registrados correctamente.";
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final int orderId = responseData['ticket_number'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketScreen(
              distrito: distrito,
              total: total / 100,
              userData: userData,
              fechaHora: fechaHora,
              productos: productos,
              orderCostoEnvio: 10,
              orderStatus: statusText,
              orderID: orderId,
              orderMethod: metodo,
              sucursalTicket: sucursal,
            ),
          ),
        );
      } else {
        _message.value = "⚠ Error al registrar la orden.";
      }
    } catch (e) {
      _message.value = "🚫 Error de conexión al registrar la orden.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pago con Yape"),
          backgroundColor: Colors.deepPurple,
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              _buildTextField(_phoneController, "Número de celular",
                  keyboardType: TextInputType.phone, maxLength: 9),
              _buildTextField(_otpController, "OTP de Yape",
                  keyboardType: TextInputType.number, maxLength: 6),
              _buildTextField(_emailController, "Correo electrónico"),
              SizedBox(height: 20),
              ValueListenableBuilder<bool>(
                valueListenable: _isLoading,
                builder: (context, isLoading, child) {
                  return ElevatedButton(
                    onPressed:
                        isLoading ? null : () => generarTokenYape(context),
                    child: Text("Pagar con Yape"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 164, 132, 219),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              ValueListenableBuilder<String>(
                valueListenable: _message,
                builder: (context, message, child) {
                  return Text(message, style: TextStyle(color: Colors.red));
                },
              ),
            ])));
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
