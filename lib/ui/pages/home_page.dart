import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/anuncios_data_provider.dart';
import 'package:fullventas_app/config/providers/carrito_provider.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/config/providers/user_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/anuncios_data.dart';
import 'package:fullventas_app/ui/pages/carrito_page.dart';
import 'package:fullventas_app/ui/pages/login_page.dart';
import 'package:fullventas_app/ui/pages_drawer/pase_libre_cliente.dart';
import 'package:fullventas_app/ui/pages_drawer/perfil.dart';
import 'package:fullventas_app/ui/pages_drawer/rutinas_cliente.dart';
import 'package:fullventas_app/ui/widgets/carrusel_producto.dart';
import 'package:fullventas_app/ui/widgets/categories.dart';
import 'package:fullventas_app/ui/widgets/logo.dart';
import 'package:fullventas_app/ui/widgets/videos_detacados.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends ConsumerWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({super.key});

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  IconData? obtenerIconoRedSocial(String url) {
    if (url.contains("facebook")) return FontAwesomeIcons.facebook;
    if (url.contains("instagram")) return FontAwesomeIcons.instagram;
    if (url.contains("twitter")) return FontAwesomeIcons.twitter;
    if (url.contains("tiktok")) return FontAwesomeIcons.tiktok;
    return FontAwesomeIcons.link;
  }

  Future<void> executeUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo lanzar $url';
    }
  }

  String obtenerNombreRedSocial(String red) {
    if (red.contains("facebook")) return 'Facebook';
    if (red.contains("instagram")) return 'Instagram';
    if (red.contains("twitter")) return 'Twitter';
    if (red.contains("tiktok")) return 'Tiktok';
    return 'Sin red';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isGoogleUser = ref.watch(userProvider.notifier).isGoogleUser;
    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";

    final String colorTexto = screenData.isNotEmpty
        ? screenData.first.color_texto ?? "#FFFFFF"
        : "#FFFFFF";
    final String colorTextoSecond = screenData.isNotEmpty
        ? screenData.first.color_text_sec ?? "#FFFFFF"
        : "#FFFFFF";

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: hexToColor(colorHex),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
            ],
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: "Buscar...",
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
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
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: hexToColor(colorHex),
              ),
              accountName: Text(
                user?.nombres ?? 'Sin nombre',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: hexToColor(colorTexto)),
              ),
              accountEmail: Text(
                user?.email ?? 'example@gmail.com',
                style: TextStyle(color: hexToColor(colorTexto)),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: user!.image_name != null
                    ? NetworkImage(user.image_name!)
                    : null,
                child: user.image_name == null
                    ? Icon(Icons.person, size: 50, color: hexToColor(colorHex))
                    : null,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.star_border,
                      color: hexToColor(colorHex),
                    ),
                    title: Text(
                      'Favoritos',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: hexToColor(colorTextoSecond)),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: hexToColor(colorHex),
                    ),
                    title: Text(
                      'Perfil',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: hexToColor(colorTextoSecond)),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Perfil(cliente: user),
                        ),
                      );
                    },
                  ),
                  if (!isGoogleUser) ...[
                    ListTile(
                      leading: Icon(
                        Icons.card_membership,
                        color: hexToColor(colorHex),
                      ),
                      title: Text(
                        'Pases Inscritos',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: hexToColor(colorTextoSecond)),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaseLibreCliente(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.fitness_center,
                        color: hexToColor(colorHex),
                      ),
                      title: Text(
                        'Rutina',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: hexToColor(colorTextoSecond)),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RutinasCliente(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.fastfood,
                        color: hexToColor(colorHex),
                      ),
                      title: Text(
                        'Dieta',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: hexToColor(colorTextoSecond)),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.bar_chart,
                        color: hexToColor(colorHex),
                      ),
                      title: Text(
                        'Progreso Fisico',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: hexToColor(colorTextoSecond)),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.photo_library,
                        color: Color(0xFF3391FA),
                      ),
                      title: Text(
                        'Comunidad Fotos',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: hexToColor(colorTextoSecond)),
                      ),
                      onTap: () {},
                    ),
                  ],
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: hexToColor(colorHex),
              ),
              title: Text(
                'Cerrar Sesión',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: hexToColor(colorHex)),
              ),
              onTap: () {
                ref.read(userProvider.notifier).logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
      //-------------------
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            //-------------------
            // GYM SCREEN - LOGO
            //-------------------
            Container(
              height: 252.0,
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: hexToColor(secondColor),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 5, spreadRadius: 1),
                ],
              ),
              child: Column(children: [GymScreen()]),
            ),

            //-------------------
            //MENSAJE DE BIENVENIDA
            //-------------------
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: hexToColor(colorHex),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Hola ${user.nombres ?? 'Usuario'}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: hexToColor(colorTextoSecond)),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Es el momento de superar tus limites',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                )),

            //-------------------
            // CARRUSEL
            //-------------------

            ProductCarousel(
              seccion: 'Principal',
            ),

            const SizedBox(
              height: 20,
            ),
            //-------------------
            // CATEGORIAS
            //-------------------

            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: hexToColor(secondColor),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 5, spreadRadius: 1),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Categorías",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: hexToColor(colorHex),
                      ),
                    ),
                  ),
                  CategoriesGrid(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Consumer(
              builder: (context, ref, _) {
                final anuncioProvider = ref.watch(anunciosDataProvider);

                return FutureBuilder<List<AnunciosData>>(
                    future: anuncioProvider.getAnunciosBySeccion('Secundaria'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No hay anuncios disponibles.');
                      }

                      final anuncios = snapshot.data!;

                      if (anuncios.length == 1) {
                        final anuncio = anuncios.first;
                        return SizedBox(
                          width: 440,
                          height: 140,
                          child: Image.network(
                            anuncio.url_imagen!,
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
                        return CarouselSlider(
                          options: CarouselOptions(
                              height: 140.0,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 1.0),
                          items: anuncios.map((anuncio) {
                            return Builder(
                              builder: (BuildContext context) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Para redondear las esquinas
                                  child: Stack(
                                    fit: StackFit
                                        .expand, // Asegura que la imagen y el cuadro ocupen
                                    children: [
                                      // Imagen principal
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                anuncio.url_imagen!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      // Cuadro negro transparente con el título
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            final redes =
                                                anuncio.url_redes ?? [];

                                            if (redes.length == 1) {
                                              executeUrl(redes.first);
                                            } else if (redes.length > 1) {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: false,
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              20)),
                                                ),
                                                builder: (context) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          'Elige una red para visitar',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: hexToColor(
                                                                  colorTextoSecond)),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        GridView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              redes.length,
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 4,
                                                            mainAxisSpacing: 20,
                                                            crossAxisSpacing:
                                                                20,
                                                            childAspectRatio:
                                                                0.8,
                                                          ),
                                                          itemBuilder:
                                                              (context, index) {
                                                            final red =
                                                                redes[index];
                                                            final icono =
                                                                obtenerIconoRedSocial(
                                                                    red);
                                                            final nombreRed =
                                                                obtenerNombreRedSocial(
                                                                    red);
                                                            return GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                executeUrl(red);
                                                              },
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  CircleAvatar(
                                                                    radius: 26,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .black12,
                                                                    child:
                                                                        FaIcon(
                                                                      icono,
                                                                      size: 28,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          6),
                                                                  Text(
                                                                    nombreRed,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: hexToColor(
                                                                            colorTextoSecond)),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
                                              color: Colors.black.withOpacity(
                                                  0.5), // Transparencia
                                              width: double
                                                  .infinity, // Para que ocupe todo el ancho
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Siguenos en:',
                                                    style: TextStyle(
                                                      color: hexToColor(
                                                          colorTexto),
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  if ((anuncio.url_redes ?? [])
                                                      .isNotEmpty)
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          FaIcon(
                                                            obtenerIconoRedSocial(
                                                                anuncio
                                                                    .url_redes!
                                                                    .first),
                                                            color: Colors.white,
                                                            size: 18,
                                                          ),
                                                          if (anuncio.url_redes!
                                                                  .length >
                                                              1) ...[
                                                            SizedBox(
                                                                width: 8.0),
                                                            Text(
                                                              'ver más',
                                                              style: TextStyle(
                                                                color: hexToColor(
                                                                    colorTexto),
                                                                fontSize: 14.0,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ]
                                                        ])
                                                  else
                                                    Text(
                                                      'Sin redes sociales disponibles',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        );
                      }
                    });
              },
            ),

            const SizedBox(height: 20),
            //-------------------
            // VIDEOS DESTACADOS
            //-------------------
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: hexToColor(secondColor),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 5, spreadRadius: 1),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Videos Destacados",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: hexToColor(colorHex)),
                    ),
                  ),
                  VideoWidget(),
                ],
              ),
            ),
            //-------------------
            // REDES SOCIALES
            //-------------------
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: hexToColor(colorHex),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(2),
                    child: Text(
                      "Redes Sociales",
                      style: TextStyle(
                          fontSize: 20,
                          color: hexToColor(colorTexto),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/img/facebookIcon.png',
                          width: 50,
                          height: 50,
                        ),
                        Image.asset(
                          'assets/img/internetIcon.png',
                          width: 50,
                          height: 50,
                        ),
                        Image.asset(
                          'assets/img/instagramIcon.png',
                          width: 50,
                          height: 50,
                        ),
                      ]),
                  const SizedBox(height: 10),
                  Text(
                    'Principal: Sucursal los Olivos',
                    style: TextStyle(
                      color: hexToColor(colorTexto),
                    ),
                  ),
                  Text(
                    'Celular: 074326302',
                    style: TextStyle(
                      color: hexToColor(colorTexto),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
