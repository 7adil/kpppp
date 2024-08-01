import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/add-order-model.dart';
import 'package:untitled/models/maintenance-model.dart';
import 'package:untitled/provider/accounts-filter-provider.dart';
import 'package:untitled/provider/maintenance-report-provider.dart';
import 'package:untitled/services/add-order-services.dart';
import 'package:untitled/services/maintenence-sevices.dart';
import 'package:untitled/uiComponents/account-widget.dart';
import 'package:untitled/utils/global-functions.dart';

class MaintenanceReportView extends StatelessWidget {
  const MaintenanceReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maintenance "),
        centerTitle: true,
        backgroundColor: Colors.grey.shade200,
      ),

      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Consumer<MaintenanceReportProvider>(builder: (context,provider,child){
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
                    width: 132,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(provider.displayStartDate,
                            style:  const TextStyle(color: Colors.black,fontSize: 12))
                      ],
                    ),
                  ),
                );
              }),
              Consumer<MaintenanceReportProvider>(builder: (context,provider,child){
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
                    width: 132,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(provider.displayEndDate,
                            style:  const TextStyle(color: Colors.black,fontSize: 12))
                      ],
                    ),
                  ),
                );
              }),

            ],
          ),
          const SizedBox(height: 20),
          Consumer<MaintenanceReportProvider>(builder: (context,provider,child){
            return  StreamBuilder<List<MaintenanceModel>>(
                stream: MaintenanceServices.fetchAllMaintenanceQueryStreamForReport(context),
                builder: (context,AsyncSnapshot<List<MaintenanceModel>> snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var data=snapshot.data;
                  if(data!.isEmpty){
                    return const SizedBox(
                        height: 400,
                        child: Center(child: Text("No expense found between these dates")));
                  }
                  if(snapshot.hasError){
                    customPrint(snapshot.error.toString());
                  }

                  List<DataRow> createRows(List<MaintenanceModel> orders) {
                    return orders.map((order) {
                      DateTime date=order.dateTime;
                      String reason=order.reason;
                      String amount=order.amount;
                      return DataRow(cells: [
                        DataCell(Text(
                            DateFormat('dd-MM-yyyy').format(date))),
                        DataCell(Text(reason)),
                        DataCell(Text(amount)),

                      ]);
                    }).toList();
                  }
                  return  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DataTable(
                            columnSpacing: 16.0,
                            columns: const [
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Reason')),
                              DataColumn(label: Text('Amount')),
                            ],
                            rows: createRows(data),
                          ),
                          const SizedBox(height: 20),

                        ],
                      ),
                    ),
                  );
                });
          }),
         Consumer<MaintenanceReportProvider>(builder: (context,provider,child){
           return StreamBuilder(
               stream: MaintenanceServices.fetchTotalMaintenanceForReport(context),
               builder: (context,maintenanceSnapshot){
                 if(maintenanceSnapshot.connectionState==ConnectionState.waiting){
                   return const SizedBox();
                 }
                 var totalMaintenance=maintenanceSnapshot.data;
                 return Expanded(
                     flex: 2,
                     child: AccountWidget(title: "Total Maintenance", amount: totalMaintenance.toString(), bgColor: Colors.green.withOpacity(0.5)));
               });
         })
        ],
      ),
    );
  }
}
