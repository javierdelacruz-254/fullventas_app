import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fullventas_app/ui/widget_carrito/payment_service.dart';
import 'package:fullventas_app/ui/widget_carrito/culqi_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/services_data_api.dart';
import 'package:fullventas_app/domain/models/fullventas_data/services_data.dart';
import 'package:fullventas_app/ui/widget_carrito/ticket_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String distrito;
  final List<Map<String, dynamic>> productos;
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
  final _paymentService = PaymentService();

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
    _initializeData();
  }

  void _initializeData() {
    // Precargar datos del usuario
    _emailController.text = widget.userData['email'] ?? '';
    _firstNameController.text = widget.userData['first_name'] ?? '';
    _lastNameController.text = widget.userData['last_name'] ?? '';

    // Precargar llave pública de Culqi
    _culqiService.fetchPublicKey(widget.userData['id']);
  }

  Future<void> _processPayment() async {
    print('[DEBUG] Iniciando _processPayment()');
    print('[DEBUG] Validando formulario...');
    if (!_formKey.currentState!.validate()) {
      print('[DEBUG ERROR] Validación de formulario fallida');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      print('[DEBUG] Monto total recibido: ${widget.amount}');
      if (widget.amount <= 0) {
        print('[DEBUG ERROR] Monto inválido: ${widget.amount}');
        throw Exception('El monto total debe ser mayor a cero');
      }

      final amountInCents = (widget.amount * 100).round();
      print('[DEBUG] Monto convertido a centavos: $amountInCents');

      // 1. Crear token
      print('[DEBUG] Creando token con Culqi...');
      print('[DEBUG] Datos para token:');
      print(
          '- Número tarjeta: ${_cardNumberController.text.replaceAll(' ', '')}');
      print('- CVV: ${_cvvController.text}');
      print('- Mes exp: ${_expiryMonthController.text}');
      print('- Año exp: ${_expiryYearController.text}');
      print('- Email: ${_emailController.text}');
      print('- Nombre: ${_firstNameController.text}');
      print('- Apellido: ${_lastNameController.text}');

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

      print('[DEBUG] Token recibido: ${token ?? 'NULL'}');
      if (token == null) {
        print('[DEBUG ERROR] No se pudo generar el token de pago');
        throw Exception('No se pudo generar el token de pago');
      }

      // 2. Preparar productos
      print('[DEBUG] Preparando productos para insert order...');
      print('[DEBUG] Número de productos: ${widget.productos.length}');

      double totalGeneral = 0.0;

      final orderedProducts = widget.productos.map((producto) {
        final servicio = producto['producto'] as ServicesData;
        final cantidad = producto['cantidad'] ?? 1;
        final categoria =
            producto['tipo_categoria'] ?? servicio.category?.toString() ?? '0';
        final previousPrice =
            producto['previousPrice'] ?? servicio.previousPrice ?? 0.0;

        final totalProducto = previousPrice * cantidad;
        totalGeneral += totalProducto;

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
          'tipo_categoria': categoria,
          'previousPrice': previousPrice,
          'name': servicio.title ?? 'Producto sin nombre',
          'product_size_id': null, // Campo requerido por la API
        };
      }).toList();

      print('[DEBUG] Total general: $totalGeneral');

      // 3. Calcular comisión
      final comisionCulqi = (widget.amount * 0.037);
      print('[DEBUG] Comisión calculada: $comisionCulqi');

      // 4. Preparar datos para el pago
      print('[DEBUG] Preparando datos para processPayment...');
      print('[DEBUG] Datos del usuario:');
      print('- User ID: ${widget.userData['id']}');
      print('- Client ID: 1}');
      print('[DEBUG] Datos de la sucursal:');
      print('- Sucursal: ${widget.sucursal}');
      print('[DEBUG] Datos del pedido:');
      print('- Distrito: ${widget.distrito}');
      print('- Método de pago: ${widget.metodoPago}');
      print('- Estado de pago: ${widget.estadoPago}');

      // 5. Procesar pago
      print('[DEBUG] Iniciando proceso de pago...');
      final paymentResult = await _paymentService.processPayment(
        amount: amountInCents.toDouble(),
        currency: 'PEN',
        email: _emailController.text,
        sourceId: token,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        orderUserId: widget.userData['id'].toString(),
        orderClientId: 1,
        orderNoti: 1,
        orderSucursal: widget.sucursal,
        orderDistrito: widget.distrito,
        orderCostoEnvio: 0,
        orderComisionCulqi: comisionCulqi,
        orderedProducts: orderedProducts,
        orderMethod: _obtenerNombreMetodoPago(widget.metodoPago),
        orderStatus: widget.estadoPago,
      );

      print('[DEBUG] Respuesta completa de processPayment:');
      print(paymentResult.toString());

      if (paymentResult['status'] == 'success') {
        print('[DEBUG] Pago exitoso!');
        print('- Número de ticket: ${paymentResult['ticket_number']}');
        print('- ID de orden: ${paymentResult['order_id']}');
        print('- Mensaje: ${paymentResult['message']}');

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TicketScreen(
              distrito: widget.distrito,
              total: widget.amount,
              userData: widget.userData,
              fechaHora: DateTime.now().toIso8601String(),
              productos: orderedProducts
                  .map((p) => {
                        "id": p['product_id'],
                        "qty": p['ordered_quantity'],
                        "tipo_categoria": p['tipo_categoria'],
                        "previousPrice": p['previousPrice'],
                        "name": p['name'],
                        "product_size_id": p['product_size_id'],
                      })
                  .toList(),
              orderCostoEnvio: 0,
              orderStatus: 'pagado',
              orderID: paymentResult['order_id'],
              orderMethod: _obtenerNombreMetodoPago(widget.metodoPago),
              sucursalTicket: widget.sucursal,
            ),
          ),
        );
      } else {
        print('[DEBUG ERROR] Error en processPayment:');
        print('- Estado: ${paymentResult['status']}');
        print('- Mensaje: ${paymentResult['message']}');
        print('- Error: ${paymentResult['error']}');

        throw Exception(
            paymentResult['message'] ?? 'Error en el proceso de pago');
      }
    } catch (e, stackTrace) {
      print('[DEBUG ERROR] Excepción capturada:');
      print('- Tipo: ${e.runtimeType}');
      print('- Mensaje: $e');
      print('- StackTrace: $stackTrace');

      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      print('[DEBUG] Finalizando proceso de pago...');
      setState(() {
        _isLoading = false;
      });
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
        return "Pagado";
      case 1:
        return "Pendiente";
      default:
        return "Desconocido";
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

                      ...widget.productos.map((producto) {
                        final servicio = producto['producto'] as ServicesData;
                        final cantidad = producto['cantidad'] ?? 0;
                        final previousPrice = producto['previousPrice'] ??
                            servicio.previousPrice ??
                            0.0;
                        final total = previousPrice * cantidad;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$cantidad x ${servicio.title}'),
                              Text('S/. ${total.toStringAsFixed(2)}'),
                            ],
                          ),
                        );
                      }),

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
  final String order_id;
  final double total;

  const PaymentSuccessScreen({
    Key? key,
    required this.order_id,
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
                'Número de orden: $order_id',
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
