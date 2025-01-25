import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vossolarapp/Comp/comp_card_casa.dart';
import 'package:vossolarapp/controllers/controller_home.dart';
import 'package:vossolarapp/controllers/controller_user.dart';
import 'package:vossolarapp/pages/page_add_casa.dart';
import 'package:vossolarapp/pages/page_chat.dart';
import 'package:vossolarapp/pages/page_fav.dart';
import 'package:vossolarapp/pages/page_user.dart';
import 'package:vossolarapp/pages/page_userNL.dart';
import 'package:vossolarapp/utils/utils.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final ControllerHome controllerHouse = Get.find<ControllerHome>();
  final ControllerUser controllerListUser = Get.find<ControllerUser>();
  bool _isFilterExpanded = false;

  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _precoMinController = TextEditingController();
  final TextEditingController _precoMaxController = TextEditingController();
  final TextEditingController _quartosController = TextEditingController();
  final TextEditingController _banheirosController = TextEditingController();
  bool _possuiGaragem = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBottomNavIcon(Icons.home, () {}),
              const SizedBox(width: 22),
              _buildBottomNavIcon(Icons.star, () {
                Utils.push(context, PageFav());
              }),
              const SizedBox(width: 22),
              _buildBottomNavIcon(Icons.chat_rounded, () {
                Utils.push(context, PageChat());
              }),
              const SizedBox(width: 22),
              _buildBottomNavIcon(Icons.supervised_user_circle_sharp, () {
                if (controllerListUser.itsLoged()) {
                  Utils.push(context, PageUserLog());
                } else {
                  Utils.push(context, PageUser());
                }
              }),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          _body(context),
          _buildFilterButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controllerListUser.itsLoged()) {
            Utils.push(context, PageAddCasa());
          } else {
            Get.snackbar(
              'Login necessário',
              'Por favor, faça login para adicionar uma casa.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBottomNavIcon(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 31),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildFilterButton() {
    return Positioned(
      bottom: 16,
      left: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.blue,
            child: Icon(
              _isFilterExpanded ? Icons.close : Icons.filter_list,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isFilterExpanded = !_isFilterExpanded;
              });
            },
          ),
          if (_isFilterExpanded) _buildFilterPanel(),
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterTextField('Próximo a', _localController),

          Row(
            children: [
              Expanded(
                child: _buildFilterTextField('Bairro', _bairroController),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterTextField('Rua', _ruaController),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: _buildFilterTextField('Cidade', _cidadeController),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterTextField('Preço mínimo', _precoMinController, isNumeric: true),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: _buildFilterTextField('Preço máximo', _precoMaxController, isNumeric: true),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterTextField('Quartos', _quartosController, isNumeric: true),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: _buildFilterTextField('Banheiros', _banheirosController, isNumeric: true),
              ),
              const SizedBox(width: 8),
              Checkbox(
                value: _possuiGaragem,
                onChanged: (value) {
                  setState(() {
                    _possuiGaragem = value ?? false;
                  });
                },
              ),
              const Text('Possui Garagem'),
            ],
          ),

          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  controllerHouse.aplicarFiltros(
                    bairro: _bairroController.text,
                    rua: _ruaController.text,
                    cidade: _cidadeController.text,
                    precoMin: _precoMinController.text.isNotEmpty
                        ? double.tryParse(_precoMinController.text)
                        : null,
                    precoMax: _precoMaxController.text.isNotEmpty
                        ? double.tryParse(_precoMaxController.text)
                        : null,
                    quartos: _quartosController.text.isNotEmpty
                        ? int.tryParse(_quartosController.text)
                        : null,
                    banheiros: _banheirosController.text.isNotEmpty
                        ? int.tryParse(_banheirosController.text)
                        : null,
                    possuiGaragem: _possuiGaragem,
                  );
                  setState(() {});
                },
                child: Text('Aplicar Filtros'),
              ),
              const SizedBox(width: 2),
              ElevatedButton(
                onPressed: () {
                  controllerHouse.limparFiltros();
                  setState(() {});
                },
                child: Text('Limpar Filtros'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTextField(String label, TextEditingController controller, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Obx(() {
      if (controllerHouse.listContHome.isEmpty) {
        return Center(child: Text('Nenhuma casa disponível'));
      } else {
        return ListView.builder(
          itemCount: controllerHouse.listContHome.length,
          itemBuilder: (context, index) {
            final casa = controllerHouse.listContHome[index];
            return CompCardCasa(casa);
          },
        );
      }
    });
  }
}
