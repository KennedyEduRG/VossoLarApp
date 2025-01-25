import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:vossolarapp/bindings/binding_chat.dart';
import 'package:vossolarapp/bindings/binding_fav.dart';
import 'package:vossolarapp/bindings/binding_private_chat.dart';
import 'package:vossolarapp/pages/page_chat.dart';
import 'package:vossolarapp/pages/page_privade_chat.dart';
import 'package:vossolarapp/pages/page_userNL.dart';
import '../bindings/binding_home.dart';
import '../pages/page_home.dart';
import '../pages/page_fav.dart';

abstract class AppRoutes {
  static const pgHome = '/home';
  static const pgFav = '/fav';
  static const pgChat = '/privadechat';
}

class AppPages {
  final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.pgHome,
      page: () =>  PageHome(),
      binding: BindingHome(),
    ),
    GetPage(
      name: AppRoutes.pgFav,
      page: () => PageFav(),
      binding: BindingFav(),
    ),
    GetPage(
      name: AppRoutes.pgChat,
      page: () => PagePrivadeChat(),
      binding: BindingPrivateChat(),
    ),
  ];
}
