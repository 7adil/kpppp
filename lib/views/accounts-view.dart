import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/customerWidgets/round-button.dart';
import 'package:untitled/models/add-order-model.dart';
import 'package:untitled/models/maintenance-model.dart';
import 'package:untitled/provider/accounts-filter-provider.dart';
import 'package:untitled/services/add-order-services.dart';
import 'package:untitled/services/maintenence-sevices.dart';
import 'package:untitled/uiComponents/account-widget.dart';

class Accounts extends StatefulWidget {
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get screen width and height
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.grey.shade200, // Match AppBar color
        foregroundColor: Colors.black, // Set text color of AppBar
      ),
      backgroundColor: Colors.grey.shade200, // Match Scaffold color
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<AccountFilterProvider>(builder: (context, provider, child) {
              return StreamBuilder(
                stream: AddOrderServices.fetchTotalEarning(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  var totalEarning = snapshot.data;
                  return StreamBuilder(
                    stream: MaintenanceServices.fetchTotalMaintenance(context),
                    builder: (context, maintenanceSnapshot) {
                      if (maintenanceSnapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }
                      var totalMaintenance = maintenanceSnapshot.data;
                      return StreamBuilder(
                        stream: AddOrderServices.fetchTotalProfit(context),
                        builder: (context, profitSnapshot) {
                          if (profitSnapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox();
                          }
                          var profit = profitSnapshot.data;
                          var totalProfit = profit! - totalMaintenance!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: AccountWidget(
                                      title: "Total Earning",
                                      amount: totalEarning.toString(),
                                      bgColor: Colors.cyan.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: AccountWidget(
                                      title: "Maintenance",
                                      amount: totalMaintenance.toString(),
                                      bgColor: Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              AccountWidget(
                                title: "Profit",
                                amount: totalProfit.toString(),
                                bgColor: Colors.green.withOpacity(0.5),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<AccountFilterProvider>(builder: (context, provider, child) {
                  return GestureDetector(
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        helpText: "",
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData(
                              primaryColor: Colors.white,
                              colorScheme: const ColorScheme.light(primary: Colors.black),
                            ),
                            child: child!,
                          );
                        },
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        provider.changeStartingDate(date);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.white10),
                      ),
                      height: 32,
                      width: screenSize.width * 0.4, // Responsive width
                      child: Center(
                        child: Text(
                          provider.displayStartDate,
                          style: const TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ),
                  );
                }),
                Consumer<AccountFilterProvider>(builder: (context, provider, child) {
                  return GestureDetector(
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        helpText: "",
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData(
                              primaryColor: Colors.white,
                              colorScheme: const ColorScheme.light(primary: Colors.black),
                            ),
                            child: child!,
                          );
                        },
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        provider.changeEndingTimeDate(date);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.white10),
                      ),
                      height: 32,
                      width: screenSize.width * 0.4, // Responsive width
                      child: Center(
                        child: Text(
                          provider.displayEndDate,
                          style: const TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),
            Consumer<AccountFilterProvider>(builder: (context, provider, child) {
              return StreamBuilder<List<AddOrderModel>>(
                stream: AddOrderServices.fetchAllOrderQueryStreamForAccounts(context),
                builder: (context, AsyncSnapshot<List<AddOrderModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var data = snapshot.data;
                  if (data!.isEmpty) {
                    return const Center(
                      child: Text("Not found"),
                    );
                  }
                  if (snapshot.hasError) {
                    // Handle error
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  List<DataRow> createRows(List<AddOrderModel> orders) {
                    double totalProfit = 0.0;
                    return orders.map((order) {
                      DateTime orderTime = order.orderTime;
                      String customerName = order.customerName;
                      String material = order.materialPrice;
                      String making = order.addMaking;
                      String quantity = order.quantity;
                      String totalPrice = order.cash;
                      String totalSale = order.totalPrice;
                      String totalCash = order.cash;
                      String pending = order.pendingCash;
                      double pendingCash = double.parse(pending);
                      double totalPriceDouble = double.parse(totalPrice);
                      double paidAmount = double.parse(totalCash);
                      String profit = order.totalProfit;
                      double totalProfitDouble = double.parse(profit);
                      totalProfit += totalProfitDouble;
                      String totalProfitConvert = totalProfit.toString();

                      return DataRow(cells: [
                        DataCell(Text(
                            DateFormat('dd-MM-yyyy').format(orderTime))),
                        DataCell(Text(customerName)),
                        DataCell(Text(material)),
                        DataCell(Text(making)),
                        DataCell(Text(quantity)),
                        DataCell(Text(totalPrice)),
                        DataCell(Text(totalSale)),
                        DataCell(Text(totalCash)),
                        DataCell(Text(pending)),
                      ]);
                    }).toList();
                  }

                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DataTable(
                            columnSpacing: screenSize.width * 0.02, // Responsive spacing
                            columns: const [
                              DataColumn(label: Text('Order Date')),
                              DataColumn(label: Text('Customer Name')),
                              DataColumn(label: Text('Material')),
                              DataColumn(label: Text('Making')),
                              DataColumn(label: Text('Quantity')),
                              DataColumn(label: Text('Total Price')),
                              DataColumn(label: Text('Total Sale')),
                              DataColumn(label: Text('Cash')),
                              DataColumn(label: Text('Pending')),
                            ],
                            rows: createRows(data),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Accounts(),
  ));
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool readOnly;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
