import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vossolarapp/controllers/controller_chat.dart';
import 'package:vossolarapp/controllers/controller_fav.dart';
import 'package:vossolarapp/controllers/controller_home.dart';
import 'package:vossolarapp/controllers/controller_user.dart';
import 'package:vossolarapp/model/chat.dart';
import 'package:vossolarapp/model/casa.dart';
import 'package:vossolarapp/pages/casa_detail_page.dart';
import 'package:vossolarapp/pages/page_chat.dart';
import 'package:vossolarapp/utils/utils.dart';

class CompCardCasa extends StatefulWidget {
  final Casa casa;

  CompCardCasa(this.casa);

  @override
  _CompCardCasaState createState() => _CompCardCasaState();
}

class _CompCardCasaState extends State<CompCardCasa> {
  final ControllerFav controllerListFav = Get.find<ControllerFav>();
  final ControllerHome controllerListHome = Get.find<ControllerHome>();
  final ControllerUser controllerUser = Get.find<ControllerUser>();
  final ControllerChat controllerListChat = Get.find<ControllerChat>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(widget.casa.fotoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      widget.casa.favorito ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 34,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.casa.favoritar();
                        if (widget.casa.favorito) {
                          controllerListFav.addFav(widget.casa);
                        } else {
                          controllerListFav.removeFav(widget.casa);
                          controllerListHome.update();
                        }
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (controllerUser.itsLoged()) {
                        Utils.push(context, CasaDetailPage(widget.casa));
                      } else {
                        Get.snackbar(
                          'Login necessário',
                          'Por favor, faça login para iniciar um chat com o vendedor.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Quero saber mais!',
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white)
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.casa.titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Bairro: ${widget.casa.bairro}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "Cidade: ${widget.casa.cidade}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "Rua: ${widget.casa.rua}, Número: ${widget.casa.numero}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "Quartos: ${widget.casa.quartos}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "Banheiros: ${widget.casa.banheiros}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "Garagem: ${widget.casa.possuiGaragem ? 'Sim' : 'Não'}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Preço: R\$ ${widget.casa.preco.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}