import 'package:get/get.dart';
import 'package:getxtkchat/common/routes/routes.dart';
import 'package:getxtkchat/common/store/store.dart';
import 'package:getxtkchat/pages/welcome/index.dart';


//Holds the methods for WelcomePage
class WelcomeController extends GetxController {
  final state = WelcomeState();
  WelcomeController();
  changePage(int index) async {
    state.index.value = index;
  }

  handleSignIn() async {
    //To extension is using for access to static methods
    await ConfigStore.to.saveAlreadyOpen();
    Get.offAndToNamed(AppRoutes.SIGN_IN);
  }
}
