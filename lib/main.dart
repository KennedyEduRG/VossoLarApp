import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vossolarapp/controllers/controller_chat.dart';
import 'package:vossolarapp/controllers/controller_fav.dart';
import 'package:vossolarapp/controllers/controller_home.dart';
import 'package:vossolarapp/controllers/controller_user.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print("Firebase inicializado com sucesso.");
  } catch (e) {
    print("Erro ao inicializar Firebase: $e");
  }
  runApp(const Main());
  Get.put(ControllerUser());
  Get.put(ControllerFav());
  Get.put(ControllerHome());
  Get.put(ControllerChat());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      defaultTransition: Transition.noTransition,
      initialRoute: AppRoutes.pgHome,
      getPages: AppPages().pages,
    );
  }
}
