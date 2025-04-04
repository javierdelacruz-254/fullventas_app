import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/carrito_provider.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/config/providers/user_provider.dart';
import 'package:fullventas_app/ui/pages/carrito_page.dart';
import 'package:fullventas_app/ui/pages/login_page.dart';
import 'package:fullventas_app/ui/pages_drawer/pase_libre_cliente.dart';
import 'package:fullventas_app/ui/pages_drawer/perfil.dart';
import 'package:fullventas_app/ui/pages_drawer/rutinas_cliente.dart';
import 'package:fullventas_app/ui/widgets/carrusel_producto.dart';
import 'package:fullventas_app/ui/widgets/categories.dart';
import 'package:fullventas_app/ui/widgets/logo.dart';
import 'package:fullventas_app/ui/widgets/videos_detacados.dart';
import 'package:fullventas_app/ui/pages/galeria_comuni.dart';

class HomePage extends ConsumerWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isGoogleUser = ref.watch(userProvider.notifier).isGoogleUser;
    final ScreenDetailUseCase = ref.watch(screenDataProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF3391FA),
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
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 11, 82, 163), Color(0xFF3391FA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                user?.nombres ?? 'Sin nombre',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                user?.email ?? 'example@gmail.com',
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Color(0xFF3391FA)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.star_border,
                      color: Color(0xFF3391FA),
                    ),
                    title: Text(
                      'Favoritos',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: Color(0xFF3391FA),
                    ),
                    title: Text(
                      'Perfil',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Perfil(cliente: user),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("No hay datos de usuario")));
                      }
                    },
                  ),
                  if (!isGoogleUser) ...[
                    ListTile(
                      leading: Icon(
                        Icons.card_membership,
                        color: Color(0xFF3391FA),
                      ),
                      title: Text(
                        'Pases Inscritos',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
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
                        color: Color(0xFF3391FA),
                      ),
                      title: Text(
                        'Rutina',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
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
                        color: Color(0xFF3391FA),
                      ),
                      title: Text(
                        'Dieta',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.bar_chart,
                        color: Color(0xFF3391FA),
                      ),
                      title: Text(
                        'Progreso Fisico',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
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
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GaleriaPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Color(0xFF3391FA),
              ),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3391FA)),
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
                color: Color(0xFFB1D7FE),
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
                          color: Color(0xFF3391FA),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Hola ${user?.nombres ?? 'Usuario'}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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

            ProductCarousel(),

            const SizedBox(
              height: 20,
            ),
            //-------------------
            // CATEGORIAS
            //-------------------

            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.lightBlue[100],
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 5, spreadRadius: 1),
                ],
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Categorías",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3391FA)),
                    ),
                  ),
                  CategoriesGrid(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: 440,
              height: 140,
              child: Image.asset(
                'assets/img/img_pesas.jpg',
                fit: BoxFit.cover,
              ),
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
                color: Colors.lightBlue[100],
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 5, spreadRadius: 1),
                ],
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Videos Destacados",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3391FA)),
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
              decoration: const BoxDecoration(
                color: Color(0xFF3391FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(2),
                    child: Text(
                      "Redes Sociales",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
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
                  const Text(
                    'Principal: Sucursal los Olivos',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Celular: 074326302',
                    style: TextStyle(
                      color: Colors.white,
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
