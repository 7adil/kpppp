import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceModel{
  String shopId;
  String maintenanceId;
  String reason;
  String amount;
  DateTime dateTime;

//<editor-fold desc="Data Methods">
  MaintenanceModel({
    required this.shopId,
    required this.maintenanceId,
    required this.reason,
    required this.amount,
    required this.dateTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceModel &&
          runtimeType == other.runtimeType &&
          shopId == other.shopId &&
          maintenanceId == other.maintenanceId &&
          reason == other.reason &&
          amount == other.amount &&
          dateTime == other.dateTime);

  @override
  int get hashCode =>
      shopId.hashCode ^
      maintenanceId.hashCode ^
      reason.hashCode ^
      amount.hashCode ^
      dateTime.hashCode;

  @override
  String toString() {
    return 'MaintenanceModel{ shopId: $shopId, maintenanceId: $maintenanceId, reason: $reason, amount: $amount, dateTime: $dateTime,}';
  }

  MaintenanceModel copyWith({
    String? shopId,
    String? maintenanceId,
    String? reason,
    String? amount,
    DateTime? dateTime,
  }) {
    return MaintenanceModel(
      shopId: shopId ?? this.shopId,
      maintenanceId: maintenanceId ?? this.maintenanceId,
      reason: reason ?? this.reason,
      amount: amount ?? this.amount,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopId': shopId,
      'maintenanceId': maintenanceId,
      'reason': reason,
      'amount': amount,
      'dateTime': dateTime,
    };
  }

  factory MaintenanceModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceModel(
      shopId: map['shopId'] as String,
      maintenanceId: map['maintenanceId'] as String,
      reason: map['reason'] as String,
      amount: map['amount'] as String,
      dateTime: map['dateTime'] as DateTime,
    );
  }
  factory MaintenanceModel.fromDoc(DocumentSnapshot map) {
    return MaintenanceModel(
      shopId: map['shopId'] as String,
      maintenanceId: map['maintenanceId'] as String,
      reason: map['reason'] as String,
      amount: map['amount'] as String,
      dateTime: (map['dateTime'] is Timestamp ? (map['dateTime'] as Timestamp).toDate() : DateTime.now()),
    );
  }

//</editor-fold>
}