import 'package:get/get.dart';
import 'package:getxtkchat/pages/welcome/index.dart';

//Using for clean dependency injection
class WelcomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(() => WelcomeController());
  }
}
