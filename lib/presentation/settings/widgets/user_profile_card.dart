import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileCard extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;

  const UserProfileCard({
    super.key,
    required this.userName,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 25,
        child: Icon(Icons.person, size: 30),
      ),
      title: Text(
        userName,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text('entrenador_pokemon'.tr),
      trailing: IconButton(
        icon: const Icon(Icons.logout, color: Colors.red),
        onPressed: onLogout,
        tooltip: 'Cerrar Sesión',
      ),
    );
  }
}
