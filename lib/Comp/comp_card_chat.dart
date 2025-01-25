import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vossolarapp/controllers/controller_chat.dart';
import 'package:vossolarapp/controllers/controller_user.dart';
import 'package:vossolarapp/model/chat.dart';
import 'package:vossolarapp/pages/page_chat.dart';
import 'package:vossolarapp/pages/page_privade_chat.dart';
import 'package:vossolarapp/utils/utils.dart';

class CompCardChat extends StatelessWidget {
  final Chat chat;

  CompCardChat(this.chat);

  @override
  Widget build(BuildContext context) {
    final ControllerUser controllerUser = Get.find<ControllerUser>();
    final ControllerChat controllerChat = Get.find<ControllerChat>();
    final usuarioLogado = controllerUser.usuarioLogado;

    final outroParticipante = usuarioLogado?.nome == chat.user1?.nome
        ? chat.user2
        : chat.user1;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(outroParticipante!.fotoUrl.toString()),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  outroParticipante.nome.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  chat.ultimaMensagem.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.orange),
            onPressed: () {
              controllerChat.actualChat(this.chat);
              Utils.push(context, PagePrivadeChat());
            },
          ),
        ],
      ),
    );
  }
}
