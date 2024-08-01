
import 'package:cloud_firestore/cloud_firestore.dart';

class AddOrderModel{
  String orderId;
  String customerId;
  String customerName;
  String materialPrice;
  String addMaking;
  String quantity;
  String totalPrice;
  String totalProfit;
  String cash;
  String pendingCash;
  DateTime orderTime;
  List<Map<String,dynamic>> sizeAndQuantity;

  factory AddOrderModel.fromDoc(DocumentSnapshot map) {
    List<Map<String, dynamic>> sizeQuantity = (map['sizeAndQuantity'] as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();

    return AddOrderModel(
      orderId: map['orderId'] as String,
      customerId: map['customerId'] as String,
      customerName: map['customerName'] as String,
      materialPrice: map['materialPrice'] as String,
      addMaking: map['addMaking'] as String,
      quantity: map['quantity'] as String,
      totalPrice: map['totalPrice'] as String,
      totalProfit: map['totalProfit'] as String,
      cash: map['cash'] as String,
      pendingCash: map['pendingCash'] as String,
      orderTime: (map['orderTime'] is Timestamp ? (map['orderTime'] as Timestamp).toDate() : DateTime.now()),
      sizeAndQuantity:sizeQuantity,

    );
  }

//<editor-fold desc="Data Methods">

  AddOrderModel({
    required this.orderId,
    required this.customerId,
    required this.customerName,
    required this.materialPrice,
    required this.addMaking,
    required this.quantity,
    required this.totalPrice,
    required this.totalProfit,
    required this.cash,
    required this.pendingCash,
    required this.orderTime,
    required this.sizeAndQuantity,
  });

//<ed@override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is AddOrderModel &&
              runtimeType == other.runtimeType &&
              orderId == other.orderId &&
              customerId == other.customerId &&
              customerName == other.customerName &&
              materialPrice == other.materialPrice &&
              addMaking == other.addMaking &&
              quantity == other.quantity &&
              totalPrice == other.totalPrice &&
              totalProfit == other.totalProfit &&
              cash == other.cash &&
              pendingCash == other.pendingCash &&
              orderTime == other.orderTime &&
              sizeAndQuantity == other.sizeAndQuantity
          );


  @override
  int get hashCode =>
      orderId.hashCode ^
      customerId.hashCode ^
      customerName.hashCode ^
      materialPrice.hashCode ^
      addMaking.hashCode ^
      quantity.hashCode ^
      totalPrice.hashCode ^
      totalProfit.hashCode ^
      cash.hashCode ^
      pendingCash.hashCode ^
      orderTime.hashCode ^
      sizeAndQuantity.hashCode;


  @override
  String toString() {
    return 'AddOrderModel{' +
        ' orderId: $orderId,' +
        ' customerId: $customerId,' +
        ' customerName: $customerName,' +
        ' materialPrice: $materialPrice,' +
        ' addMaking: $addMaking,' +
        ' quantity: $quantity,' +
        ' totalPrice: $totalPrice,' +
        ' totalProfit: $totalProfit,' +
        ' cash: $cash,' +
        ' pendingCash: $pendingCash,' +
        ' orderTime: $orderTime,' +
        ' sizeAndQuantity: $sizeAndQuantity,' +
        '}';
  }


  AddOrderModel copyWith({
    String? orderId,
    String? customerId,
    String? customerName,
    String? materialPrice,
    String? addMaking,
    String? quantity,
    String? totalPrice,
    String? totalProfit,
    String? cash,
    String? pendingCash,
    DateTime? orderTime,
    List<Map<String, dynamic>>? sizeAndQuantity,
  }) {
    return AddOrderModel(
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      materialPrice: materialPrice ?? this.materialPrice,
      addMaking: addMaking ?? this.addMaking,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      totalProfit: totalProfit ?? this.totalProfit,
      cash: cash ?? this.cash,
      pendingCash: pendingCash ?? this.pendingCash,
      orderTime: orderTime ?? this.orderTime,
      sizeAndQuantity: sizeAndQuantity ?? this.sizeAndQuantity,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'orderId': this.orderId,
      'customerId': this.customerId,
      'customerName': this.customerName,
      'materialPrice': this.materialPrice,
      'addMaking': this.addMaking,
      'quantity': this.quantity,
      'totalPrice': this.totalPrice,
      'totalProfit': this.totalProfit,
      'cash': this.cash,
      'pendingCash': this.pendingCash,
      'orderTime': this.orderTime,
      'sizeAndQuantity': this.sizeAndQuantity,
    };
  }

  factory AddOrderModel.fromMap(Map<String, dynamic> map) {
    return AddOrderModel(
      orderId: map['orderId'] as String,
      customerId: map['customerId'] as String,
      customerName: map['customerName'] as String,
      materialPrice: map['materialPrice'] as String,
      addMaking: map['addMaking'] as String,
      quantity: map['quantity'] as String,
      totalPrice: map['totalPrice'] as String,
      totalProfit: map['totalProfit'] as String,
      cash: map['cash'] as String,
      pendingCash: map['pendingCash'] as String,
      orderTime: map['orderTime'] as DateTime,
      sizeAndQuantity: map['sizeAndQuantity'] as List<Map<String, dynamic>>,
    );
  }





}