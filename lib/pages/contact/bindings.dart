import 'package:get/get.dart';
import 'package:getxtkchat/pages/contact/index.dart';

class ContactBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactController>(() => ContactController());
  }
}
