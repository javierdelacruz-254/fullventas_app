import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fullventas_app/ui/widget_carrito/ticket_screen.dart';
import 'dart:io';
import 'dart:async';

class PagoYapePage extends StatelessWidget {
  final TextEditingController _codigoYapeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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

  Future<void> _generarTokenYape(BuildContext context) async {
    final String otp = _codigoYapeController.text.trim();
    final String phone = _phoneController.text.trim();
    final String email = _emailController.text.trim();

    print('🔵 [DEBUG] Iniciando generación de token Yape');
    print('🟠 [DEBUG] Datos ingresados:');
    print('          OTP: $otp');
    print('          Teléfono: $phone');
    print('          Email: $email');
    print('          Monto: ${total.toStringAsFixed(2)} PEN');

    // ... validaciones previas ...

    try {
      final Map<String, dynamic> requestBody = {
        "otp": otp,
        "number_phone": phone,
        "amount": (total * 100).toInt(),
        "id_negocio": 2,
        "email": email,
      };

      print('🟢 [DEBUG] Enviando a servidor (token_yape.php):');
      print(jsonEncode(requestBody));

      final response = await http
          .post(
            Uri.parse(
                'http://192.168.18.3/mystore/gull_ventas_php_project/token_yape.php'),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 30));

      print('🔵 [DEBUG] Respuesta del servidor:');
      print('          Código HTTP: ${response.statusCode}');
      print('          Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('🟢 [DEBUG] Respuesta decodificada:');
        print(responseData);

        if (responseData['success'] == true && responseData['id'] != null) {
          print('✅ [DEBUG] Token generado exitosamente: ${responseData['id']}');
          await _generarCargoYape(responseData['id'], context);
        } else {
          print('❌ [DEBUG] Error en respuesta del servidor');
          _message.value =
              "❌ ${responseData['error'] ?? 'Error al generar token'}";
        }
      } else {
        print('❌ [DEBUG] Error HTTP: ${response.statusCode}');
        _message.value = "❌ Error en la conexión (${response.statusCode})";
      }
    } on FormatException catch (e) {
      print('❌ [DEBUG] FormatException: $e');
      _message.value = "Error en el formato de los datos recibidos";
    } on SocketException catch (e) {
      print('❌ [DEBUG] SocketException: $e');
      _message.value = "Error de conexión. Verifique su internet";
    } on TimeoutException catch (e) {
      print('❌ [DEBUG] TimeoutException: $e');
      _message.value = "La operación tardó demasiado. Intente nuevamente";
    } on http.ClientException catch (e) {
      print('❌ [DEBUG] ClientException: ${e.message}');
      _message.value = "Error en la solicitud: ${e.message}";
    } catch (e) {
      print('❌ [DEBUG] Excepción no manejada: $e');
      _message.value = "Error inesperado: ${e.toString()}";
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _verificarEstadoPagoPeriodicamente(
      String sourceId, BuildContext context) async {
    const maxIntentos = 5;
    const intervalo = Duration(seconds: 5);
    bool pagoConfirmado = false;

    for (int intento = 0; intento < maxIntentos; intento++) {
      await Future.delayed(intervalo);

      try {
        final response = await http.post(
          Uri.parse(
              'http://192.168.18.3/mystore/gull_ventas_php_project/verificar_pago.php'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"source_id": sourceId}),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['estado'] == 'pagado') {
            pagoConfirmado = true;
            _message.value = "✅ Pago confirmado";
            await _insertarOrdenYape(context);
            break;
          }
        }
      } catch (e) {
        print('Error al verificar pago: $e');
      }
    }

