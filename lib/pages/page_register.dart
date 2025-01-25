import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vossolarapp/controllers/controller_user.dart';
import 'package:vossolarapp/pages/page_home.dart';

class PageCadastro extends StatelessWidget {
  final ControllerUser controllerUser = Get.find<ControllerUser>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

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
                'Ficamos felizes de ter você aqui, por favor nos fale mais sobre você para concluirmos o cadastro',
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
                    controller: nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 20),
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
                    Get.back();
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String nome = nomeController.text;
                    final String email = emailController.text;
                    final String senha = senhaController.text;

                    if (nome.isNotEmpty && email.isNotEmpty && senha.isNotEmpty) {
                      bool isRegistered = await controllerUser.register(
                        nome,
                        email,
                        senha,
                        'https://thumbs.dreamstime.com/b/linha-%C3%ADcone-do-preto-avatar-perfil-de-usu%C3%A1rio-121102131.jpg',
                      );

                      if (!isRegistered) {
                        Get.snackbar(
                          'Erro',
                          'Usuário já existe. Tente outro email ou outro nome.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      } else {
                        Get.offAll(() => PageHome());
                      }
                    } else {
                      Get.snackbar(
                        'Erro',
                        'Todos os campos são obrigatórios.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    'Cadastrar',
                    style: TextStyle(
                      color: Colors.black,
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
