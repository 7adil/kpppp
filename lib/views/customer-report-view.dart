import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:flutter_typeahead/flutter_typeahead.dart'; // Import flutter_typeahead package
import 'package:provider/provider.dart';
import 'package:untitled/customerWidgets/round-button.dart';
import 'package:untitled/models/add-customer-model.dart';
import 'package:untitled/models/add-order-model.dart';
import 'package:untitled/provider/accounts-filter-provider.dart';
import 'package:untitled/provider/customer-detail-provider.dart';
import 'package:untitled/provider/customer-filter-provider.dart';
import 'package:untitled/services/add-customer-services.dart';
import 'package:untitled/services/add-order-services.dart';
import 'package:untitled/uiComponents/account-widget.dart';
import 'package:untitled/utils/global-functions.dart';
import 'package:untitled/utils/utils.dart';

// Replace with correct path

import '../uiComponents/customer-textfield.dart';
import 'Customer.dart'; // Assuming Customer class is defined for customer data

class CustomerReport extends StatefulWidget {
  const CustomerReport({super.key});

  @override
  _CustomerReportState createState() => _CustomerReportState();
}

class _CustomerReportState extends State<CustomerReport> {
  final TextEditingController _materialController1 = TextEditingController();
  final TextEditingController _materialController2 = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _addManually = TextEditingController();


