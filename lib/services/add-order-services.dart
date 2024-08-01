
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/add-customer-model.dart';
import 'package:untitled/models/add-order-model.dart';
import 'package:untitled/provider/accounts-filter-provider.dart';
import 'package:untitled/provider/customer-filter-provider.dart';
import 'package:untitled/utils/global-functions.dart';

class AddOrderServices{
  // static var auth=FirebaseAuth.instance;
  // static var currentUser=auth.currentUser!.uid;
  static final _orderCollection=FirebaseFirestore.instance.collection('orders');


  static Future<void> addOrder(AddOrderModel model,BuildContext context)async{
    DocumentReference docRef = _orderCollection.doc();

    try{
      _orderCollection.doc(docRef.id).set(model.toMap()).then((value)async{
        updateOrder(docRef.id, {'orderId':docRef.id});

        customPrint("Order added");
      });
    }catch(e){

      customPrint(e.toString());
    }
  }
  static Future<void>deleteOrder(String orderId)async{
    try{
      _orderCollection.doc(orderId).delete().then((value){
        customPrint("Order deleted");
      }).onError((error, stackTrace) {
        customPrint("Error white deleting $error");
      });
    }catch(e){
      customPrint(e.toString());
    }
  }
  static Future<AddOrderModel?>fetchOrderData(String id)async{
    DocumentSnapshot order=await _orderCollection.doc(id).get();
    if(order.exists){
      return AddOrderModel.fromDoc(order);
    }
    return null;
  }
  static Stream<AddOrderModel?> fetchOrderStream(String id){
    return _orderCollection.doc(id).snapshots().map((data){
      if(data.exists){
        return AddOrderModel.fromDoc(data);
      }else {
        return null;
      }
    });
  }
  static Future<void> updateOrder(String orderId,Map<String,dynamic>map)async{
    try{
      _orderCollection.doc(orderId).update(map).then((value){
        customPrint('Order updated');
      });
    }catch(e){
      customPrint(e.toString());
    }
  }
  static Stream<List<AddOrderModel>> fetchAllOrderStream() {
    return _orderCollection
    //.where('shopId',isEqualTo: auth.currentUser!.uid)
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return AddOrderModel.fromDoc(doc);
        }
        return null;
      }).where((order) => order != null).cast<AddOrderModel>().toList();
    });
  }
  static Stream<List<AddOrderModel>> fetchAllOrderQueryStream(
      BuildContext context,

      ) {
    var filterProvider=Provider.of<CustomerFilterProvider>(context,listen: false);
    return filterProvider.customerId.isNotEmpty? _orderCollection
    .where('customerId',isEqualTo:filterProvider.customerId)
    .where('orderTime',isGreaterThanOrEqualTo: filterProvider.startDate)
    .where('orderTime',isLessThanOrEqualTo: filterProvider.endDate)
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return AddOrderModel.fromDoc(doc);
        }
        return null;
      }).where((order) => order != null).cast<AddOrderModel>().toList();
    }): _orderCollection
       // .where('customerId',isEqualTo:customerId)
        .where('orderTime',isGreaterThanOrEqualTo: filterProvider.startDate)
        .where('orderTime',isLessThanOrEqualTo: filterProvider.endDate)
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return AddOrderModel.fromDoc(doc);
        }
        return null;
      }).where((order) => order != null).cast<AddOrderModel>().toList();
    });
  }
  static Stream<List<AddOrderModel>> fetchAllOrderQueryStreamForAccounts(
      BuildContext context,
      ) {
    var filterProvider=Provider.of<AccountFilterProvider>(context,listen: false);
    return  _orderCollection
       // .where('customerId',isEqualTo:customerId)
        .where('orderTime',isGreaterThanOrEqualTo: filterProvider.startDate)
        .where('orderTime',isLessThanOrEqualTo: filterProvider.endDate)
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return AddOrderModel.fromDoc(doc);
        }
        return null;
      }).where((order) => order != null).cast<AddOrderModel>().toList();
    });
  }
  static Future<List<AddOrderModel>> fetchAllOrderOnce() async {
    try {
      QuerySnapshot snapshot = await _orderCollection
          .get();
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return AddOrderModel.fromDoc(doc);
        }
        return null;
      }).where((order) => order != null).cast<AddOrderModel>().toList();
    } catch (e) {
      customPrint("Error fetching order: $e");
      return [];
    }
  }static Future<List<AddOrderModel>> fetchAllOrderOnceForAccounts() async {
    try {
      QuerySnapshot snapshot = await _orderCollection
          .get();
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return AddOrderModel.fromDoc(doc);
        }
        return null;
      }).where((order) => order != null).cast<AddOrderModel>().toList();
    } catch (e) {
      customPrint("Error fetching order: $e");
      return [];
    }
  }
  static Stream<double> fetchTotalEarning(BuildContext context) {
    var filterProvider=Provider.of<AccountFilterProvider>(context,listen: false);

    return _orderCollection
        .where('orderTime',isGreaterThanOrEqualTo: filterProvider.startDate)
        .where('orderTime',isLessThanOrEqualTo: filterProvider.endDate)
        .snapshots()
        .map((snapshot) {
      double totalPrice = 0.0;
      for (var doc in snapshot.docs) {
        String getTotalPrice=doc['totalPrice'];
        double parseTotalPrice=double.parse(getTotalPrice);
        totalPrice += parseTotalPrice ;
      }
      return totalPrice;
    });
  }
  static Stream<double> fetchTotalProfit(BuildContext context) {
    var filterProvider=Provider.of<AccountFilterProvider>(context,listen: false);

    return _orderCollection
        .where('orderTime',isGreaterThanOrEqualTo: filterProvider.startDate)
        .where('orderTime',isLessThanOrEqualTo: filterProvider.endDate)
        .snapshots()
        .map((snapshot) {
      double totalPrice = 0.0;
      for (var doc in snapshot.docs) {
        String getTotalPrice=doc['totalProfit'];
        double parseTotalPrice=double.parse(getTotalPrice);
        totalPrice += parseTotalPrice ;
      }
      return totalPrice;
    });
  }
  static Stream<double> fetchTotalPendingOfCustomer(BuildContext context,String id) {
    var filterProvider=Provider.of<CustomerFilterProvider>(context,listen: false);

    return _orderCollection
    .where('customerId',isEqualTo: id)
        .where('orderTime',isGreaterThanOrEqualTo: filterProvider.startDate)
        .where('orderTime',isLessThanOrEqualTo: filterProvider.endDate)
        .snapshots()
        .map((snapshot) {
      double totalPrice = 0.0;
      for (var doc in snapshot.docs) {
        String getTotalPrice=doc['pendingCash'];
        double parseTotalPrice=double.parse(getTotalPrice);
        totalPrice += parseTotalPrice ;
      }
      return totalPrice;
    });
  }
}