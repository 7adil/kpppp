import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier{
  bool _isEyeOpen=true;
  bool get isEyeOpen=>_isEyeOpen;
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  void changeEye(){
    _isEyeOpen=!isEyeOpen;
    notifyListeners();
  }
  void clearResources(){
    emailController.clear();
    passwordController.clear();
    _isEyeOpen=true;
    notifyListeners();
  }
}