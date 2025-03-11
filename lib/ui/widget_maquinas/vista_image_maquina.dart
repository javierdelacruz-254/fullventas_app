import 'package:flutter/material.dart';
import 'package:fullventas_app/domain/models/fullventas_data/maquinas_data.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class VistaImageMaquina extends StatelessWidget {
  final MaquinasData maquina;

  const VistaImageMaquina({super.key, required this.maquina});

  @override
  Widget build(BuildContext context) {
    void abrirImagen(String url, int index) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VistaImagen(
            imagenes: [
              if (maquina.foto1 != null) maquina.foto1!,
              if (maquina.foto2 != null) maquina.foto2!
            ],
            initialIndex: index,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF3391FA),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Text(
            maquina.nombreMaquina!,
            style: TextStyle(color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                maquina.estado!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Descripción:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                maquina.descripcion!,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 40),

              // Mostrar primera imagen si está disponible
              if (maquina.foto1 != null && maquina.foto1!.isNotEmpty)
                GestureDetector(
                  onTap: () => abrirImagen(maquina.foto1!, 0),
                  child: Image.network(
                    maquina.foto1!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Text("No se pudo cargar la imagen");
                    },
                  ),
                ),

              SizedBox(height: 30),

              // Mostrar segunda imagen si está disponible
              if (maquina.foto2 != null && maquina.foto2!.isNotEmpty)
                GestureDetector(
                  onTap: () => abrirImagen(maquina.foto2!, 1),
                  child: Image.network(
                    maquina.foto2!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Text("No se pudo cargar la imagen");
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class VistaImagen extends StatelessWidget {
  final List<String> imagenes;
  final int initialIndex;

  const VistaImagen(
      {super.key, required this.imagenes, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: PhotoViewGallery.builder(
        itemCount: imagenes.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imagenes[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(color: Colors.black),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }
}
