
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/add-customer-model.dart';
import 'package:untitled/models/add-order-model.dart';
import 'package:untitled/models/maintenance-model.dart';
import 'package:untitled/provider/accounts-filter-provider.dart';
import 'package:untitled/provider/customer-filter-provider.dart';
import 'package:untitled/provider/maintenance-report-provider.dart';
import 'package:untitled/utils/global-functions.dart';

class MaintenanceServices{
  // static var auth=FirebaseAuth.instance;
  // static var currentUser=auth.currentUser!.uid;
  static final _maintenanceCollection=FirebaseFirestore.instance.collection('maintenance');


  static Future<void> addMaintenance(MaintenanceModel model,BuildContext context)async{
    DocumentReference docRef = _maintenanceCollection.doc();

    try{
      _maintenanceCollection.doc(docRef.id).set(model.toMap()).then((value)async{
        updateMaintenance(docRef.id, {'maintenanceId':docRef.id});

        customPrint("Maintenance added");
      });
    }catch(e){

      customPrint(e.toString());
    }
  }
  static Future<void>deleteMaintenance(String maintenanceId)async{
    try{
      _maintenanceCollection.doc(maintenanceId).delete().then((value){
        customPrint("Maintenance deleted");
      }).onError((error, stackTrace) {
        customPrint("Error white deleting $error");
      });
    }catch(e){
      customPrint(e.toString());
    }
  }
  static Future<MaintenanceModel?>fetchMaintenanceData(String id)async{
    DocumentSnapshot order=await _maintenanceCollection.doc(id).get();
    if(order.exists){
      return MaintenanceModel.fromDoc(order);
    }
    return null;
  }
  static Stream<MaintenanceModel?> fetchMaintenanceStream(String id){
    return _maintenanceCollection.doc(id).snapshots().map((data){
      if(data.exists){
        return MaintenanceModel.fromDoc(data);
      }else {
        return null;
      }
    });
  }
  static Future<void> updateMaintenance(String id,Map<String,dynamic>map)async{
    try{
      _maintenanceCollection.doc(id).update(map).then((value){
        customPrint('Maintenance updated');
      });
    }catch(e){
      customPrint(e.toString());
    }
  }
  static Stream<List<MaintenanceModel>> fetchAllMaintenanceStream() {
    return _maintenanceCollection
    //.where('shopId',isEqualTo: auth.currentUser!.uid)
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return MaintenanceModel.fromDoc(doc);
        }
        return null;
      }).where((order) => order != null).cast<MaintenanceModel>().toList();
    });
  }
  static Stream<List<MaintenanceModel>> fetchAllMaintenanceQueryStream(
      BuildContext context,
      ) {
    var filterProvider=Provider.of<AccountFilterProvider>(context,listen: false);
    return  _maintenanceCollection
        .where('dateTime',isGreaterThanOrEqualTo: filterProvider.startDate)
        .where('dateTime',isLessThanOrEqualTo: filterProvider.endDate)
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return MaintenanceModel.fromDoc(doc);
        }
        return null;
      }).where((order) => order != null).cast<MaintenanceModel>().toList();
    });
  }
  static Stream<List<MaintenanceModel>> fetchAllMaintenanceQueryStreamForReport(
      BuildContext context,
      ) {
    var filterProvider=Provider.of<MaintenanceReportProvider>(context,listen: false);
    return  _maintenanceCollection
        .where('dateTime',isGreaterThanOrEqualTo: filterProvider.startDate)
        .where('dateTime',isLessThanOrEqualTo: filterProvider.endDate)
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return MaintenanceModel.fromDoc(doc);
        }
        return null;
      }).where((order) => order != null).cast<MaintenanceModel>().toList();
    });
  }
  static Future<List<MaintenanceModel>> fetchAllMaintenanceOnce() async {
    try {
      QuerySnapshot snapshot = await _maintenanceCollection
      //.where('clinicId',isEqualTo: auth.currentUser!.uid)
          .get();
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return MaintenanceModel.fromDoc(doc);
        }
        return null;
      }).where((order) => order != null).cast<MaintenanceModel>().toList();
    } catch (e) {
      customPrint("Error fetching order: $e");
      return [];
    }
  }
  static Stream<double> fetchTotalMaintenance(BuildContext context) {
    var filterProvider=Provider.of<AccountFilterProvider>(context,listen: false);

    return _maintenanceCollection
        .where('dateTime',isGreaterThanOrEqualTo: filterProvider.startDate)
        .where('dateTime',isLessThanOrEqualTo: filterProvider.endDate)
        .snapshots()
        .map((snapshot) {
      double totalPrice = 0.0;
      for (var doc in snapshot.docs) {
        String getTotalPrice=doc['amount'];
        double parseTotalPrice=double.parse(getTotalPrice);
        totalPrice += parseTotalPrice ;
      }
      return totalPrice;
    });
  }
  static Stream<double> fetchTotalMaintenanceForReport(BuildContext context) {
    var filterProvider=Provider.of<MaintenanceReportProvider>(context,listen: false);

    return _maintenanceCollection
        .where('dateTime',isGreaterThanOrEqualTo: filterProvider.startDate)
        .where('dateTime',isLessThanOrEqualTo: filterProvider.endDate)
        .snapshots()
        .map((snapshot) {
      double totalPrice = 0.0;
      for (var doc in snapshot.docs) {
        String getTotalPrice=doc['amount'];
        double parseTotalPrice=double.parse(getTotalPrice);
        totalPrice += parseTotalPrice ;
      }
      return totalPrice;
    });
  }

}