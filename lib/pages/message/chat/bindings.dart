import 'package:get/get.dart';
import 'package:getxtkchat/pages/message/chat/controller.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
