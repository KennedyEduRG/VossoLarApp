import 'package:get/instance_manager.dart';
import 'package:vossolarapp/controllers/controller_chat.dart';
import 'package:vossolarapp/controllers/controller_fav.dart';
import 'package:vossolarapp/controllers/controller_user.dart';

import '../controllers/controller_home.dart';


class BindingHome implements Bindings
{
  @override
  void dependencies() {
    Get.put(ControllerHome());
    Get.put(ControllerFav());
    Get.put(ControllerChat());
    Get.put(ControllerUser());
  }
}
