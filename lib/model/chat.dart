import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vossolarapp/controllers/controller_user.dart';
import 'package:vossolarapp/model/usuario.dart';
import 'package:firebase_database/firebase_database.dart';

class Chat extends GetxController {
  Usuario? _usuario1;

  set usuario1(Usuario value) {
    _usuario1 = value;
  }

  Usuario? _usuario2;
  List<String> _mensagensUsuario1 = [];
  List<String> _mensagensUsuario2 = [];
  List<String> _todasMensagens = [];
  String? _ultimaMensagem;

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final ControllerUser _controllerUser = Get.find<ControllerUser>();

  Usuario? get user1 => _usuario1;
  Usuario? get user2 => _usuario2;
  List<String> get mensagensUsuario1 => _mensagensUsuario1;
  List<String> get mensagensUsuario2 => _mensagensUsuario2;
  List<String> get todasMensagens => _todasMensagens;
  String? get ultimaMensagem => _ultimaMensagem;

  set ultimaMensagem(String? value) => _ultimaMensagem = value;

  Chat(String username1, String username2) {
    initializeChat(username1, username2);
  }

  Future<void> initializeChat(String username1, String username2) async {
    _usuario1 = await _getUsuarioByName(username1);
    _usuario2 = await _getUsuarioByName(username2);
    String chatId = generateChatId();

    final chatRef = _databaseRef.child('chats/$chatId');
    final snapshot = await chatRef.get();

    if (!snapshot.exists) {
      await chatRef.set({
        'mensagensUsuario1': [],
        'mensagensUsuario2': [],
        'todasMensagens': [],
        'ultimaMensagem': '',
        'usuario1': _usuario1?.nome,
        'usuario2': _usuario2?.nome,
      });
    }

    chatRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        var data = event.snapshot.value as Map<dynamic, dynamic>;
        _mensagensUsuario1 = List<String>.from(data['mensagensUsuario1'] ?? []);
        _mensagensUsuario2 = List<String>.from(data['mensagensUsuario2'] ?? []);
        _todasMensagens = List<String>.from(data['todasMensagens'] ?? []);
        _ultimaMensagem = data['ultimaMensagem'] ?? '';

        update();
      }
    });
  }


  Future<void> adicionarMensagem(String mensagem, Usuario usuarioLogado) async {
    if (usuarioLogado.nome == _usuario1?.nome) {
      _mensagensUsuario1.add(mensagem);
    } else if (usuarioLogado.nome == _usuario2?.nome) {
      _mensagensUsuario2.add(mensagem);
    }
    _todasMensagens.add(mensagem);
    _ultimaMensagem = mensagem;

    await _databaseRef.child('chats/${generateChatId()}').set({
      'usuario1': _usuario1!.nome,
      'usuario2': _usuario2!.nome,
      'mensagensUsuario1': _mensagensUsuario1,
      'mensagensUsuario2': _mensagensUsuario2,
      'todasMensagens': _todasMensagens,
      'ultimaMensagem': _ultimaMensagem,
    });
  }

  Future<Usuario?> _getUsuarioByName(String username) async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('nome', isEqualTo: username)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      var userMap = userSnapshot.docs.first.data();
      return Usuario(
        userMap['fotoUrl'],
        userMap['nome'],
        userMap['email'],
        userMap['senha'],
      );
    }
    return null;
  }
  String generateChatId() {
    return "${_usuario1!.nome}-${_usuario2!.nome}";
  }

  set mensagensUsuario1(List<String> value) => _mensagensUsuario1 = value;
  set mensagensUsuario2(List<String> value) => _mensagensUsuario2 = value;
  set todasMensagens(List<String> value) => _todasMensagens = value;

  set usuario2(Usuario value) {
    _usuario2 = value;
  }
}
