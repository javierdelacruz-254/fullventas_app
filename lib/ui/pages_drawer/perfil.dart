import 'package:flutter/material.dart';
import 'package:fullventas_app/domain/models/fullventas_data/cliente_data.dart';

class Perfil extends StatelessWidget {
  final ClienteData cliente;

  const Perfil({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Perfil del Cliente",
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
        backgroundColor: Color(0xFF3391FA),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 180,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 7, 80, 153), Color(0xFF3391FA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Column(
          children: [
            CircleAvatar(
              radius: 65,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    cliente.image_name != null && cliente.image_name!.isNotEmpty
                        ? NetworkImage(cliente.image_name!)
                        : const AssetImage("assets/default_profile.png")
                            as ImageProvider,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${cliente.nombres ?? 'Usuario'} ${cliente.apellidos ?? ''}",
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              cliente.tipo_membresia ?? "Membresía Estándar",
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  /// 📌 Tarjeta con información del usuario
  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          _itemInfo(Icons.code, "Código", cliente.codigo ?? "N/A"),
          _itemInfo(Icons.phone, "Celular",
              cliente.celular?.toString() ?? "Sin número"),
          _itemInfo(Icons.email, "Correo", cliente.email ?? "Sin correo"),
          _itemInfo(
              Icons.home, "Dirección", cliente.direccion ?? "Sin dirección"),
          _itemInfo(
            Icons.check_circle,
            "Estado",
            cliente.status == 1 ? "Activo" : "Inactivo",
            color: cliente.status == 1
                ? Color(0xFF3391FA)
                : Color.fromARGB(255, 166, 182, 201),
          ),
          const Divider(),
          _optionItem(Icons.edit, "Editar Perfil", () {}),
          _optionItem(Icons.lock, "Cambiar Contraseña", () {}),
        ],
      ),
    );
  }

  /// 📌 Elemento de información con ícono
  Widget _itemInfo(IconData icon, String label, String value,
      {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF3391FA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blueAccent),
          ),
          const SizedBox(width: 14),
          Text(
            "$label:",
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF3391FA)),
      title: Text(label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
      onTap: onTap,
    );
  }
}
