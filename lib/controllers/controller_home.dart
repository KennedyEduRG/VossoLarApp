import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vossolarapp/controllers/controller_fav.dart';
import 'package:vossolarapp/model/casa.dart';
import 'package:vossolarapp/model/usuario.dart';
import 'package:geocoding/geocoding.dart';

class ControllerHome extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Casa> _listContHome = <Casa>[].obs;
  RxList<Casa> _originalList = <Casa>[].obs;
  final ControllerFav controllerListFav = Get.find<ControllerFav>();

  RxList<Casa> get listContHome => _listContHome;

  @override
  void onInit() {
    super.onInit();
    fetchHomes();
    print("ControllerListHome: onInit()");
  }

  Future<void> fetchHomes() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('casas').get();
      _listContHome.assignAll(snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Casa(
          data['fotoUrl'],
          data['titulo'],
          data['bairro'],
          data['rua'],
          data['numero'],
          data['cidade'],
          data['quartos'],
          data['banheiros'],
          data['possuiGaragem'],
          data['preco'],
          Usuario(
            data['dono']['fotoUrl'],
            data['dono']['nome'],
            data['dono']['email'],
            data['dono']['senha'],
          ),
          latitude: data['latitude'],
          longitude: data['longitude'],
        );
      }).toList());

        _originalList.assignAll(_listContHome);

    } catch (e) {
      print("Erro ao buscar casas: $e");
    }
  }

  void aplicarFiltros({
    String? bairro,
    String? rua,
    String? cidade,
    double? precoMin,
    double? precoMax,
    int? quartos,
    int? banheiros,
    bool? possuiGaragem,
  }) {
    List<Casa> casasFiltradas = _originalList.where((casa) {
      if (bairro != null && bairro.isNotEmpty && !casa.bairro.toLowerCase().contains(bairro.toLowerCase())) {
        return false;
      }

      if (rua != null && rua.isNotEmpty && !casa.rua.toLowerCase().contains(rua.toLowerCase())) {
        return false;
      }

      if (cidade != null && cidade.isNotEmpty && !casa.cidade.toLowerCase().contains(cidade.toLowerCase())) {
        return false;
      }

      if (precoMin != null && casa.preco < precoMin) {
        return false;
      }

      if (precoMax != null && casa.preco > precoMax) {
        return false;
      }

      if (quartos != null && casa.quartos < quartos) {
        return false;
      }

      if (banheiros != null && casa.banheiros < banheiros) {
        return false;
      }

      if (possuiGaragem != null && possuiGaragem && !casa.possuiGaragem) {
        return false;
      }

      return true;
    }).toList();

    _listContHome.assignAll(casasFiltradas);}

  void limparFiltros() {
    _listContHome.assignAll(_originalList);
  }

  Future<void> addHome(Casa casa) async {
    try {
      String enderecoCompleto = "${casa.rua}, ${casa.numero}, ${casa.bairro}, ${casa.cidade}";

      try {
        List<Location> locations = await locationFromAddress(enderecoCompleto);

        if (locations.isNotEmpty) {
          casa.latitude = locations.first.latitude;
          casa.longitude = locations.first.longitude;
        } else {
          Get.snackbar(
            'Endereço não encontrado',
            'Não foi possível localizar as coordenadas para o endereço fornecido.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }
      } catch (e) {
        Get.snackbar(
          'Erro ao calcular localização',
          'Não foi possível calcular a latitude e longitude para o endereço.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      DocumentReference newCasaRef = await _firestore.collection('casas').add({
        'fotoUrl': casa.fotoUrl,
        'titulo': casa.titulo,
        'bairro': casa.bairro,
        'rua': casa.rua,
        'numero': casa.numero,
        'cidade': casa.cidade,
        'quartos': casa.quartos,
        'banheiros': casa.banheiros,
        'possuiGaragem': casa.possuiGaragem,
        'preco': casa.preco,
        'latitude': casa.latitude,
        'longitude': casa.longitude,
        'dono': {
          'fotoUrl': casa.dono.fotoUrl,
          'nome': casa.dono.nome,
          'email': casa.dono.email,
          'senha': casa.dono.senha,
        },
      });

      _listContHome.add(casa);

    } catch (e) {
      print("Erro ao adicionar casa: $e");
      Get.snackbar(
        'Erro ao adicionar casa',
        'Ocorreu um erro ao tentar adicionar a casa. Tente novamente mais tarde.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> removeHome(Casa casa) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('casas')
          .where('titulo', isEqualTo: casa.titulo)
          .where('dono.email', isEqualTo: casa.dono.email)
          .get();

      for (var doc in snapshot.docs) {
        await _firestore.collection('casas').doc(doc.id).delete();
      }

      _listContHome.remove(casa);
    } catch (e) {
      print("Erro ao remover casa: $e");
    }
  }

  Future<void> uploadImageAndAddCasa(
  File imageFile,
  String titulo,
  String bairro,
  String rua,
  String cidade,
  int numero,
  int quartos,
  int banheiros,
  bool possuiGaragem,
  double preco,
  Usuario dono,
  ) async {
  try {

  final storageRef = FirebaseStorage.instance.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}.jpg');

  final uploadTask = await storageRef.putFile(imageFile);
  final fotoUrl = await uploadTask.ref.getDownloadURL();

  final novaCasa = Casa(
  fotoUrl,
  titulo,
  bairro,
  rua,
  numero,
  cidade,
  quartos,
  banheiros,
  possuiGaragem,
  preco,
  dono,
  );
  addHome(novaCasa);
  Get.snackbar("Sucesso", "Casa adicionada com sucesso!");
  } catch (e) {
  Get.snackbar("Erro", "Falha ao adicionar a casa: $e",
  backgroundColor: Colors.red, colorText: Colors.white);
  print('Erro ao fazer uploadddddddddddddddd: $e');
  }
  }
  @override
  void onReady() {
    print("ControllerListHome: onReady()");
    super.onReady();
  }

  @override
  void onClose() {
    print("ControllerListHome: onClose()");
    super.onClose();
  }
}