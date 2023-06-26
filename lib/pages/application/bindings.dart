import 'package:get/get.dart';
import 'package:getxtkchat/pages/contact/index.dart';
import 'package:getxtkchat/pages/message/index.dart';
import 'package:getxtkchat/pages/profile/index.dart';
import '/pages/application/index.dart';

class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationController>(() => ApplicationController());
    Get.lazyPut<ContactController>(() => ContactController());
    Get.lazyPut<MessageController>(() => MessageController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
