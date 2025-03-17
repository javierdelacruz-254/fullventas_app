import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/user_provider.dart';
import 'package:fullventas_app/ui/pages/home_page.dart';
import 'package:fullventas_app/ui/widget_carrito/libro_reclamaciones.dart';
import 'package:fullventas_app/ui/widget_carrito/ticket_screen.dart';

class MetodoPago extends ConsumerStatefulWidget {
  const MetodoPago({super.key});

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

  bool isFormValid() {
    return nombreController.text.isNotEmpty &&
        whatsappController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        direccionController.text.isNotEmpty &&
        referenciaController.text.isNotEmpty &&
        personaRecibeController.text.isNotEmpty;
  }

  void handlePago() {
    if (!isFormValid()) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: "Campos incompletos",
        desc: "Por favor, completa todos los campos antes de continuar.",
        btnOkText: "Aceptar",
        btnOkOnPress: () {},
      ).show();
      return;
    }

    if (selectedPayment == "Pago en el mismo Gimnasio") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TicketScreen(
                distrito: "",
                total: 0.00,
                userData: {},
                fechaHora: "",
                productos: [],
                orderCostoEnvio: 0.0,
                orderStatus: "",
                orderID: 0,
                orderMethod: "",
                sucursalTicket: {})), // Reemplázalo con la pantalla adecuada
      );
    } else if (selectedPayment == "Pago con tarjeta débito, crédito, etc") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LibroReclamaciones()), // Reemplázalo con la pantalla de tarjeta
      );
    } else if (selectedPayment == "Pago con yape") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LibroReclamaciones()), // Reemplázalo con la pantalla de Yape
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cliente = ref.watch(userProvider);
    final bool isGoogleUser = ref.watch(userProvider.notifier).isGoogleUser;

    nombreController.text = cliente?.nombres ?? "";
    whatsappController.text = cliente?.celular?.toString() ?? "";
    emailController.text = cliente?.email ?? "";
    direccionController.text = cliente?.direccion ?? "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3391FA),
        title: Text(
          "Datos del Cliente",
          style: TextStyle(color: Colors.white),
        ),
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
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              icon: Icon(Icons.home)),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.shopping_cart)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campos de datos del cliente
              buildTextField("Nombre Completo", nombreController, true),
              buildTextField("Whatsapp", whatsappController, !isGoogleUser),
              buildTextField("Email", emailController, true),
              buildTextField("Dirección", direccionController, !isGoogleUser),
              buildTextField("Referencia", referenciaController, false),
              buildTextField("Persona que recibe y/o recoge",
                  personaRecibeController, false),

              SizedBox(height: 10),
              Text("Distrito:   Lima", style: TextStyle(fontSize: 16)),

              SizedBox(height: 20),
              Divider(),
              Center(
                child: Text(
                  "Forma de pago",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: 5, horizontal: 10), // Espaciado
                decoration: BoxDecoration(
                  color: Color(0xFF3391FA), // Fondo azul claro
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
                child: Column(
                  children: [
                    buildRadioButton("Pago en el mismo Gimnasio"),
                    buildRadioButton("Pago con tarjeta débito, crédito, etc"),
                    buildRadioButton("Pago con yape"),
                  ],
                ),
              ),

              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handlePago,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3391FA),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text("Pagar",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LibroReclamaciones(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3391FA),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text("Libro de reclamaciones",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, bool isEnabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        TextField(
          controller: controller,
          enabled: !isEnabled,
          decoration: InputDecoration(
            hintText: label,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget buildRadioButton(String title) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      value: title,
      groupValue: selectedPayment,
      onChanged: (value) {
        setState(() {
          selectedPayment = value!;
        });
      },
      activeColor: Color(0xFFD0E4FF),
    );
  }
}
