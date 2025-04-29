import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/carrito_provider.dart';
import 'package:fullventas_app/config/providers/estrategia_ventas_image_data_provider.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/config/providers/size_data_provider.dart';
import 'package:fullventas_app/config/providers/user_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/estrategia_ventas_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/estrategia_ventas_image_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/size_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/user_data.dart';
import 'package:fullventas_app/ui/pages/carrito_page.dart';
import 'package:fullventas_app/ui/pages/home_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailEstrategiaVentaPage extends ConsumerStatefulWidget {
  final EstrategiaVentasData estrategiaVentasData;

  const DetailEstrategiaVentaPage(
      {super.key, required this.estrategiaVentasData});
  @override
  DetailEstrategiaVentaPageState createState() =>
      DetailEstrategiaVentaPageState();
}

class DetailEstrategiaVentaPageState
    extends ConsumerState<DetailEstrategiaVentaPage> {
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

  String getTipoPromocion(int? tipopromocion) {
    switch (tipopromocion) {
      case 1:
        return "Oferta";
      case 2:
        return "Paquete";
      case 3:
        return "Cortesia";
      case 5:
        return "2 x 1 - Promocion Producto";
      default:
        return "Sin promocion";
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLiked = false;
    String? videoUrl = widget.estrategiaVentasData.link_video_one;
    String? videoId =
        videoUrl != null ? YoutubePlayer.convertUrlToId(videoUrl) : null;
    Color hexToColor(String hex) {
      hex = hex.replaceAll("#", "");
      if (hex.length == 6) {
        hex = "FF$hex";
      }
      return Color(int.parse("0x$hex"));
    }

    final UserDetailUseCase = ref.watch(userDataProvider);
    final EstrategiaVentasImageDetailUseCase =
        ref.watch(estrategiaVentasImageDataProvider);
    final SizeDetailUseCase = ref.watch(sizeDataProvider);
    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";

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
        backgroundColor: hexToColor(colorHex),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 440,
                height: 200,
                child: Image.asset(
                  'assets/img/img_pesas.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              // Nombre del servicio en la parte superior
              Center(
                child: Text(
                  utf8.decode(latin1.encode(
                      widget.estrategiaVentasData.title ?? 'Sin título')),
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
                    widget.estrategiaVentasData.image_name ?? '',
                    fit: BoxFit.contain,
                    height: 400, // Hacer la imagen más grande
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 100),
                  ),
                ),
              ),
              SizedBox(height: 16),
              FutureBuilder<List<EstrategiaVentasImageData>>(
                future: EstrategiaVentasImageDetailUseCase
                    .getEstrategiaVentasImageById(
                        widget.estrategiaVentasData.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('No se encontró información'));
                  } else {
                    final imagesEstrategiaVentas = snapshot.data!;

                    if (selectedImage == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          selectedImage =
                              imagesEstrategiaVentas.first.image_name;
                        });
                      });
                    }
                    return imagesEstrategiaVentas.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: imagesEstrategiaVentas
                                .take(4)
                                .map((imageEstrategia) {
                              bool isSelected =
                                  selectedImage == imageEstrategia.image_name;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImage = imageEstrategia.image_name;
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected
                                          ? hexToColor(colorHex)
                                          : Colors.transparent,
                                      width: 3, // Grosor del borde
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageEstrategia.image_name!,
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
              Text(
                "Tipo promocion: ${getTipoPromocion(widget.estrategiaVentasData.tipo_promocion)}",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 18),
              // Precio y precio anterior en una fila
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Precio actual
                  Text(
                    'S/. ${widget.estrategiaVentasData.precio_normal!.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                    widget.estrategiaVentasData.qty.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              FutureBuilder<List<SizeData>>(
                future: SizeDetailUseCase.getSizeById(
                    widget.estrategiaVentasData.id_product_size!),
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
                height: 10,
              ),
              if (widget.estrategiaVentasData.tipo_producto == 1) ...[
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
                    color: hexToColor(colorHex), // Color de fondo azul
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
                          '$cantidad',
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
                  widget.estrategiaVentasData.descripcion?.isNotEmpty == true
                      ? widget.estrategiaVentasData.descripcion!
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
                    widget.estrategiaVentasData.marca?.isNotEmpty == true
                        ? widget.estrategiaVentasData.marca!
                        : 'Sin marca',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
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
                    ref.read(carritoProvider.notifier).addCarrito(
                        widget.estrategiaVentasData,
                        widget.estrategiaVentasData.tipo_producto == 1
                            ? cantidad
                            : 1);
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.scale,
                      title: 'Plan añadido',
                      desc:
                          'La oferta ha sido agregado al carrito correctamente.',
                      btnOkOnPress: () {},
                    ).show();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: hexToColor(colorHex),
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
              SizedBox(
                height: 16,
              ),
              SizedBox(
                width: 339,
                height: 180,
                child: Image.asset(
                  'assets/img/img_pesas.jpg',
                  fit: BoxFit.cover,
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
                          widget.estrategiaVentasData.title ?? 'este producto';
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
