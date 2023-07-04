import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:getxtkchat/common/routes/routes.dart';
import 'package:getxtkchat/common/services/services.dart';
import 'package:getxtkchat/common/store/store.dart';
import 'package:getxtkchat/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Get.putAsync<StorageService>(() => StorageService().init());
  Get.put<ConfigStore>(ConfigStore());
  Get.put<UserStore>(UserStore());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //We have to wrap material with ScreenUtilInit
    //This wrap action let us to use adaptive sizes in app
    return ScreenUtilInit(
      builder: (context, child) {
        //Must implement widget GetMaterial app
        //For using get package features in app
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TKChat',
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.red,
          ),
          //MaterialApp --> routes
          getPages: AppPages.routes,
          initialRoute: AppPages.INITIAL,
        );
      },
    );
  }
}
