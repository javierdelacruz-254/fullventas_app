import 'package:flutter/material.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/galeria_service.dart';
import 'package:fullventas_app/domain/models/fullventas_data/galeria.dart';
import 'package:fullventas_app/infraestructure/driven_adapter/api/fullventas_api/subir_photo.dart';
import 'package:fullventas_app/ui/pages/subir_fotos.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galería de Fotos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          secondary: Colors.orangeAccent,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 4,
        ),
      ),
    );
  }
}

class GaleriaPage extends StatefulWidget {
  const GaleriaPage({super.key});

  @override
  _GaleriaPageState createState() => _GaleriaPageState();
}

class _GaleriaPageState extends State<GaleriaPage> {
  late Future<List<Photo>> futurePhotos;

  @override
  void initState() {
    super.initState();
    futurePhotos = PhotoService.fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galería de Fotos')),
      body: FutureBuilder<List<Photo>>(
        future: futurePhotos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay fotos disponibles'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Dos columnas
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final photo = snapshot.data![index];
                return GridTile(
                  child: Image.network(photo.fotoUrl, fit: BoxFit.cover),
                  footer: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      photo.descripcion,
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubirFotosPage()),
          );
        },
        icon: const Icon(Icons.upload),
        label: const Text('Subir Foto'),
      ),
    );
  }
}
