import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:untitled/models/add-customer-model.dart';
import 'package:untitled/utils/global-functions.dart';

class AddCustomerServices{
  // static var auth=FirebaseAuth.instance;
  // static var currentUser=auth.currentUser!.uid;
  static final _storage=FirebaseStorage.instance;
  static final _customerCollection=FirebaseFirestore.instance.collection('customers');

  static Future<String>uploadCustomerImage(File file,String uid)async{
    final ref=_storage.ref("customers/$uid");
    final uploadTask=ref.putFile(file);
    final snapshot=await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }
  static Future<void> addCustomer(CustomerModel model,BuildContext context)async{
    DocumentReference docRef = _customerCollection.doc();

    try{
      _customerCollection.doc(docRef.id).set(model.toMap()).then((value)async{
        updateCustomer(docRef.id, {'customerId':docRef.id});

          customPrint("Customer added");
      });
    }catch(e){

      customPrint(e.toString());
    }
  }
  static Future<void>deleteCustomer(String customerId)async{
    try{
      _customerCollection.doc(customerId).delete().then((value){
        customPrint("customer deleted");
      }).onError((error, stackTrace) {
        customPrint("Error white deleting $error");
      });
    }catch(e){
      customPrint(e.toString());
    }
  }
  static Future<CustomerModel?>fetchCustomerData(String id)async{
    DocumentSnapshot customerData=await _customerCollection.doc(id).get();
    if(customerData.exists){
      return CustomerModel.fromDoc(customerData);
    }
    return null;
  }
  static Stream<CustomerModel?> fetchCustomerStream(String id){
    return _customerCollection.doc(id).snapshots().map((data){
      if(data.exists){
        return CustomerModel.fromDoc(data);
      }else {
        return null;
      }
    });
  }
  static Future<void> updateCustomer(String customerId,Map<String,dynamic>map)async{
    try{
      _customerCollection.doc(customerId).update(map).then((value){
        customPrint('Customer updated');
      });
    }catch(e){
      customPrint(e.toString());
    }
  }
  static Stream<List<CustomerModel>> fetchAllCustomerStream() {
    return _customerCollection
        //.where('shopId',isEqualTo: auth.currentUser!.uid)
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return CustomerModel.fromDoc(doc);
        }
        return null;
      }).where((customer) => customer != null).cast<CustomerModel>().toList();
    });
  }
  static Future<List<CustomerModel>> fetchAllCustomerOnce() async {
    try {
      QuerySnapshot snapshot = await _customerCollection
          //.where('clinicId',isEqualTo: auth.currentUser!.uid)
          .get();
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return CustomerModel.fromDoc(doc);
        }
        return null;
      }).where((customer) => customer != null).cast<CustomerModel>().toList();
    } catch (e) {
      customPrint("Error fetching customer: $e");
      return [];
    }
  }
 static void updateStock(String stock,String usedStock,String customerId)async{
    int parseGetStock=int.parse(stock);
    DocumentSnapshot getData=await FirebaseFirestore.instance.collection('customers').doc(customerId).get();
    String getStock=getData['newStock'];
    int parseStock=int.parse(getStock);
    int newStock=parseGetStock+parseStock;
    String getOldStock=getData['oldStock'];
    int parseOldStock=int.parse(getOldStock);
    int newOldStock=parseOldStock+parseGetStock;
    int parseUsedStock=int.parse(usedStock);
    int afterAddingUsed=newOldStock-parseUsedStock;
    FirebaseFirestore.instance.collection('customers').doc(customerId).update({
      'newStock':newStock.toString(),
      'oldStock':afterAddingUsed.toString()
    });

  }
}