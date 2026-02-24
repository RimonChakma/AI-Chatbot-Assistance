import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OpenRouterService());
    Get.lazyPut(() => ChatController(Get.find()));
  }
}