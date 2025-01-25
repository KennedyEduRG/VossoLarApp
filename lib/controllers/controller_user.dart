import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:vossolarapp/controllers/controller_fav.dart';
import 'package:vossolarapp/controllers/controller_home.dart';
import 'package:vossolarapp/model/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ControllerUser extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Usuario? _loged;

  Usuario? get usuarioLogado => _loged;


   Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      DocumentSnapshot userDoc = await _firestore.collection('usuarios').doc(userCredential.user?.uid).get();
      if (userDoc.exists) {
        _loged = Usuario(
          userDoc['fotoUrl'],
          userDoc['nome'],
          userDoc['email'],
          userDoc['senha'],
        );
        update();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Erro de login: $e");
      return false;
    }
  }

  bool itsLoged() {
    return _loged != null;
  }

  Future<bool> register(String username, String email, String password, String fotoUrl) async {
    Usuario? existingUser = await getUsuarioByName(username);
    if (existingUser != null) {
      print("Um usuário com esse nome já existe.");
      return false;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await _firestore.collection('usuarios').doc(userCredential.user?.uid).set({
        'nome': username,
        'email': email,
        'senha': password,
        'fotoUrl': fotoUrl,
      });

      return login(email, password);
    } catch (e) {
      if (e is FirebaseAuthException) {
        print(e);
        if (e.code == 'email-already-in-use') {
          return false;
        }
      }
      return false;
    }
  }
  Future<void> logout() async {
    await _auth.signOut();
    _loged = null;
    update();
  }

  @override
  void onInit() {
    checkIfUserIsLogged();
    super.onInit();
    print("ControllerUser: onInit()");
  }

  @override
  void onReady() {
    super.onReady();
    print("ControllerUser: onReady()");
  }

  @override
  void onClose() async {
    await logout();
    super.onClose();
    print("ControllerUser: onClose()");
  }

  Future<void> checkIfUserIsLogged() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('usuarios').doc(user.uid).get();
      if (userDoc.exists) {
        _loged = Usuario(
          userDoc['fotoUrl'],
          userDoc['nome'],
          userDoc['email'],
          userDoc['senha'],
        );
        update();
      }
    }
  }

  Future<Usuario?> getUsuarioByName(String nome) async {
    final snapshot = await _firestore
        .collection('usuarios')
        .where('nome', isEqualTo: nome)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var userDoc = snapshot.docs.first;
      return Usuario(
        userDoc['fotoUrl'],
        userDoc['nome'],
        userDoc['email'],
        userDoc['senha'],
      );
    }
    return null;
  }
}
