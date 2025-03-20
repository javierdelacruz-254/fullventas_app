import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/carrito_provider.dart';
import 'package:fullventas_app/config/providers/image_data_provider.dart';
import 'package:fullventas_app/config/providers/user_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/images_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/services_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/user_data.dart';
import 'package:fullventas_app/ui/pages/carrito_page.dart';
import 'package:fullventas_app/ui/pages/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailServicePage extends ConsumerStatefulWidget {
  final ServicesData servicesData;

  const DetailServicePage({super.key, required this.servicesData});

  @override
  DetailServicePageState createState() => DetailServicePageState();
}

class DetailServicePageState extends ConsumerState<DetailServicePage> {
  String? selectedImage;

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
    final ImageDetailUseCase = ref.watch(imageDataProvider);
    bool isLiked = false;
    String? videoUrl = widget.servicesData.linkVideoOne;
    String? videoId =
        videoUrl != null ? YoutubePlayer.convertUrlToId(videoUrl) : null;
    final UserDetailUseCase = ref.watch(userDataProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Regresa a la pantalla anterior
          },
        ),
        title: SizedBox(), // No se muestra texto en el AppBar
        actions: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CarritoPage()),
                  );
                },
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: Consumer(
                  builder: (context, ref, child) {
                    final totalCantidad = ref
                        .watch(carritoProvider)
                        .fold(0, (sum, item) => sum + item['cantidad'] as int);

                    return totalCantidad > 0
                        ? CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 8,
                            child: Text(
                              totalCantidad
                                  .toString(), // Ahora muestra la cantidad real
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          )
                        : SizedBox(); // No mostrar si el carrito está vacío
                  },
                ),
              ),
            ],
          )
        ],
        backgroundColor: Color(0xFF3391FA),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre del servicio en la parte superior
              Center(
                child: Text(
                  utf8.decode(
                      latin1.encode(widget.servicesData.title ?? 'Sin título')),
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
                    selectedImage ?? widget.servicesData.imageName ?? '',
                    fit: BoxFit.contain,
                    height: 400, // Hacer la imagen más grande
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 100),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Miniatura de la imagen debajo de la imagen principal
              FutureBuilder<List<ImageData>>(
                future:
                    ImageDetailUseCase.getImageById(widget.servicesData.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('No se encontró información'));
                  } else {
                    final imagesProducts = snapshot.data!;

                    if (selectedImage == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          selectedImage = imagesProducts.first.image_name;
                        });
                      });
                    }
                    return imagesProducts.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:
                                imagesProducts.take(4).map((imageProduct) {
                              bool isSelected =
                                  selectedImage == imageProduct.image_name;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImage = imageProduct.image_name;
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected
                                          ? Color(0xFF3391FA)
                                          : Colors.transparent,
                                      width: 3, // Grosor del borde
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageProduct.image_name!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey.shade300,
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 40,
                                            color: Colors.grey.shade600,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                  }
                },
              ),
              SizedBox(height: 16),
              // Imagen adicional (Métodos de pago)
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
              // Precio y precio anterior en una fila
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Precio actual
                  Text(
                    'S/. ${widget.servicesData.previousPrice!.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  // Precio anterior si existe
                  if (widget.servicesData.price != null)
                    Text(
                      'Antes S/. ${widget.servicesData.price!.toStringAsFixed(2)}',
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
              if (widget.servicesData.descuento != null)
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
                        '-${(double.tryParse(widget.servicesData.descuento?.toString() ?? '0') ?? 0).toStringAsFixed(0)}%',
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
                  widget.servicesData.description?.isNotEmpty == true
                      ? widget.servicesData.description!
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
              SizedBox(
                height: 16,
              ),
              if (widget.servicesData.horario?.isNotEmpty == true) ...[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Horarios:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.servicesData.horario?.isNotEmpty == true
                        ? widget.servicesData.horario!
                        : 'Sin horario',
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
              if (widget.servicesData.profesor?.isNotEmpty == true) ...[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Instructor:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.servicesData.profesor?.isNotEmpty == true
                        ? widget.servicesData.profesor!
                        : 'Sin profesor',
                  ),
                ),
              ],
              SizedBox(
                height: 16,
              ),
              if (videoId != null) ...[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Video del servicio:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: videoId,
                    flags: YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                ),
              ],
              SizedBox(
                height: 16,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final carrito = ref.read(carritoProvider);
                    final existe = carrito.any((item) =>
                        item['producto'].id == widget.servicesData.id);

                    if (existe) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.scale,
                        title: "Atención",
                        desc: "El servicio ya esta en el carrito",
                        btnOkText: "Aceptar",
                        btnOkOnPress: () {},
                      ).show();
                    } else {
                      ref
                          .read(carritoProvider.notifier)
                          .addCarrito(widget.servicesData, 1);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.scale,
                        title: "¡Éxito!",
                        desc: "Servicio agregado al carrito",
                        btnOkText: "Aceptar",
                        btnOkOnPress: () {},
                      ).show();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3391FA),
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
                          widget.servicesData.title ?? 'este producto';
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
