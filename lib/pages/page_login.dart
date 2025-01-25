import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vossolarapp/controllers/controller_user.dart';
import 'package:vossolarapp/pages/page_home.dart';
import 'package:vossolarapp/pages/page_userNL.dart';

class PageLogin extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final ControllerUser controllerUser = Get.find<ControllerUser>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Ficamos felizes de ver você novamente. Por favor insira seus dados para entrar!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Theme(
              data: ThemeData(
                primaryColor: Colors.orange,
                inputDecorationTheme: InputDecorationTheme(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 1.0),
                  ),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: senhaController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.orange),
                  onPressed: () {
                    Get.to(() => PageUser());
                    },
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String email = emailController.text;
                    final String senha = senhaController.text;

                    if (email.isNotEmpty && senha.isNotEmpty) {
                      bool isAuthenticated = await controllerUser.login(
                        email,
                        senha,
                      );

                      if (isAuthenticated) {
                        Get.offAll(() => PageHome());
                      } else {
                        Get.snackbar(
                          'Erro de Login',
                          'Email ou senha incorretos',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    } else {
                      Get.snackbar(
                        'Erro',
                        'Preencha todos os campos.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
