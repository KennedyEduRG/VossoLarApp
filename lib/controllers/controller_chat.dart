import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vossolarapp/controllers/controller_home.dart';
import 'package:vossolarapp/controllers/controller_user.dart';
import 'package:vossolarapp/model/chat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vossolarapp/model/usuario.dart';

class ControllerChat extends GetxController {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final List<Chat> _listContChat = [];
  late Chat _chat;
  final ControllerUser _cntrlUser =  Get.find<ControllerUser>();

  List<Chat> get listContChat => _listContChat;

  Chat get chat => _chat;

  void actualChat(Chat chat) {
    _chat = chat;
  }

  Future<void> addChat(Chat chat) async {
    final chatId = chat.generateChatId();
    _listContChat.add(chat);

    await _databaseRef.child('chats/$chatId').set({
      'usuario1': chat.user1?.nome,
      'usuario2': chat.user2?.nome,
      'mensagensUsuario1': chat.mensagensUsuario1,
      'mensagensUsuario2': chat.mensagensUsuario2,
      'todasMensagens': chat.todasMensagens,
      'ultimaMensagem': chat.ultimaMensagem,
    });
    update();
  }

  Future<void> removeChat(Chat chat) async {
    final chatId = chat.generateChatId();
    _listContChat.remove(chat);
    await _databaseRef.child('chats/$chatId').remove();
    update();
  }

  Stream<List<String>> streamMensagens(String chatId) {
    return _databaseRef
        .child('chats/$chatId/todasMensagens')
        .onValue
        .map((event) {
      final List<String> mensagens = [];
      final data = event.snapshot.value as List?;
      if (data != null) {
        mensagens.addAll(data.cast<String>());
      }
      return mensagens;
    });
  }

  Future<void> loadChats(String userEmail) async {
    _listContChat.clear();
    try {
      final snapshot = await _databaseRef.child('chats').get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((chatId, chatData) async {
          var chatMap = Map<String, dynamic>.from(chatData);

          final usuario1 = chatMap['usuario1'] as String?;
          final usuario2 = chatMap['usuario2'] as String?;

          if (usuario1 == null || usuario2 == null) {
            debugPrint("Usuário 1 ou 2 está nulo no chat $chatId");
            return;          }

          Chat chat = Chat(
            usuario1,
            usuario2,
          );
          chat.mensagensUsuario1 =
          List<String>.from(chatMap['mensagensUsuario1'] ?? []);
          chat.mensagensUsuario2 =
          List<String>.from(chatMap['mensagensUsuario2'] ?? []);
          chat.todasMensagens =
          List<String>.from(chatMap['todasMensagens'] ?? []);
          chat.ultimaMensagem = chatMap['ultimaMensagem'] ?? '';
          chat.usuario1 = (await _cntrlUser.getUsuarioByName(chatMap['usuario1']) ?? null)!;
          chat.usuario2 = (await _cntrlUser.getUsuarioByName(chatMap['usuario2']) ?? null)!;

          if (chat.user1!.email == userEmail || chat.user2!.email == userEmail) {
            _listContChat.add(chat);
            debugPrint(
                "Chat adicionado para o usuário: $userEmail no chat $chatId");
            update();
          } else {
            debugPrint("Chat ignorado: $chatId (usuário não encontrado)");
          }
        });
      } else {
        debugPrint("Nenhum chat encontrado no banco de dados.");
      }
    } catch (e) {
      debugPrint("Erro ao carregar os chats: $e");
    }

    update();
  }
}