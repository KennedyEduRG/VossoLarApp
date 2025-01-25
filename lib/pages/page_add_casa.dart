import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:vossolarapp/controllers/controller_home.dart';
import 'package:vossolarapp/controllers/controller_user.dart';
import 'package:vossolarapp/model/casa.dart';
import 'package:vossolarapp/model/usuario.dart';

class PageAddCasa extends StatefulWidget {
  @override
  _PageAddCasaState createState() => _PageAddCasaState();
}

class _PageAddCasaState extends State<PageAddCasa> {
  final ControllerHome controllerHome = Get.find<ControllerHome>();
  final ControllerUser controllerUser = Get.find<ControllerUser>();

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController quartosController = TextEditingController();
  final TextEditingController banheirosController = TextEditingController();
  final TextEditingController precoController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _fotoUrl;
  String garagemValue = 'Sim';

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImageToFirebase();
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_imageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('uploads/${DateTime.now().toString()}');
      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
      setState(() {
        _fotoUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Adicionar Casa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile != null
                    ? Image.file(_imageFile!, height: 150)
                    : Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text("Toque para adicionar foto"),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(tituloController, "Título"),
              const SizedBox(height: 20),
              _buildTextField(bairroController, "Bairro"),
              const SizedBox(height: 20),
              _buildTextField(ruaController, "Rua"),
              const SizedBox(height: 20),
              _buildTextField(numeroController, "Número", isNumeric: true),
              const SizedBox(height: 20),
              _buildTextField(cidadeController, "Cidade"),
              const SizedBox(height: 20),
              _buildTextField(quartosController, "Quartos", isNumeric: true),
              const SizedBox(height: 20),
              _buildTextField(banheirosController, "Banheiros", isNumeric: true),
              const SizedBox(height: 20),
              _buildDropdownButton(),
              const SizedBox(height: 20),
              _buildTextField(precoController, "Preço", isNumeric: true),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _addCasa(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Adicionar',
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

  Widget _buildTextField(TextEditingController controller, String labelText, {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget _buildDropdownButton() {
    return DropdownButtonFormField<String>(
      value: garagemValue,
      decoration: InputDecoration(
        labelText: "Possui Garagem",
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      items: ['Sim', 'Não'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          garagemValue = newValue!;
        });
      },
    );
  }

  void _addCasa(BuildContext context) {
    final String titulo = tituloController.text;
    final String bairro = bairroController.text;
    final String rua = ruaController.text;
    final String cidade = cidadeController.text;
    final int numero = int.tryParse(numeroController.text) ?? 0;
    final int quartos = int.tryParse(quartosController.text) ?? 0;
    final int banheiros = int.tryParse(banheirosController.text) ?? 0;
    final bool possuiGaragem = garagemValue == 'Sim';
    final double preco = double.tryParse(precoController.text) ?? 0.0;

    if (_imageFile != null &&
        titulo.isNotEmpty &&
        bairro.isNotEmpty &&
        rua.isNotEmpty &&
        cidade.isNotEmpty &&
        numero != 0 &&
        quartos != 0 &&
        banheiros != 0 &&
        preco != 0.0) {
      final Usuario? dono = controllerUser.usuarioLogado!;
      controllerHome.uploadImageAndAddCasa(
        _imageFile!,
        titulo,
        bairro,
        rua,
        cidade,
        numero,
        quartos,
        banheiros,
        possuiGaragem,
        preco,
        dono!,
      );
      Get.back();
    } else {
      Get.snackbar(
        "Erro",
        "Todos os campos são obrigatórios.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
