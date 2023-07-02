import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:getxtkchat/common/common.dart';
import 'package:getxtkchat/common/utils/http.dart';
import 'package:getxtkchat/pages/message/state.dart';

class MessageController extends GetxController {
  final state = MessageState();
  MessageController();
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  var listener;
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  String mapsIos = "AIzaSyAuCD63d5mPwb2hfkXGoddizrHjsuXWBVI";
  String mapsAndroid = "AIzaSyBsjRZiWKjm0MN-7j4I6PYItEZ4vmfN_oE";

  asyncLoadAllData() async {
    var from_message = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: token)
        .get();
    var to_message = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("to_uid", isEqualTo: token)
        .get();

    if (from_message.docs.isNotEmpty) {
      state.msgList.assignAll(from_message.docs);
    }
    if (to_message.docs.isNotEmpty) {
      state.msgList.assignAll(to_message.docs);
    }
  }

// //Maps API for IOS
// //
// //Maps API for android
//   getUserLocation() async {
//     try {
//       final location = await Location().getLocation();
//       log("location 1");
//       String address = "${location.latitude}, ${location.longitude}]";
//       log("address: $address");
//       String url =
//           "https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=$mapsAndroid";
//       var response = await HttpUtil().get(url);
//       log("location 2");

//       MyLocation location_res = MyLocation.fromJson(response);
//       log("location 3");

//       if (location_res.status == "OK") {
//         String? myAddress = location_res.results?.first.formattedAddress;
//         log("location 4");

//         if (myAddress != null) {
//           log("location 5");

//           var user_location =
//               await db.collection("users").where("id", isEqualTo: token).get();
//           if (user_location.docs.isNotEmpty) {
//             log("location 6");

//             var doc_id = user_location.docs.first.id;
//             await db
//                 .collection("users")
//                 .doc(doc_id)
//                 .update({"location": myAddress});
//             log("location 7");
//           }
//         }
//       }
//     } catch (e) {
//       log("Error: $e");
//     }
//   }

  getFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      var user =
          await db.collection("users").where("id", isEqualTo: token).get();
      if (user.docs.isNotEmpty) {
        var doc_id = user.docs.first.id;
        await db.collection("users").doc(doc_id).update({"fcmtoken": fcmToken});
      }
    }
  }

  void onRefresh() {
    asyncLoadAllData().then((_) {
      refreshController.refreshCompleted(resetFooterState: true);
    }).catchError((_) {
      refreshController.refreshFailed();
    });
  }

  void onLoading() {
    asyncLoadAllData().then((_) {
      refreshController.loadComplete();
    }).catchError((_) {
      refreshController.loadFailed();
    });
  }

  @override
  void onReady() {
    // getUserLocation();
    getFcmToken();
    super.onReady();
  }
}
