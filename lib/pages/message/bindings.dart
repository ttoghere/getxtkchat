import 'package:get/get.dart';
import 'package:getxtkchat/pages/message/chat/index.dart';
import 'package:getxtkchat/pages/message/controller.dart';

class MessageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(() => MessageController());
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
