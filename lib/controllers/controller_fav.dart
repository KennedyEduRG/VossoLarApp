import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vossolarapp/model/casa.dart';
import 'package:vossolarapp/controllers/controller_user.dart';

class ControllerFav extends GetxController {
  final List<Casa> _listContFav = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ControllerUser _controllerUser = Get.find<ControllerUser>();

  List<Casa> get listContFav => _listContFav;

  @override
  void onInit() {
    super.onInit();
    loadFavFromFirestore();
    print("ControllerListFav: onInit()");
  }

  @override
  void onReady() {
    super.onReady();
    print("ControllerListFav: onReady()");
  }

  @override
  void onClose() {
    super.onClose();
    print("ControllerListFav: onClose()");
  }
    Future<void> loadFavFromFirestore() async {
    await _controllerUser.checkIfUserIsLogged();
    if (_controllerUser.usuarioLogado == null) return;

    var favsSnapshot = await _firestore
        .collection('usuarios')
        .doc(_controllerUser.usuarioLogado?.email)
        .collection('favoritos')
        .get();

    for (var doc in favsSnapshot.docs) {
      var data = doc.data();
      bool casaExiste = _listContFav.any((casa) => casa.titulo == data['titulo']);

      if (!casaExiste) {
        Casa casa = Casa(
          data['fotoUrl'],
          data['titulo'],
          data['bairro'],
          data['rua'],
          data['cidade'],
          data['numero'],
          data['quartos'],
          data['banheiros'],
          data['possuiGaragem'],
          data['preco'],
          _controllerUser.usuarioLogado!,
        );

        casa.favoritar();
        _listContFav.add(casa);
        update();
      }
    }
  }

  void addFav(Casa casa) async {
    if (_controllerUser.usuarioLogado == null) return;

    try {
      var favSnapshot = await _firestore
          .collection('usuarios')
          .doc(_controllerUser.usuarioLogado?.email)
          .collection('favoritos')
          .doc(casa.titulo)
          .get();

      if (favSnapshot.exists) {
        print("Esta casa já está nos favoritos!");
        return;
      }

      _listContFav.add(casa);
      update();
      await _firestore
          .collection('usuarios')
          .doc(_controllerUser.usuarioLogado?.email)
          .collection('favoritos')
          .doc(casa.titulo)
          .set({
        'fotoUrl': casa.fotoUrl,
        'titulo': casa.titulo,
        'bairro': casa.bairro,
        'rua': casa.rua,
        'numero': casa.numero,
        'quartos': casa.quartos,
        'banheiros': casa.banheiros,
        'possuiGaragem': casa.possuiGaragem,
        'preco': casa.preco,
      });

      print("Favorito adicionado com sucesso!");
    } catch (e) {
      print("Erro ao adicionar favorito: $e");
    }
  }

  void removeFav(Casa casa) async {
    if (_controllerUser.usuarioLogado == null) return;

    bool casaExiste = _listContFav.any((fav) => fav.titulo == casa.titulo);
    if (!casaExiste) return;

    _listContFav.removeWhere((fav) => fav.titulo == casa.titulo);
    update();

    try {
      await _firestore
          .collection('usuarios')
          .doc(_controllerUser.usuarioLogado?.email)
          .collection('favoritos')
          .doc(casa.titulo)
          .delete();

      print("Favorito removido com sucesso!");
    } catch (e) {
      print("Erro ao remover favorito: $e");
    }
  }

}
