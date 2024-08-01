
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/auth-user-model.dart';
import 'package:untitled/provider/backend-provider.dart';
import 'package:untitled/provider/login-provider.dart';
import 'package:untitled/utils/global-functions.dart';

class AuthServices {
  static final _auth = FirebaseAuth.instance;
  static Future<void> signUpShop(AuthModel model, BuildContext context) async {
    _auth
        .createUserWithEmailAndPassword(
        email: model.email,
        password: model.password)
        .then((v) {

    }).onError((error, stackTrace) {
      customPrint("Error white creating user");
    });
  }

  static Future<void> loginUser(
      AuthModel loginUserModel, BuildContext context) async {
    final loadingProvider =
    Provider.of<BackendProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    try {
      loadingProvider.setLoading(true);
      _auth
          .signInWithEmailAndPassword(
          email: loginUserModel.email, password: loginUserModel.password)
          .then((value) async {

        if (context.mounted) {
          // Navigator.pushNamedAndRemoveUntil(
          //     context, RoutesNames.mainDashboardView, (route) => false);
          loginProvider.clearResources();
        }
      }).then((value) {
        loadingProvider.setLoading(false);
        customPrint("login successful");
      }).onError((error, stackTrace) {
        loadingProvider.setLoading(false);
        customPrint(error.toString());
      });
    } catch (e) {
      loadingProvider.setLoading(false);
      customPrint(e.toString());
    }
  }

  // static Future<void> changePassword(
  //     ChangePasswordModel changePasswordModel, BuildContext context) async {
  //   final backendProvider =
  //   Provider.of<BackendProvider>(context, listen: false);
  //   final changePasswordProvider =
  //   Provider.of<ChangePasswordProvider>(context, listen: false);
  //   User? user = _auth.currentUser;
  //   AuthCredential credential = EmailAuthProvider.credential(
  //       email: changePasswordModel.email,
  //       password: changePasswordModel.oldPassword);
  //
  //   ///verify current password
  //   try {
  //     backendProvider.setLoading(true);
  //     await user?.reauthenticateWithCredential(credential).then((value) async {
  //       customPrint("Password verified");
  //
  //       try {
  //         await user
  //             .updatePassword(changePasswordModel.newPassword)
  //             .then((value) {
  //           changePasswordProvider.clearResources();
  //           customPrint("Password Updated");
  //         }).onError((error, stackTrace) {
  //           backendProvider.setLoading(false);
  //           customPrint(error.toString());
  //         });
  //       } catch (e) {
  //         backendProvider.setLoading(false);
  //
  //         customPrint(e.toString());
  //       }
  //       backendProvider.setLoading(false);
  //
  //     }).onError((error, stackTrace) {
  //       backendProvider.setLoading(false);
  //
  //       customPrint(error.toString());
  //     });
  //   } catch (e) {
  //     backendProvider.setLoading(false);
  //
  //     customPrint(e.toString());
  //   }
  // }


}