    if (!pagoConfirmado) {
      _message.value = "⚠ No se pudo confirmar el pago. Verifique su app Yape";
    }
  }

  Future<void> _generarCargoYape(String sourceId, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.18.3/mystore/gull_ventas_php_project/cargo_yape.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "source_id": sourceId,
          "email": _emailController.text.trim(),
          "amount": (total * 100).toInt(),
          "id_negocio": 2,
          "currency": "PEN",
        }),
      );

      print('🔵 [DEBUG] Respuesta del cargo_yape.php:');
      print('          Código HTTP: ${response.statusCode}');
      print('          Body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _message.value = "✅ Pago exitoso";
        await _insertarOrdenYape(context);
      } else if (response.statusCode == 201) {
        if (responseData.containsKey('culqi_id')) {
          _message.value = "⚠ Abra su app Yape para confirmar el pago";
          await _verificarEstadoPagoPeriodicamente(
              responseData['culqi_id'], context);
        } else {
          _message.value =
              "⚠ Token generado pero sin culqi_id. Verifique respuesta del servidor.";
          print('❌ [DEBUG] culqi_id no encontrado en la respuesta');
        }
      } else {
        _message.value =
            "❌ Error inesperado: ${responseData['error'] ?? 'Respuesta inválida'}";
      }
    } on SocketException catch (e) {
      print('❌ [DEBUG] Error de red: $e');
      _message.value = "Error de conexión. Verifique su red.";
    } on FormatException catch (e) {
      print('❌ [DEBUG] Error de formato JSON: $e');
      _message.value = "Respuesta con formato incorrecto del servidor.";
    } catch (e) {
      print('❌ [DEBUG] Excepción general: $e');
      _message.value = "Error inesperado al procesar el pago.";
    }
  }

  Future<void> _insertarOrdenYape(BuildContext context) async {
    print('🔵 [DEBUG] Insertando orden en sistema...');

    final String metodo = _obtenerNombreMetodoPago(metodoPago);
    final String fechaHora =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final String statusText = _obtenerTextoEstado(estadoPago);

    final Map<String, dynamic> data = {
      "amount": total,
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

    print('🟢 [DEBUG] Datos para insertar orden:');
    print(jsonEncode(data));

    try {
      final response = await http
          .post(
            Uri.parse(
                'http://192.168.18.3/mystore/gull_ventas_php_project/insert_order.php'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      print('🔵 [DEBUG] Respuesta del servidor (insert_order.php):');
      print('          Código HTTP: ${response.statusCode}');
      print('          Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print('✅ [DEBUG] Orden insertada exitosamente');
          print('          Número de ticket: ${responseData['ticket_number']}');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketScreen(
                distrito: distrito,
                total: total,
                userData: userData,
                fechaHora: fechaHora,
                productos: productos,
                orderCostoEnvio: 10,
                orderStatus: statusText,
                orderID: responseData['ticket_number'],
                orderMethod: metodo,
                sucursalTicket: sucursal,
              ),
            ),
          );
        } else {
          print('❌ [DEBUG] Error al insertar orden');
          _message.value =
              "⚠ Error al generar ticket: ${responseData['message']}";
        }
      } else {
        print('❌ [DEBUG] Error HTTP al insertar orden');
        _message.value = "⚠ Error al registrar orden (${response.statusCode})";
      }
    } catch (e) {
      print('❌ [DEBUG] Error al conectar con servidor: $e');
      _message.value = "⚠ Error al conectar con el servidor";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pago con Yape"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Complete los datos para pagar con Yape",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildInputField(
              controller: _phoneController,
              label: "Número de celular",
              hint: "9XXXXXXXX",
              keyboardType: TextInputType.phone,
              maxLength: 9,
              prefixText: "+51 ",
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _codigoYapeController,
              label: "Código Yape",
              hint: "6 dígitos de tu app Yape",
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _emailController,
              label: "Correo electrónico",
              hint: "ejemplo@correo.com",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),
            ValueListenableBuilder<bool>(
              valueListenable: _isLoading,
              builder: (context, isLoading, _) {
                return ElevatedButton(
                    onPressed:
                        isLoading ? null : () => _generarTokenYape(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Builder(
                      builder: (context) => isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Pagar S/ ${total.toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 18),
                            ),
                    ));
              },
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<String>(
              valueListenable: _message,
              builder: (context, message, _) {
                return message.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: message.startsWith("✅")
                              ? Colors.green[100]
                              : Colors.red[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message,
                          style: TextStyle(
                            color: message.startsWith("✅")
                                ? Colors.green[800]
                                : Colors.red[800],
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType keyboardType,
    int? maxLength,
    String? prefixText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        prefixText: prefixText,
        counterText: "",
      ),
    );
  }
}
