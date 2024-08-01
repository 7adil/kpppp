

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaintenanceReportProvider extends ChangeNotifier{
  DateTime _startDate=DateTime(DateTime.now().year,1,1);
  String _displayStartDate='From';
  DateTime _endDate=DateTime(DateTime.now().year+1,1,1);
  String _displayEndDate='To';

  String _customerId='';
  String get customerId=>_customerId;


  dynamic get startDate=>_startDate;
  String get displayStartDate=>_displayStartDate;
  dynamic get endDate=>_endDate;
  String get displayEndDate=>_displayEndDate;
  changeStartingDate(DateTime? date){
    _startDate=date!;
    _displayStartDate=DateFormat('EE, d MMM').format(date!);
    notifyListeners();
  }
  changeEndingTimeDate(DateTime? date){
    if (date != null) {
      // Set end date to the end of the selected day
      _endDate = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
      _displayEndDate = DateFormat('EE, d MMM').format(_endDate);
      notifyListeners();
    }
    notifyListeners();
  }
  void changeCustomerId(String customerId){
    _customerId=customerId;
    notifyListeners();
  }
  void clearFilter(){
    _customerId='';
    _startDate=DateTime(DateTime.now().year-6,1,1);
    _endDate=DateTime(DateTime.now().year+45,1,1);
    _displayStartDate='From';
    _displayEndDate='To';
    notifyListeners();
  }
}