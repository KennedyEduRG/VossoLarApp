import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vossolarapp/Comp/comp_card_casa.dart';
import 'package:vossolarapp/controllers/controller_fav.dart';
import 'package:vossolarapp/controllers/controller_user.dart';
import 'package:vossolarapp/model/casa.dart';
import 'package:vossolarapp/pages/page_chat.dart';
import 'package:vossolarapp/pages/page_home.dart';
import 'package:vossolarapp/pages/page_user.dart';
import 'package:vossolarapp/pages/page_userNL.dart';
import 'package:vossolarapp/utils/utils.dart';

class PageFav extends StatelessWidget {
  final ControllerFav controllerListFav = Get.find<ControllerFav>();
  final ControllerUser controllerListUser = Get.find<ControllerUser>();

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
                  borderRadius:
                      BorderRadius.circular(12),
                ),
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
                    border: Border.all(color: Colors.orange, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.orangeAccent),
                child: IconButton(
                  icon: const Icon(Icons.star, color: Colors.white, size: 31),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 22),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.chat_rounded, color: Colors.white, size: 31),
                  onPressed: () {
                    Utils.push(context, PageChat());
                  },
                ),
              ),
              const SizedBox(width: 22),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.supervised_user_circle_sharp,
                      color: Colors.white, size: 31),
                  onPressed: () {
                    if(controllerListUser.itsLoged()){
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
    controllerListFav.loadFavFromFirestore();
    List<Casa> listContFav = controllerListFav.listContFav;

    return GetBuilder<ControllerFav>(builder: (context) {
      return ListView.builder(
          itemExtent: 300,
          itemCount: listContFav.length,
          itemBuilder: (context, index) {
            return _itemView(listContFav, index, context);
          });
    });
  }

  _itemView(List<dynamic> listCasa, int index, context) {
    Casa casa = listCasa[index];
    return GestureDetector(child: CompCardCasa(casa));
  }
}
