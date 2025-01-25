import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static Future? push(BuildContext context, Widget page) {
    return Get.to(
      page,
      transition: Transition.noTransition);
  }
}
