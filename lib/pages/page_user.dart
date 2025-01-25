import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vossolarapp/controllers/controller_user.dart';
import 'package:vossolarapp/pages/page_fav.dart';
import 'package:vossolarapp/pages/page_chat.dart';
import 'package:vossolarapp/pages/page_home.dart';
import 'package:vossolarapp/pages/page_login.dart';
import 'package:vossolarapp/utils/utils.dart';

class PageUserLog extends StatelessWidget {
  final ControllerUser controllerUser = Get.find<ControllerUser>();

  @override
  Widget build(BuildContext context) {
    final usuarioLogado = controllerUser.usuarioLogado;

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 31),
                  onPressed: () {
                    Utils.push(context, PageHome());
                  },
                ),
              ),
              const SizedBox(width: 22),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.star, color: Colors.white, size: 31),
                  onPressed: () {
                    Utils.push(context, PageFav());
                  },
                ),
              ),
              const SizedBox(width: 22),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.chat_rounded, color: Colors.white, size: 31),
                  onPressed: () {
                    Utils.push(context, PageChat());
                  },
                ),
              ),
              const SizedBox(width: 22),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.orange,
                ),
                child: IconButton(
                  icon: const Icon(Icons.supervised_user_circle_sharp,
                      color: Colors.white, size: 31),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(usuarioLogado!.fotoUrl),
              ),
              const SizedBox(height: 20),
              Text(
                usuarioLogado.nome,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                usuarioLogado.email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Sair',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          title: const Text(
            'Deseja realmente sair?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                'Voltar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                controllerUser.logout();
                Get.offAll(PageLogin());
              },
              child: const Text(
                'Sair',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
