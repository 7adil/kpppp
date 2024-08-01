import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Utils{
  //static String googleApiKey='AIzaSyB-p7r6-G6ZT_6K1AudkhV1_TGqa7dSDKM';
  //static String googleApiKey='AIzaSyDkWf04MQ9Qi7lqEfFVHN2g1WvvaYOCsjM';
  static String googleApiKey='AIzaSyC3uz4DKrTxvsVrntGesQSQTuLB1uBak8U';

  static toastMessage(String message,Color color){
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: color,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT
    );
  }

  static void showSnackBar(BuildContext context, String message,Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: color,

      ),
    );
  }

  static double webConstraint=1100;
  static double mobConstraint=600;
  static double tabConstraint=650;
}