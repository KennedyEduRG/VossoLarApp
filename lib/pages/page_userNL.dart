import 'package:flutter/material.dart';
import 'package:vossolarapp/pages/page_fav.dart';
import 'package:vossolarapp/pages/page_chat.dart';
import 'package:vossolarapp/pages/page_home.dart';
import 'package:vossolarapp/pages/page_login.dart';
import 'package:vossolarapp/pages/page_register.dart';
import 'package:vossolarapp/utils/utils.dart';

class PageUser extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
                  borderRadius:
                      BorderRadius.circular(12),
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
                  borderRadius:
                      BorderRadius.circular(12),
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
                  borderRadius:
                      BorderRadius.circular(12),
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
                  onPressed: () {
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.supervised_user_circle_sharp,
              color: Colors.orange,
              size: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              "Parece que você não está conectado ainda",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Utils.push(context, PageCadastro());
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orangeAccent,
              ),
              child: const Text("Cadastrar"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Utils.push(context, PageLogin());
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,

              ),
              child: const Text("  Login  "),
            ),
          ],
        ),
      ),
    );
  }
}
