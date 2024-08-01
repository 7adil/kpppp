import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel{
  String shopId;
  String customerId;
  String customerName;
  String customerCompanyName;
  String customerAddress;
  String customerPhoneNumber;
  String customerCNIC;
  String newStock;
  String oldStock;

  factory CustomerModel.fromDoc(DocumentSnapshot map) {
    return CustomerModel(
      shopId: map['shopId'] as String,
      customerId: map['customerId'] as String,
      customerName: map['customerName'] as String,
      customerCompanyName: map['customerCompanyName'] as String,
      customerAddress: map['customerAddress'] as String,
      customerPhoneNumber: map['customerPhoneNumber'] as String,
      customerCNIC: map['customerCNIC'] as String,
      newStock: map['newStock'] as String,
      oldStock: map['oldStock'] as String,
    );

  }

//<editor-fold desc="Data Methods">
  CustomerModel({
    required this.shopId,
    required this.customerId,
    required this.customerName,
    required this.customerCompanyName,
    required this.customerAddress,
    required this.customerPhoneNumber,
    required this.customerCNIC,
    required this.newStock,
    required this.oldStock,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerModel &&
          runtimeType == other.runtimeType &&
          shopId == other.shopId &&
          customerId == other.customerId &&
          customerName == other.customerName &&
          customerCompanyName == other.customerCompanyName &&
          customerAddress == other.customerAddress &&
          customerPhoneNumber == other.customerPhoneNumber &&
          customerCNIC == other.customerCNIC &&
          newStock == other.newStock &&
          oldStock == other.oldStock);

  @override
  int get hashCode =>
      shopId.hashCode ^
      customerId.hashCode ^
      customerName.hashCode ^
      customerCompanyName.hashCode ^
      customerAddress.hashCode ^
      customerPhoneNumber.hashCode ^
      customerCNIC.hashCode ^
      newStock.hashCode ^
      oldStock.hashCode;

  @override
  String toString() {
    return 'CustomerModel{' +
        ' shopId: $shopId,' +
        ' customerId: $customerId,' +
        ' customerName: $customerName,' +
        ' customerCompanyName: $customerCompanyName,' +
        ' customerAddress: $customerAddress,' +
        ' customerPhoneNumber: $customerPhoneNumber,' +
        ' customerCNIC: $customerCNIC,' +
        ' newStock: $newStock,' +
        ' oldStock: $oldStock,' +
        '}';
  }

  CustomerModel copyWith({
    String? shopId,
    String? customerId,
    String? customerName,
    String? customerCompanyName,
    String? customerAddress,
    String? customerPhoneNumber,
    String? customerCNIC,
    String? newStock,
    String? oldStock,
  }) {
    return CustomerModel(
      shopId: shopId ?? this.shopId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerCompanyName: customerCompanyName ?? this.customerCompanyName,
      customerAddress: customerAddress ?? this.customerAddress,
      customerPhoneNumber: customerPhoneNumber ?? this.customerPhoneNumber,
      customerCNIC: customerCNIC ?? this.customerCNIC,
      newStock: newStock ?? this.newStock,
      oldStock: oldStock ?? this.oldStock,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopId': this.shopId,
      'customerId': this.customerId,
      'customerName': this.customerName,
      'customerCompanyName': this.customerCompanyName,
      'customerAddress': this.customerAddress,
      'customerPhoneNumber': this.customerPhoneNumber,
      'customerCNIC': this.customerCNIC,
      'newStock': this.newStock,
      'oldStock': this.oldStock,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      shopId: map['shopId'] as String,
      customerId: map['customerId'] as String,
      customerName: map['customerName'] as String,
      customerCompanyName: map['customerCompanyName'] as String,
      customerAddress: map['customerAddress'] as String,
      customerPhoneNumber: map['customerPhoneNumber'] as String,
      customerCNIC: map['customerCNIC'] as String,
      newStock: map['newStock'] as String,
      oldStock: map['oldStock'] as String,
    );
  }

//</editor-fold>
}