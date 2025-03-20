import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/descuentos_data_provider.dart';
import 'package:fullventas_app/config/providers/size_data_provider.dart';
import 'package:fullventas_app/config/providers/user_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/descuentos_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/size_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/user_data.dart';
import 'package:fullventas_app/ui/pages/home_page.dart';
import 'package:fullventas_app/ui/widgets_products/video_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailDescuentoPage extends ConsumerStatefulWidget {
  final DescuentosData descuentosData;

  const DetailDescuentoPage({super.key, required this.descuentosData});

  @override
  DetailDescuentoPageState createState() => DetailDescuentoPageState();
}

class DetailDescuentoPageState extends ConsumerState<DetailDescuentoPage> {
  String? selectedImage;
  int cantidad = 1;

  void incrementar() {
    setState(() {
      cantidad++;
    });
  }

  void decrementar() {
    if (cantidad > 1) {
      setState(() {
        cantidad--;
      });
    }
  }

  Widget _builMetodosPago(String image) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Image.network(
          image,
          fit: BoxFit.contain,
          width: 100,
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLiked = false;

    final UserDetailUseCase = ref.watch(userDataProvider);
    final DescuentosDetailUseCase = ref.watch(descuentosDataProvider);
    final SizeDetailUseCase = ref.watch(sizeDataProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // Regresa a la pantalla anterior
          },
        ),
        title: SizedBox(), // No se muestra texto en el AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Lógica para navegar al carrito, si es necesario
            },
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  utf8.decode(latin1
                      .encode(widget.descuentosData.title ?? 'Sin título')),
                  style: TextStyle(
                    fontSize: 18, // Título grande
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              // Imagen del servicio grande
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.descuentosData.image_name ?? '',
                    fit: BoxFit.contain,
                    height: 400, // Hacer la imagen más grande
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 100),
                  ),
                ),
              ),
              SizedBox(height: 16),
              //FutureBuilder<List<Descuento>>(future: future, builder: builder)
              SizedBox(
                height: 200,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 8,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final metodosPagos = [
                      'https://1000marcas.net/wp-content/uploads/2019/12/VISA-emblema-1.jpg',
                      'https://cdn.prod.website-files.com/64199d190fc7afa82666d89c/648b606d4a139591f6b3440c_mastercard-1.png',
                      'https://webshoptiger.com/wp-content/uploads/2023/09/American-Express-Color.png',
                      'https://stakeholders.com.pe/wp-content/uploads/2020/03/dc-1024x576.jpg',
                      'https://1000marcas.net/wp-content/uploads/2021/06/Apple-Pay-Logo-1.png',
                      'https://ingenieriacivilyconstruccion.com/wp-content/uploads/2024/12/Yape-v2.png',
                      'https://marketing-peru.beglobal.biz/wp-content/uploads/2024/09/logo-plin-fondo-transparente.png',
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Google_Pay_Logo.svg/640px-Google_Pay_Logo.svg.png',
                    ];
                    final metodosPago = metodosPagos[index];

                    return _builMetodosPago(metodosPago);
                  },
                ),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Precio actual
                  Text(
                    'S/. ${widget.descuentosData.precio_descuento!.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  // Precio anterior si existe
                  if (widget.descuentosData.precio_normal != null)
                    Text(
                      'Antes S/. ${widget.descuentosData.precio_normal!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8),
              // Descuento en un container con texto adicional
              if (widget.descuentosData.porcentaje != null)
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '-${(double.tryParse(widget.descuentosData.porcentaje?.toString() ?? '0') ?? 0).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    // Texto adicional "DESCUENTO"
                    Text(
                      'DESCUENTO',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Precio actual
                  Text(
                    'Stock: ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.descuentosData.qty.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              FutureBuilder<List<SizeData>>(
                future: SizeDetailUseCase.getSizeById(
                    widget.descuentosData.id_product_size!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('No se encontraron detalles de tamaño'));
                  } else {
                    final sizeData = snapshot.data!.first;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tamaño: ",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${sizeData.size_name}",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(
                height: 16,
              ),
              if (widget.descuentosData.tipo_producto == 1) ...[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Cantidad:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue, // Color de fondo azul
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          onPressed: () {
                            decrementar();
                          },
                          icon: Icon(Icons.remove, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$cantidad', // Puedes cambiarlo dinámicamente
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: IconButton(
                          onPressed: () {
                            incrementar();
                          },
                          icon: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Descripcion:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  widget.descuentosData.descripcion?.isNotEmpty == true
                      ? widget.descuentosData.descripcion!
                      : 'Sin descripcion',
                ),
              ),
              SizedBox(
                height: 16,
              ),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Me gusta',
                        style: TextStyle(fontSize: 15),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.redAccent : Colors.redAccent,
                          size: 30,
                        ),
                      ),
                    ],
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Marca: ',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.descuentosData.marca?.isNotEmpty == true
                        ? widget.descuentosData.marca!
                        : 'Sin marca',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              ProductVideoWidget(
                  videoLinkOne: widget.descuentosData.link_video_one,
                  videoLinkTwo: widget.descuentosData.link_video_two),
              SizedBox(
                height: 16,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.white),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        'Añadir al carrito',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final UserDetailUseCase = ref.watch(userDataProvider);

          return FutureBuilder<List<UserData>>(
              future: UserDetailUseCase.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return FloatingActionButton(
                    onPressed: null,
                    backgroundColor: Colors.grey,
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return FloatingActionButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Número de teléfono no disponible')),
                      );
                    },
                    backgroundColor: Colors.red,
                    child: Icon(Icons.error, color: Colors.white),
                  );
                } else {
                  final phoneNumber = snapshot.data!.first.mobile;
                  return FloatingActionButton(
                    onPressed: () async {
                      final producto =
                          widget.descuentosData.title ?? 'este producto';
                      final message =
                          'Hola, necesito más información sobre el prodcuto $producto';
                      final url = Uri.parse(
                          'https://wa.me/$phoneNumber?text=$message.');

                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No se pudo abrir WhatsApp')),
                        );
                      }
                    },
                    backgroundColor: Colors.green,
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/512px-WhatsApp.svg.png',
                      width: 40,
                    ),
                  );
                }
              });
        },
      ),
    );
  }
}