  final _cnt=SingleValueDropDownController();

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<CustomerDetailProvider>(context,listen: false);
    final filterProvider=Provider.of<CustomerFilterProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),backgroundColor: Colors.grey[200],
      ),backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TypeAheadFormField(
            //   textFieldConfiguration: TextFieldConfiguration(
            //     controller: _customerController,
            //     decoration: const InputDecoration(
            //       labelText: 'Customer',
            //       border: OutlineInputBorder(),
            //     ),
            //   ),
            //   suggestionsCallback: (pattern) async {
            //     return customers
            //         .where((customer) =>
            //         customer.name.toLowerCase().contains(pattern.toLowerCase()))
            //         .map((customer) => customer.name)
            //         .toList();
            //   },
            //   itemBuilder: (context, String suggestion) {
            //     return ListTile(
            //       title: Text(suggestion),
            //     );
            //   },
            //   onSuggestionSelected: (String? suggestion) {
            //     setState(() {
            //       _selectedCustomer = suggestion;
            //       _customerController.text =
            //       suggestion!; // Set the text field with selected value
            //       filterTransactions(
            //         _selectedCustomer,
            //         _materialController1.text.isNotEmpty
            //             ? DateTime.parse(_materialController1.text)
            //             : null,
            //         _materialController2.text.isNotEmpty
            //             ? DateTime.parse(_materialController2.text)
            //             : null,
            //       );
            //     });
            //   },
            // ),
            FutureBuilder<List<CustomerModel>>(
                future:AddCustomerServices.fetchAllCustomerOnce(),
                builder: (context,AsyncSnapshot<List<CustomerModel>> snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(snapshot.data!.isEmpty){
                    return const Center(
                      child: Text("Please add customer first"),
                    );
                  }
                  var list=<DropDownValueModel>[];

                  var data=snapshot.data;
                  data!.map((data){
                    list.add(DropDownValueModel(name: data.customerCompanyName, value: data.customerId));
                  }).toList();
                  return  Consumer<CustomerFilterProvider>(builder: (context,provider,child){
                    return DropDownTextField(
                      controller: _cnt,
                      clearOption: false,
                      enableSearch: true,
                      // clearIconProperty: IconProperty(color: Colors.green),
                      searchTextStyle:  const TextStyle(color: Colors.black),
                      textStyle: const TextStyle(
                          color: Colors.black
                      ),
                      textFieldDecoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Search for existing customers",
                          hintStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.black
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Colors.white
                              )
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(201, 249, 252, 0.62)
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(201, 249, 252, 0.62)
                              )
                          )
                      ),
                      searchDecoration:  InputDecoration(
                        fillColor:  Colors.grey.withOpacity(0.5),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(201, 249, 252, 0.62)
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(201, 249, 252, 0.62)
                            )
                        ),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black
                            )
                        ),
                        hintText: "Search",
                        hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Colors.black
                        ),

                      ),
                      listTextStyle: const TextStyle(
                          color: Colors.black
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "Required field";
                        } else {
                          return null;
                        }
                      },
                      dropDownItemCount: 6,

                      dropDownList: list,
                      onChanged: (val) {
                        provider.changeCustomerId(val.value);
                        customPrint(provider.customerId);
                      },
                    );
                  });
                }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<CustomerFilterProvider>(builder: (context,provider,child){
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
                Consumer<CustomerFilterProvider>(builder: (context,provider,child){
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
            Consumer<CustomerFilterProvider>(builder: (context,provider,child){
              return StreamBuilder(
                  stream: AddOrderServices.fetchTotalPendingOfCustomer(context, provider.customerId),
                  builder: (context,snap){
                if(snap.connectionState==ConnectionState.waiting){
                  return const CircularProgressIndicator();
                }
                  var totalPending=snap.data;
                print(totalPending);
                return AccountWidget(title: "Total Pending", amount: totalPending.toString(), bgColor: Colors.red.withOpacity(0.5));

              });
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                filterProvider.clearFilter();
                _cnt.clearDropDown();

              },
              child: const Text('Clear Filters'),
            ),
            const SizedBox(height: 20),
           Consumer<CustomerFilterProvider>(builder: (context,provider,child){
             return  StreamBuilder<List<AddOrderModel>>(
                 stream: AddOrderServices.fetchAllOrderQueryStream(context),
                 builder: (context,AsyncSnapshot<List<AddOrderModel>> snapshot){
                   if(snapshot.connectionState==ConnectionState.waiting){
                     return const Center(
                       child: CircularProgressIndicator(),
                     );
                   }
                   var data=snapshot.data;
                   if(data!.isEmpty){
                     return const Center(
                       child: Text("Not found"),
                     );
                   }
                   if(snapshot.hasError){
                     customPrint(snapshot.error.toString());
                   }
                   customPrint(data.toString());
                   List<DataRow> createRows(List<AddOrderModel> orders) {
                     return orders.map((order) {
                       DateTime orderTime=order.orderTime;
                       String customerName = order.customerName;
                       String material = order.materialPrice ;
                       String making =order.addMaking;
                       String quantity=order.quantity;
                       String totalPrice=order.cash;
                       String totalSale=order.totalPrice;
                       String totalCash=order.cash;
                       String pending=order.pendingCash;
                       double pendingCash=double.parse(pending);
                       double totalPriceDouble=double.parse(totalPrice);
                       double paidAmount=double.parse(totalCash);
                        String id = order.orderId;
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
                         DataCell(ElevatedButton(onPressed: (){
                           showDialog(context: context, builder: (context){
                             return AlertDialog(
                               title: const Text("Add Amount"),
                               content: SizedBox(
                                 height: 150,
                                 child: Column(
                                   children: [
                                     TextField(
                                       controller: _addManually,
                                       decoration: const InputDecoration(
                                         hintText: "Enter amount here"
                                       ),
                                     ),
                                     const SizedBox(
                                       height: 30,
                                     ),
                                     RoundButton(title: "Add", onTap: (){
                                       if(_addManually.text.isEmpty){
                                         Utils.toastMessage("Please enter amount", Colors.red);

                                       }
                                       else{
                                         double newValue= double.parse(_addManually.text);
                                         if(pendingCash==0){
                                           Utils.toastMessage("Amount already paid", Colors.red);

                                         }
                                         else if(newValue>pendingCash){
                                           Utils.toastMessage("Invalid Amount", Colors.red);
                                         }
                                         else if(newValue<0||newValue==0){
                                           Utils.toastMessage("Invalid Amount", Colors.red);
                                         }else{
                                           double newPaidAmount=paidAmount+newValue;
                                       double newDueAmount=pendingCash-newValue;
                                       AddOrderServices.updateOrder(id, {
                                         'cash':newPaidAmount.toString(),
                                         'pendingCash':newDueAmount.toString()
                                       }).then((onValue){
                                         Utils.toastMessage("Cash added successfully", Colors.green);
                                         _addManually.clear();
                                         Navigator.pop(context);
                                       });
                                       // print(newDueAmount);
                                       // print(newDueAmount==0?'paid':'unpaid');
                                         }
                                       }

                                     })
                                   ],
                                 ),
                               ),
                             );
                           });
                         }, child: const Text("Manually add"))),
                       ]);
                     }).toList();
                   }
                   return  Expanded(
                     child: SingleChildScrollView(
                       scrollDirection: Axis.horizontal,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           DataTable(
                             columnSpacing: 16.0,
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
                               DataColumn(label: Text('Add Pending amount')),
                             ],
                             rows: createRows(data),
                           ),
                           const SizedBox(height: 20),
                           // Text(
                           //   'Filtered by Customer: ${_selectedCustomer ?? 'All'}, From: ${_materialController1.text} To: ${_materialController2.text}',
                           //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                           // ),
                         ],
                       ),
                     ),
                   );
                 });
           }),

          ],
        ),
      ),
    );
  }
}

