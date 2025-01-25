import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vossolarapp/controllers/controller_chat.dart';
import 'package:vossolarapp/controllers/controller_user.dart';
import 'package:vossolarapp/model/chat.dart';

class PagePrivadeChat extends StatelessWidget {
  late final Chat chat;
  final TextEditingController mensagemController = TextEditingController();
  final ControllerChat controllerChat = Get.find<ControllerChat>();

  PagePrivadeChat() {
    chat = controllerChat.chat;
  }

  @override
  Widget build(BuildContext context) {
    final ControllerUser controllerUser = Get.find<ControllerUser>();
    final usuarioLogado = controllerUser.usuarioLogado;
    final chatId = chat.generateChatId();

    controllerChat.streamMensagens(chatId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Chat"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: StreamBuilder<List<String>>(
                  stream: controllerChat.streamMensagens(chatId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final mensagens = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: mensagens.length,
                      itemBuilder: (context, index) {
                        final mensagem = mensagens[index];
                        final isMensagemDoUsuarioLogado = (chat.user1?.email == usuarioLogado?.email)
                            ? chat.mensagensUsuario1.contains(mensagem)
                            : chat.mensagensUsuario2.contains(mensagem);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Align(
                            alignment: isMensagemDoUsuarioLogado
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isMensagemDoUsuarioLogado
                                    ? Colors.yellow[100]
                                    : Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: Text(mensagem),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: mensagemController,
                    decoration: InputDecoration(
                      hintText: "Digite sua mensagem...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final novaMensagem = mensagemController.text.trim();
                    if (novaMensagem.isNotEmpty) {
                      chat.adicionarMensagem(novaMensagem, usuarioLogado!);
                      chat.ultimaMensagem = novaMensagem;
                      mensagemController.clear();
                      controllerChat.update();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
