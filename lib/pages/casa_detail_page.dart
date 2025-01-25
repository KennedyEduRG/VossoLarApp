import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vossolarapp/controllers/controller_chat.dart';
import 'package:vossolarapp/controllers/controller_user.dart';
import 'package:vossolarapp/model/casa.dart';
import 'package:vossolarapp/model/chat.dart';
import 'package:vossolarapp/pages/page_chat.dart';
import 'package:vossolarapp/utils/utils.dart';

class CasaDetailPage extends StatefulWidget {
  final Casa casa;

  CasaDetailPage(this.casa);

  @override
  _CasaDetailPageState createState() => _CasaDetailPageState();
}

class _CasaDetailPageState extends State<CasaDetailPage> {
  final ControllerUser controllerUser = Get.find<ControllerUser>();
  final ControllerChat controllerListChat = Get.find<ControllerChat>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.casa.titulo),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.casa.fotoUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.casa.titulo,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Endereço: ${widget.casa.rua}, ${widget.casa.numero}, ${widget.casa.bairro}, ${widget.casa.cidade}",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Preço: R\$${widget.casa.preco}",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Quartos: ${widget.casa.quartos}, Banheiros: ${widget.casa.banheiros}",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Garagem: ${widget.casa.possuiGaragem ? 'Sim' : 'Não'}",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.casa.latitude ?? 0.0, widget.casa.longitude ?? 0.0),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('casaLocation'),
                      position: LatLng(widget.casa.latitude ?? 0.0, widget.casa.longitude ?? 0.0),
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    print('Map created');
                  },
                  onCameraMove: (CameraPosition position) {
                    print('Camera moved to: ${position.target}');
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.contact_mail_rounded,
                color: Colors.white,
              ),
              onPressed: () async {
                if (controllerUser.usuarioLogado!.email != widget.casa.dono.email) {
                  Chat chat = Chat(controllerUser.usuarioLogado!.nome, widget.casa.dono.nome);
                  await chat.initializeChat(controllerUser.usuarioLogado!.nome, widget.casa.dono.nome);
                  controllerListChat.addChat(chat);
                  Utils.push(context, PageChat());
                  Get.snackbar(
                    "Contato",
                    "Você entrou em contato com o dono da casa.",
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    "Atenção",
                    "Opa, parece que você já é dono desta casa.",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
