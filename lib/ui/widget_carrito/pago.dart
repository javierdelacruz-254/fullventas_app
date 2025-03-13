import 'package:flutter/material.dart';
import 'package:fullventas_app/ui/widget_carrito/culqi_service.dart';
import 'package:fullventas_app/ui/widget_carrito/payment_service.dart';
import 'package:fullventas_app/ui/widget_carrito/ticketScreen.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatelessWidget {
  final TextEditingController cardController = TextEditingController();
  final TextEditingController expController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final String distrito;
  final Map<String, dynamic> userData;
  final List<Map<String, dynamic>> productos;
  final double total;
  final int metodoPago;
  final int estadoPago;
  final Map<String, dynamic> sucursal;

  final CulqiService culqiService = CulqiService();
  final PaymentService paymentService = PaymentService();

  PaymentScreen({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago'),
        backgroundColor: Color(0xFF3391FA),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pago con Culqi',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'GYM',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: cardController,
                        decoration: const InputDecoration(
                          labelText: 'Número de tarjeta',
                          contentPadding: EdgeInsets.all(8),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              controller: expController,
                              decoration: const InputDecoration(
                                labelText: 'Fecha de expiración (MM/YY)',
                                contentPadding: EdgeInsets.all(8),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              controller: cvvController,
                              decoration: const InputDecoration(
                                labelText: 'CVV',
                                contentPadding: EdgeInsets.all(8),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre',
                                contentPadding: EdgeInsets.all(8),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              controller: surnameController,
                              decoration: const InputDecoration(
                                labelText: 'Apellido',
                                contentPadding: EdgeInsets.all(8),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          contentPadding: EdgeInsets.all(8),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final cardNumber = cardController.text;
                        final expirationDate = expController.text.split('/');
                        final expirationMonth = expirationDate[0];
                        final expirationYear = expirationDate[1];
                        final cvv = cvvController.text;
                        final name = nameController.text;
                        final surname = surnameController.text;
                        final email = emailController.text;
                        String fechaHora = DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(DateTime.now());
                        String metodo = _obtenerNombreMetodoPago(metodoPago);
                        int status = estadoPago;
                        String statusText = _obtenerTextoEstado(estadoPago);

                        try {
                          final token = await culqiService.createToken(
                            usersId: int.parse(userData['user_id']),
                            cardNumber: cardNumber,
                            cvv: cvv,
                            expirationMonth: expirationMonth,
                            expirationYear: expirationYear,
                            email: email,
                            firstName: name,
                            lastName: surname,
                          );
                          if (token != null) {
                            final response =
                                await paymentService.processPayment(
                              amount: total, // Monto en céntimos (S/ 10.00)
                              currency: "PEN",
                              email: email,
                              sourceId: token,
                              firstName: name,
                              lastName: surname,
                              orderUserId: userData['user_id'],
                              orderClientId: 4,
                              orderNoti: "1",
                              orderSucursal: sucursal,
                              orderDistrito: distrito,
                              orderCostoEnvio: 10,
                              orderComisionCulqi: 2,
                              orderedProducts: productos,
                              orderMethod: metodo,
                              orderStatus: status,
                            );

                            if (response['status'] == 'error') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: Text(response['message']),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              final int orderId = response['ticket_number'];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TicketScreen(
                                    distrito: distrito,
                                    total: total /
                                        100, // Aquí coloca el total real de la compra
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
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Error'),
                                content:
                                    const Text('No se pudo generar el token'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        } catch (e) {
                          // Mostrar error si ocurre algo al obtener los precios
                          print('Error: $e');
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error'),
                              content: Text(
                                  'Error al obtener los precios de los productos'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CB050),
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50.0),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: const Text('Pagar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
