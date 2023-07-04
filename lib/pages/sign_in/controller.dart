import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:getxtkchat/common/common.dart';
import 'package:getxtkchat/pages/sign_in/state.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    "openid",
  ],
);

class SignInController extends GetxController {
  final state = SignInState();
  SignInController();
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    return await auth.signInWithProvider(appleProvider);
  }

  //Handle SignIn
  Future<void> handleSignIn(String type) async {
    if (type == "google") {
      try {
        var user = await _googleSignIn.signIn();
        if (user != null) {
          final _gAuthentication = await user.authentication;
          final _credential = GoogleAuthProvider.credential(
              idToken: _gAuthentication.idToken,
              accessToken: _gAuthentication.accessToken);

          await FirebaseAuth.instance.signInWithCredential(_credential);

          String displayName = user.displayName ?? user.email;
          String email = user.email;
          String id = user.id;
          String photoUrl = user.photoUrl ?? "";
          UserLoginResponseEntity userProfile = UserLoginResponseEntity();
          userProfile.email = email;
          userProfile.accessToken = id;
          userProfile.displayName = displayName;
          userProfile.photoUrl = photoUrl;
          userProfile.type = "google";

          UserStore.to.saveProfile(userProfile);
          var userbase = await db
              .collection("users")
              .withConverter(
                fromFirestore: UserData.fromFirestore,
                toFirestore: (UserData userdata, options) =>
                    userdata.toFirestore(),
              )
              .where("id", isEqualTo: id)
              .get();

          if (userbase.docs.isEmpty) {
            final data = UserData(
                id: id,
                name: displayName,
                email: email,
                photourl: photoUrl,
                location: "",
                fcmtoken: "",
                addtime: Timestamp.now());
            await db
                .collection("users")
                .withConverter(
                  fromFirestore: UserData.fromFirestore,
                  toFirestore: (UserData userdata, options) =>
                      userdata.toFirestore(),
                )
                .add(data);
          }
          toastInfo(msg: "login success");
          Get.offAndToNamed(AppRoutes.Application);
        } else {
          // When Google Login Canceled
          toastInfo(msg: "Google Login Canceled");
        }
      } on PlatformException catch (e) {
        // PlatformException Error
        if (e.code == "googleSignInCanceled") {
          // When Google Login Canceled
          toastInfo(msg: "Google Login Canceled");
        } else {
          // Other PlatformException Errors
          toastInfo(msg: "Platform Error: ${e.message}");
        }
      } catch (e) {
        // Other Errors
        toastInfo(msg: "Login Error: $e");
      }
    } else if (type == "apple") {
      try {
        var auth = await signInWithApple();
        if (auth.user != null) {
          String? displayName = "apple_user";
          String? email = "apple@email.com";
          String? id = auth.user?.uid;
          String? photoUrl = auth.user?.photoURL ?? "";
          UserLoginResponseEntity userProfile = UserLoginResponseEntity();
          userProfile.email = email;
          userProfile.accessToken = id;
          userProfile.displayName = displayName;
          userProfile.photoUrl = photoUrl;
          userProfile.type = "apple";

          UserStore.to.saveProfile(userProfile);
          var userbase = await db
              .collection("users")
              .withConverter(
                fromFirestore: UserData.fromFirestore,
                toFirestore: (UserData userdata, options) =>
                    userdata.toFirestore(),
              )
              .where("id", isEqualTo: id)
              .get();

          if (userbase.docs.isEmpty) {
            final data = UserData(
                id: id,
                name: displayName,
                email: email,
                photourl: photoUrl,
                location: "",
                fcmtoken: "",
                addtime: Timestamp.now());
            await db
                .collection("users")
                .withConverter(
                  fromFirestore: UserData.fromFirestore,
                  toFirestore: (UserData userdata, options) =>
                      userdata.toFirestore(),
                )
                .add(data);
          }
          toastInfo(msg: "login success");
          Get.offAndToNamed(AppRoutes.Application);
        }
      } on PlatformException catch (e) {
        // PlatformException Error
        if (e.code == "appleSignInCanceled") {
          // When Google Login Canceled
          toastInfo(msg: "Apple Login Canceled");
        } else {
          // Other PlatformException Errors
          toastInfo(msg: "Platform Error: ${e.message}");
        }
      } catch (e) {
        // Other Errors
        toastInfo(msg: "Login Error: $e");
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        log("User is currently logged out");
      } else {
        log("User is logged in");
      }
    });
  }
}

/*
 var auth = await signInWithApple();
        if(auth.user!=null){



          String? displayName  = "apple_user";
          String? email = "apple@email.com";
          String? id  = auth.user?.uid;
          String? photoUrl = auth.user?.photoURL??"";
          UserLoginResponseEntity userProfile= UserLoginResponseEntity();
          userProfile.email=email;
          userProfile.accessToken = id;
          userProfile.displayName = displayName;
          userProfile.photoUrl = photoUrl;
          userProfile.type = "apple";

          UserStore.to.saveProfile(userProfile);
          var userbase = await db.collection("users").withConverter(
            fromFirestore: UserData.fromFirestore,
            toFirestore: (UserData userdata, options)=>userdata.toFirestore(),
          ).where("id", isEqualTo: id).get();

          if(userbase.docs.isEmpty){
            final data = UserData(
                id:id,
                name: displayName,
                email: email,
                photourl: photoUrl,
                location: "",
                fcmtoken: "",
                addtime: Timestamp.now()

            );
            await db.collection("users").withConverter(
              fromFirestore: UserData.fromFirestore,
              toFirestore: (UserData userdata, options)=>userdata.toFirestore(),
            ).add(data);
          }
          toastInfo(msg: "login success");
          Get.offAndToNamed(AppRoutes.Application);

        }
      }
 */