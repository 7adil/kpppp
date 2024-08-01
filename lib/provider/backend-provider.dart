import 'package:flutter/foundation.dart';

class BackendProvider extends ChangeNotifier{
  bool _isLoading=false;
  bool get isLoading=>_isLoading;

  void setLoading(bool status){
    _isLoading=status;
    notifyListeners();
  }

}