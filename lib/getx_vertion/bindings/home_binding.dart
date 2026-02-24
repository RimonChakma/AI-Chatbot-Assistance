import 'package:get/get.dart';

import '../controllers/chat_controller.dart';
import '../service/open_router_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OpenRouterService());
    Get.lazyPut(() => ChatController(Get.find()));
  }
}