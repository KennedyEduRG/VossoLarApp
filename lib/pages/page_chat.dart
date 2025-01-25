import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vossolarapp/controllers/controller_chat.dart';
import 'package:vossolarapp/controllers/controller_user.dart';
import 'package:vossolarapp/model/chat.dart';
import 'package:vossolarapp/Comp/comp_card_chat.dart';
import 'package:vossolarapp/pages/page_fav.dart';
import 'package:vossolarapp/pages/page_home.dart';
import 'package:vossolarapp/pages/page_user.dart';
import 'package:vossolarapp/pages/page_userNL.dart';
import 'package:vossolarapp/utils/utils.dart';

class PageChat extends StatelessWidget {
  final ControllerChat controllerChat = Get.find<ControllerChat>();
  final ControllerUser controllerUser = Get.find<ControllerUser>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 31),
                  onPressed: () {
                    Utils.push(context, PageHome());
                  },
                ),
              ),
              const SizedBox(width: 22),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.star, color: Colors.white, size: 31),
                  onPressed: () {
                    Utils.push(context, PageFav());
                  },
                ),
              ),
              const SizedBox(width: 22),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.orangeAccent),
                child: IconButton(
                  icon: const Icon(Icons.chat_rounded, color: Colors.white, size: 31),
                  onPressed: () {
                  },
                ),
              ),
              const SizedBox(width: 22),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.supervised_user_circle_sharp,
                      color: Colors.white, size: 31),
                  onPressed: () {
                    if(controllerUser.itsLoged()){
                      Utils.push(context, PageUserLog());
                    } else
                      Utils.push(context, PageUser());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    bool isLoggedIn = controllerUser.usuarioLogado != null;

    if (!isLoggedIn) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Que pena, parece que não está logado ainda...",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return FutureBuilder(
      future: controllerChat.loadChats(controllerUser.usuarioLogado!.email),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erro ao carregar os chats: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else {
          List<Chat> listContChat = controllerChat.listContChat;

          return GetBuilder<ControllerChat>(
            builder: (context) {
              return ListView.builder(
                itemExtent: 100,
                itemCount: listContChat.length,
                itemBuilder: (context, index) {
                  return _itemView(listContChat, index, context);
                },
              );
            },
          );
        }
      },
    );
  }


  _itemView(List<dynamic> listChat, int index, context) {
    Chat chat = listChat[index];

    return GestureDetector(
      child: CompCardChat(chat),
    );
  }
}
