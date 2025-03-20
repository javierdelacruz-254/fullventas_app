import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/categories_data_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/categories_data.dart';
import 'package:fullventas_app/ui/pages/calificacion_page.dart';
import 'package:fullventas_app/ui/pages/estrategia_ventas_page.dart';
import 'package:fullventas_app/ui/pages/home_page.dart';
import 'package:fullventas_app/ui/pages/libro_reclamaciones.dart';
import 'package:fullventas_app/ui/pages/maquinas_page.dart';
import 'package:fullventas_app/ui/pages/pases_libre_page.dart';
import 'package:fullventas_app/ui/pages/planes_page.dart';
import 'package:fullventas_app/ui/pages/producto_page.dart';
import 'package:fullventas_app/ui/pages/publicaciones_page.dart';
import 'package:fullventas_app/ui/pages/service_page.dart';
import 'package:fullventas_app/ui/pages/sucursales_page.dart';
import 'package:fullventas_app/ui/pages/sugerencias_form.dart';
import 'package:fullventas_app/ui/pages/videos_page.dart';

class CategoriesGrid extends ConsumerWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final CategoriesDetailUseCase = ref.watch(categoriesDataProvider);

    return FutureBuilder<List<CategoriesData>>(
      future: CategoriesDetailUseCase.getCategoriesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No se encontró información'));
        } else {
          final categories = snapshot.data!;
          return categories.isEmpty
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Número de columnas
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  padding: EdgeInsets.all(10.0),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final bool isActive = category.status == 1;

                    return GestureDetector(
                      onTap: () {
                        if (isActive) {
                          navigateToCategoryScreen(context, category.title!);
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.bottomSlide,
                            title: 'Módulo inactivo',
                            desc:
                                'Por el momento, esta módulo se encuentra inactivo.',
                            btnOkOnPress: () {},
                            btnOkColor: Colors.orange,
                          ).show();
                        }
                      },
                      child: Opacity(
                        opacity: isActive ? 1.0 : 0.5,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                child: Card(
                              color: Color(0xFF3391FA),
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  category.image_name!,
                                  fit: BoxFit.cover,
                                  color: isActive ? Colors.white : Colors.grey,
                                  colorBlendMode:
                                      isActive ? null : BlendMode.saturation,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 120,
                                      color: Colors.grey.shade300,
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey.shade600,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )),
                            SizedBox(height: 5.0),
                            Text(
                              category.title!, // Mostrar el título
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                  color: isActive
                                      ? Colors.black
                                      : Colors.grey.shade900),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
        }
      },
    );
  }

  void navigateToCategoryScreen(BuildContext context, String categoryName) {
    Widget screen;

    switch (categoryName.toUpperCase()) {
      case 'SERVICIOS':
        screen = ServicePage();
        break;
      case 'PRODUCTOS':
        screen = ProductoPage();
        break;
      case 'OFERTAS Y DESCUENTOS':
        screen = EstrategiaVentasPage();
        break;
      case 'MEMBRESIAS - PLANES':
        screen = PlanesPage();
        break;
      case 'SUCURSALES':
        screen = SucursalesPage();
        break;
      case 'PUBLICACIONES':
        screen = PublicacionesPage();
        break;
      case 'VIDEOS':
        screen = VideosPage();
        break;
      case 'PASES LIBRES':
        screen = PasesLibrePage();
        break;
      case 'SUGERENCIAS':
        screen = SugerenciasForm();
        break;
      case 'CALIFICACIONES':
        screen = CalificacionPage();
        break;
      case 'MAQUINAS':
        screen = MaquinasPage();
        break;
      case 'LIBRO DE RECLAMACIONES':
        screen = LibroReclamaciones();
        break;
      default:
        screen = HomePage();
        break;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
