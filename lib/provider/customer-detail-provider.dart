import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerDetailProvider extends ChangeNotifier{

  DateTime _startDate=DateTime(DateTime.now().year,1,1);
  String _displayStartDate='From';
  DateTime _endDate=DateTime(DateTime.now().year+1,1,1);
  String _displayEndDate='To';


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
}