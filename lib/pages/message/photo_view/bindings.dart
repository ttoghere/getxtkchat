import 'package:get/get.dart';
import 'package:getxtkchat/pages/message/photo_view/controller.dart';

class PhotoImgViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhotoImageViewController>(() => PhotoImageViewController());
  }
}
