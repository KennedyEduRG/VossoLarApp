import 'package:get/instance_manager.dart';
import 'package:vossolarapp/controllers/controller_chat.dart';
import 'package:vossolarapp/controllers/controller_fav.dart';
import 'package:vossolarapp/controllers/controller_home.dart';
import 'package:vossolarapp/controllers/controller_user.dart';



class BindingChat implements Bindings
{
  @override
  void dependencies() {
    Get.put(ControllerChat());
    Get.put(ControllerHome());
    Get.put(ControllerFav());
    Get.put(ControllerUser());
  }
}
