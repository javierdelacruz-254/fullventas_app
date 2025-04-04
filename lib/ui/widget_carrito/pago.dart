import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fullventas_app/ui/widget_carrito/payment_service.dart';
import 'package:fullventas_app/ui/widget_carrito/culqi_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String distrito;
  final List<dynamic> productos;
  final double amount;
  final int metodoPago;
  final int estadoPago;
  final Map<String, dynamic> sucursal;

  const PaymentScreen({
    Key? key,
    required this.userData,
    required this.distrito,
    required this.productos,
    required this.amount,
    required this.metodoPago,
    required this.estadoPago,
    required this.sucursal,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _culqiService = CulqiService();

  // Controladores para los campos del formulario
  final _cardNumberController = TextEditingController();
  final _cvvController = TextEditingController();
  final _expiryMonthController = TextEditingController();
  final _expiryYearController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  // Máscaras para formato de entrada
  final _cardNumberFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _expiryMonthFormatter = MaskTextInputFormatter(
    mask: '##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _expiryYearFormatter = MaskTextInputFormatter(
    mask: '####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _cvvFormatter = MaskTextInputFormatter(
    mask: '###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    print('[DEBUG] Inicializando PaymentScreen con datos:');
    print('- UserData: ${widget.userData}');
    print('- Distrito: ${widget.distrito}');
    print('- Productos: ${widget.productos}');
    print('- Total: ${widget.amount}');
    print('- Método Pago: ${widget.metodoPago}');
    print('- Estado Pago: ${widget.estadoPago}');
    print('- Sucursal: ${widget.sucursal}');
    _initializeData();
  }

  void _initializeData() {
    // Precargar datos del usuario si están disponibles
    _emailController.text = widget.userData['email'] ?? '';
    _firstNameController.text = widget.userData['first_name'] ?? '';
    _lastNameController.text = widget.userData['last_name'] ?? '';

    print('[DEBUG] Datos precargados:');
    print('- Email: ${_emailController.text}');
    print('- Nombre: ${_firstNameController.text}');
    print('- Apellido: ${_lastNameController.text}');

    // Precargar llave pública de Culqi
    _culqiService.fetchPublicKey(widget.userData['id']);
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      print('[DEBUG] Validación del formulario falló');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      print('[DEBUG] Iniciando proceso de pago...');

      // Validación del monto total
      if (widget.amount <= 0) {
        throw Exception('El monto total debe ser mayor a cero');
      }

      // Convertir el total a centavos (Culqi requiere el monto en centavos)
      final amountInCents =
          (widget.amount * 100).round(); // Usar round() para mejor precisión

// Validación extendida del monto
      print('[DEBUG] Validación de monto:');
      print('- Total original: ${widget.amount} PEN');
      print(
          '- Total en centavos: $amountInCents (Tipo: ${amountInCents.runtimeType})');

      if (amountInCents <= 0) {
        throw Exception('El monto debe ser mayor a cero');
      }
      if (amountInCents < 100) {
        // Culqi requiere mínimo 1 sol (100 centavos)
        throw Exception('El monto mínimo de pago es S/1.00');
      }
      if (amountInCents > 9999900) {
        // Culqi máximo normalmente 99,999 soles
        throw Exception('El monto máximo de pago es S/99,999.00');
      }

      // 1. Crear token en Culqi
      print('[DEBUG] Creando token en Culqi con datos:');
      print('- CardNumber: ${_cardNumberController.text.replaceAll(' ', '')}');
      print('- CVV: ${_cvvController.text}');
      print('- ExpMonth: ${_expiryMonthController.text}');
      print('- ExpYear: ${_expiryYearController.text}');
      print('- Email: ${_emailController.text}');
      print('- FirstName: ${_firstNameController.text}');
      print('- LastName: ${_lastNameController.text}');

      final token = await _culqiService.createToken(
        usersId: widget.userData['id'],
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        cvv: _cvvController.text,
        expirationMonth: _expiryMonthController.text,
        expirationYear: _expiryYearController.text,
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
      );

      if (token == null) {
        print('[ERROR] No se pudo generar el token de pago');
        throw Exception('No se pudo generar el token de pago');
      }

      print('[DEBUG] Token generado: $token');

      // 2. Convertir productos al formato requerido
      final orderedProducts = widget.productos.map((producto) {
        return {
          'product_id': producto['id']?.toString() ?? '0',
          'quantity': producto['quantity'] ?? 1,
          'price': (producto['price'] ?? 0.0),
        };
      }).toList();

      print('[DEBUG] Productos ordenados:');
      orderedProducts.forEach((product) {
        print(
            '- ProductID: ${product['product_id']}, Cantidad: ${product['quantity']}, Precio: ${product['price']}');
      });

      // 3. Calcular comisión de Culqi (ejemplo: 3.7% + S/1.00)
      final comisionCulqi = (widget.amount * 0.037).toInt();
      print('[DEBUG] Comisión Culqi calculada: $comisionCulqi');

      print('[DEBUG] Procesando pago con los siguientes datos:');
      print('- Total en centavos: $amountInCents');
      print('- Moneda: PEN');
      print('- Email: ${_emailController.text}');
      print('- Token: $token');
      print(
          '- Nombre: ${_firstNameController.text} ${_lastNameController.text}');
      print('- ID Usuario: ${widget.userData['id']}');
      print('- ID Cliente: ${widget.userData['client_id'] ?? 0}');
      print('- Sucursal: ${widget.sucursal}');
      print('- Distrito: ${widget.distrito}');
      print(
          '- Método Pago: ${widget.metodoPago == 1 ? 'Tarjeta' : 'Efectivo'}');
      print('- Estado Pago: ${widget.estadoPago}');

      final paymentResult = await PaymentService().processPayment(
        amount: amountInCents, // Enviar en centavos
        currency: 'PEN',
        email: _emailController.text,
        sourceId: token,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        orderUserId: widget.userData['id'].toString(),
        orderClientId: widget.userData['client_id'] ?? 0,
        orderNoti: 'Compra desde la app',
        orderSucursal: widget.sucursal,
        orderDistrito: widget.distrito,
        orderCostoEnvio: 0,
        orderComisionCulqi: comisionCulqi,
        orderedProducts: orderedProducts,
        orderMethod: widget.metodoPago == 1 ? 'Tarjeta' : 'Efectivo',
        orderStatus: widget.estadoPago,
      );

      if (paymentResult['status'] == 'success') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PaymentSuccessScreen(
              orderNumber: paymentResult['ticket_number'] ?? 'N/A',
              total: widget.amount,
            ),
          ),
        );
      } else {
        throw Exception(
            paymentResult['message'] ?? 'Error en el proceso de pago');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
      print('[ERROR] Error en el proceso de pago: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago con Tarjeta'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sección de datos de tarjeta
              const Text(
                'Datos de la Tarjeta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Número de tarjeta
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Número de Tarjeta',
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [_cardNumberFormatter],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el número de tarjeta';
                  }
                  if (value.replaceAll(' ', '').length != 16) {
                    return 'Número inválido (16 dígitos)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Fila para fecha expiración y CVV
              Row(
                children: [
                  // Mes de expiración
                  Expanded(
                    child: TextFormField(
                      controller: _expiryMonthController,
                      decoration: const InputDecoration(
                        labelText: 'MM',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [_expiryMonthFormatter],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'MM';
                        }
                        final month = int.tryParse(value);
                        if (month == null || month < 1 || month > 12) {
                          return 'Inválido';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Año de expiración
                  Expanded(
                    child: TextFormField(
                      controller: _expiryYearController,
                      decoration: const InputDecoration(
                        labelText: 'AAAA',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [_expiryYearFormatter],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'AAAA';
                        }
                        if (value.length != 4) {
                          return '4 dígitos';
                        }
                        final year = int.tryParse(value);
                        if (year == null || year < DateTime.now().year) {
                          return 'Inválido';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  // CVV
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [_cvvFormatter],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        if (value.length != 3) {
                          return '3 dígitos';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Sección de datos personales
              const Text(
                'Datos Personales',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese su email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Nombre
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombres',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese sus nombres';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Apellido
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Apellidos',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese sus apellidos';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // Resumen de compra
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumen de Compra',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Lista de productos
                      ...widget.productos.map((producto) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${producto['quantity']} x ${producto['name']}'),
                                Text(
                                    'S/. ${(producto['price'] * producto['quantity']).toStringAsFixed(2)}'),
                              ],
                            ),
                          )),

                      const Divider(),

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'S/. ${widget.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Mensaje de error
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Botón de pago
              ElevatedButton(
                onPressed: _isLoading ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blueAccent,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'REALIZAR PAGO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  final String orderNumber;
  final double total;

  const PaymentSuccessScreen({
    Key? key,
    required this.orderNumber,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago Exitoso'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Pago realizado con éxito!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Número de orden: $orderNumber',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Monto: S/. ${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Navegar al inicio o a donde corresponda
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
