import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:flutter/material.dart';

class GymScreen extends ConsumerWidget {
  const GymScreen({super.key});

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenDetailUseCase = ref.watch(screenDataProvider);
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

    return screenDetailUseCase.when(
      data: (data) {
        if (data.isEmpty) {
          return Center(child: Text('No se encontró información'));
        }

        final screen = data[0];
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                screen.image_logo!,
                width: 150,
                height: 150,
                fit: BoxFit.contain,
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
              SizedBox(height: 16),
              Text(
                screen.nombre!,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: hexToColor(colorTextoSecond)),
              ),
            ],
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
