import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/models/add-customer-model.dart';
import 'package:untitled/models/add-order-model.dart';
import 'package:untitled/services/add-customer-services.dart';
import 'package:untitled/services/add-order-services.dart';
import 'package:untitled/utils/global-functions.dart';
import 'package:untitled/utils/utils.dart';

import '../uiComponents/customer-button.dart';
import '../uiComponents/customer-textfield.dart';
import '../uiComponents/custom-typeAhead-textField.dart';

class CustomerOrderPage extends StatefulWidget {
  const CustomerOrderPage({super.key});

  @override
  _CustomerOrderPageState createState() => _CustomerOrderPageState();
}
class _CustomerOrderPageState extends State<CustomerOrderPage> {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController materialController = TextEditingController();
  final TextEditingController addMakingController = TextEditingController();
  final TextEditingController materialPriceController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController totalProfitController = TextEditingController();
  final TextEditingController totalQuantityController = TextEditingController();
  final TextEditingController pendingController = TextEditingController();
  final TextEditingController marketRateController = TextEditingController();
  final TextEditingController cashController = TextEditingController();
  final TextEditingController newStockController = TextEditingController();
  final TextEditingController productionController = TextEditingController();
  final TextEditingController oldStockController = TextEditingController();
  List<Map<String, TextEditingController>> rows = [
    {
      'size': TextEditingController(),
      'quantity': TextEditingController(),
    },
  ];
  String customerName='';
  String customerId='';
  final _cnt=SingleValueDropDownController();
  final focusNode=FocusNode();

  @override
  void initState() {
    super.initState();
    addMakingController.addListener(_calculatePrices);
    materialPriceController.addListener(_calculatePrices);
    totalQuantityController.addListener(_calculatePrices);
    cashController.addListener(_calculatePrices);
    marketRateController.addListener(_calculatePrices);
    productionController.addListener(_calculatePrices);
  }
  void _addRow() {
    setState(() {
      rows.add({
        'size': TextEditingController(),
        'quantity': TextEditingController(),
      });
    });
  }

  @override
  void dispose() {
    addMakingController.removeListener(_calculatePrices);
    materialPriceController.removeListener(_calculatePrices);
    totalQuantityController.removeListener(_calculatePrices);
    cashController.removeListener(_calculatePrices);
    customerNameController.dispose();
    materialController.dispose();
    addMakingController.dispose();
    materialPriceController.dispose();
    totalPriceController.dispose();
    totalProfitController.dispose();
    totalQuantityController.dispose();
    pendingController.dispose();
    cashController.dispose();
    super.dispose();
  }
  void _calculatePrices() {
    double addMaking = double.tryParse(addMakingController.text) ?? 0.0;
    double materialPrice = double.tryParse(materialPriceController.text) ?? 0.0;
    double quantity = double.tryParse(totalQuantityController.text) ?? 0.0;
    double cash = double.tryParse(cashController.text) ?? 0.0;
    double marketRate=double.tryParse(marketRateController.text)??0.0;
    double afterMinus=materialPrice-marketRate;
    double totalPrice = addMaking * quantity;
    double finalPrice = totalPrice + materialPrice;
    totalPriceController.text = finalPrice.toStringAsFixed(2);
    double totalProfit = finalPrice - materialPrice+afterMinus;
    totalProfitController.text = totalProfit.toStringAsFixed(2);
    double pending = finalPrice - cash;
    pendingController.text = pending.toStringAsFixed(2);
    productionController.text=totalQuantityController.text;
  }
  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    final String material = materialController.text;
    final String addMaking = addMakingController.text;
    final String materialPrice = materialPriceController.text;
    final String totalPrice = totalPriceController.text;
    final String totalProfit = totalProfitController.text;
    final String quantity = totalQuantityController.text;
    final String cash = cashController.text;
    final String pending = pendingController.text;

    final image = pw.MemoryImage(
      (await rootBundle.load('assets/images/cropped_image.png')).buffer.asUint8List(),
    );
    final currentDate = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    int lastInvoiceNumber = prefs.getInt('lastInvoiceNumber') ?? 500;
    lastInvoiceNumber += 1;
    await prefs.setInt('lastInvoiceNumber', lastInvoiceNumber);

    final invoiceNumber = 'KP $lastInvoiceNumber';

    // Define a method to build a header
    pw.Widget _buildHeader() {
      return pw.Container(
        padding: const pw.EdgeInsets.all(20),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      child: pw.Image(image, height: 100, width: 100),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 20),
                        pw.Text(
                          'Kumail Plastic',
                          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'We believe that quality is the best form of advertising.',
                          style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Container()), // Empty container to push the Column to the right
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    // pw.Text(customerName, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                    // pw.SizedBox(height: 5),
                  ],
                ),
                pw.SizedBox(width: 300),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Order Date: ${currentDate.year}-${currentDate.month}-${currentDate.day}',
                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                    ),
                    // pw.SizedBox(height: 5),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Divider(),
            pw.SizedBox(height: 5),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Container()), // Empty container to push the Column to the right
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(customerName, style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(width: 280),
                    pw.Text(
                      'Invoice No: $invoiceNumber',
                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 5),
          ],
        ),
      );
    }

    // Define a method to build a footer
    pw.Widget _buildFooter() {
      return pw.Container(
        padding: const pw.EdgeInsets.all(20),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(height: 5),
            pw.Text('Thank you for your business!', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text('Terms & Conditions', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text('Please make the payment within 15 days.', style: const pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 5),
            pw.Text('If you have any questions about this invoice, contact us at +923318404999.', style: const pw.TextStyle(fontSize: 12)),
          ],
        ),
      );
    }

    // Define a method to build a page with a watermark
    pw.Widget _buildPage() {
      return pw.Stack(
        children: [
          pw.Positioned(
            left: (PdfPageFormat.a4.width - 150) / 3 - 24,
            top: (PdfPageFormat.a4.height - 150) / 11 - 24,
            child: pw.Opacity(
              opacity: 0.1,
              child: pw.Image(image, height: 150, width: 150),
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Table.fromTextArray(
                border: pw.TableBorder.all(color: PdfColors.grey),
                cellAlignment: pw.Alignment.centerLeft,
                headerDecoration: const pw.BoxDecoration(color: PdfColors.blue100),
                headerHeight: 25,
                cellHeight: 30,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.blue),
                cellStyle: const pw.TextStyle(),
                headers: <String>['Description', 'Value'],
                data: <List<String>>[
                  ['Add Making', addMaking],
                  ['Material Price', materialPrice],
                  ['Total Quantity', quantity],
                  ['Total Price', totalPrice],
                  ['Cash', cash],
                  ['Pending', pending],
                ],
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 15),
                child: pw.Align(
                  alignment: pw.Alignment.centerRight, // Align to the right side of the page
                  child: pw.Container(
                    width: 250, // Set the fixed width
                    padding: const pw.EdgeInsets.symmetric(vertical: 15),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(vertical: 10),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.SizedBox(
                                width: 50, // Fixed width for the '#.' column
                                child: pw.Text('#.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                              ),
                              pw.SizedBox(
                                width: 50, // Fixed width for the 'Size' column
                                child: pw.Text('Size', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                              ),
                              pw.SizedBox(
                                width: 50, // Fixed width for the 'Quantity' column
                                child: pw.Text('Quantity', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                        // pw.Divider(),
                        pw.Column(
                          children: rows.asMap().entries.map((entry) {
                            final index = entry.key + 1;
                            final row = entry.value;
                            final size = row['size']?.text ?? '';
                            final quantity = row['quantity']?.text ?? '';
                            return pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.SizedBox(
                                  width: 50, // Fixed width for the '#.' column
                                  child: pw.Text(index.toString(), style: pw.TextStyle(fontSize: 12)),
                                ),
                                pw.SizedBox(
                                  width: 50, // Fixed width for the 'Size' column
                                  child: pw.Text(size, style: pw.TextStyle(fontSize: 12)),
                                ),
                                pw.SizedBox(
                                  width: 50, // Fixed width for the 'Quantity' column
                                  child: pw.Text(quantity, style: pw.TextStyle(fontSize: 12)),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


            ],
          ),
        ],
      );
    }

    // Add pages
    pdf.addPage(
      pw.MultiPage(
        header: (pw.Context context) => _buildHeader(),
        footer: (pw.Context context) => _buildFooter(),
        build: (pw.Context context) => [
          _buildPage(),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  void _handleSubmit() {
    // Handle the form submission logic here
    final String customerName = customerNameController.text;
    final String material = materialController.text;
    final String addMaking = addMakingController.text;
    final String materialPrice = materialPriceController.text;
    final String totalPrice = totalPriceController.text;
    final String totalProfit = totalProfitController.text;
    final String quantity = totalQuantityController.text;
    final String cash = cashController.text;
    final String pending = pendingController.text;

    // For demonstration, we'll print the values to the console
    customPrint('Customer Name: $customerName');
    // print('Material: $material');
    customPrint('Add Making: $addMaking');
    customPrint('Material Price: $materialPrice');
    customPrint('Total Price: $totalPrice');
    customPrint('Total Profit: $totalProfit');
    customPrint('Quantity: $quantity');
    customPrint('Cash: $cash');
    customPrint('Pending: $pending');
  }
  void _deleteRow(int index) {
    setState(() {
      rows.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Order Page')),
      body: Container(
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Customer Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              return  DropDownTextField(
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
                                onChanged: (val) async{
                                  customerId=val.value;
                                  customerName=val.name;
                                  DocumentSnapshot getData=await FirebaseFirestore.instance.collection('customers').doc(val.value).get();
                                  oldStockController.text=getData['oldStock'];

                                },
                              );
                            }),
                      ],
                    )

                  ],
                ),
                const SizedBox(height: 16.0),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     const Text('Material Price', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                //     const SizedBox(height: 2.0),
                //     CustomTextField(
                //       labelText: 'Material Price',
                //       controller: materialPriceController,
                //       keyboardType: TextInputType.number,
                //       height: 40, // Set the height here
                //     ),
                //   ],
                // ),
                const SizedBox(height: 16.0),Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Material Price"),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                            labelText: 'Material Price',
                            controller: materialPriceController,
                            icon: Icons.production_quantity_limits,
                            iconColor: Colors.blue,
                            keyboardType: TextInputType.number,

                            height: 50.0, // Set the desired height
                            borderRadius: 10.0, // Set the desired border radius
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Market Rate"),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                            labelText: 'Market rate',
                            controller: marketRateController,
                            icon: Icons.production_quantity_limits,
                            iconColor: Colors.blue,
                            keyboardType: TextInputType.number,

                            height: 50.0, // Set the desired height
                            borderRadius: 10.0, // Set the desired border radius
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("New Stock"),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                            labelText: 'New Stock',
                            controller: newStockController,
                            // icon: Icons.production_quantity_limits,
                            iconColor: Colors.blue,
                            keyboardType: TextInputType.number,
                            height: 50.0, // Set the desired height
                            borderRadius: 10.0, // Set the desired border radius
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Production"),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                            labelText: 'Production',
                            controller: productionController,
                            // icon: Icons.production_quantity_limits,
                            iconColor: Colors.blue,
                            keyboardType: TextInputType.number,
                            enabled: false,
                            height: 50.0, // Set the desired height
                            borderRadius: 10.0, // Set the desired border radius
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Old Stock"),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                            labelText: 'Old Stock',
                            controller: oldStockController,
                            // icon: Icons.production_quantity_limits,
                            iconColor: Colors.blue,
                            keyboardType: TextInputType.number,
                            enabled: false,
                            height: 50.0, // Set the desired height
                            borderRadius: 10.0, // Set the desired border radius
                          ),
                        ],
                      ),
                    ),
                  ],
                ),const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Add Making', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2.0),
                    CustomTextField(
                      labelText: 'Add Making',
                      controller: addMakingController,
                      keyboardType: TextInputType.number,
                      height: 40, // Set the height here
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Quantity (kg)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2.0),
                    CustomTextField(
                      labelText: 'Total Quantity (kg)',
                      controller: totalQuantityController,
                      keyboardType: TextInputType.number,
                      height: 40, // Set the height here
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Price', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2.0),
                    CustomTextField(
                      labelText: 'Total Price',
                      controller: totalPriceController,
                      keyboardType: TextInputType.number,
                      enabled: false,
                      height: 40, // Set the height here
                      borderRadius: 15.0, // Set the border radius here
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Profit', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2.0),
                    CustomTextField(
                      labelText: 'Total Profit',
                      controller: totalProfitController,
                      keyboardType: TextInputType.number,
                      enabled: false,
                      height: 40,
                      borderRadius: 8.0,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cash', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2.0),
                    CustomTextField(
                      labelText: 'Cash',
                      controller: cashController,
                      keyboardType: TextInputType.number,
                      height: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pending', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2.0),
                    CustomTextField(
                      labelText: 'Pending',
                      controller: pendingController,
                      keyboardType: TextInputType.number,
                      enabled: false,
                      height: 40,
                      borderRadius: 8.0,
                    ),
                  ],
                ),const SizedBox(height: 16.0),
                Column(
                  children: rows.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, TextEditingController> row = entry.value;
                    return Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            labelText: 'Size',
                            controller: row['size']!,
                            icon: Icons.format_size,
                            iconColor: Colors.blue,
                            height: 50.0,
                            borderRadius: 10.0,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                            labelText: 'Quantity (kg)',
                            controller: row['quantity']!,
                            icon: Icons.production_quantity_limits,
                            iconColor: Colors.blue,
                            keyboardType: TextInputType.number,
                            height: 50.0,
                            borderRadius: 10.0,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteRow(index),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      buttonText: 'Add Row',
                      onPressed: _addRow,
                      color: Colors.blueGrey,
                      textColor: Colors.white,
                      elevation: 2.0,
                      borderRadius: 8.0,
                    ),

                    CustomButton(
                      buttonText: 'Submit',
                      onPressed:(){
                        int totalQuantity = 0;
                        List<Map<String, dynamic>> dataToSave = rows.map((row) {
                          int quantity = int.tryParse(row['quantity']!.text) ?? 0;
                          totalQuantity += quantity;
                          return {
                            'size': row['size']!.text,
                            'quantity': row['quantity']!.text,
                          };
                        }).toList();
                        var model=AddOrderModel
                          (orderId: '',
                            customerId: customerId,
                            customerName: customerName.isEmpty?'0':customerName,
                            materialPrice: materialPriceController.text.isEmpty?'0': materialPriceController.text,
                            addMaking: addMakingController.text.isEmpty? '0':addMakingController.text,
                            quantity: totalQuantityController.text,
                            totalPrice: totalPriceController.text.isEmpty? '0':totalPriceController.text,
                            totalProfit: totalProfitController.text.isEmpty? '0':totalProfitController.text,
                            cash: cashController.text.isEmpty? '0':cashController.text,
                            orderTime: DateTime.now(),
                            pendingCash: pendingController.text.isEmpty? '0': pendingController.text,
                            sizeAndQuantity: dataToSave
                        );
                        if(totalQuantity!=int.parse(totalQuantityController.text)){
                          Utils.toastMessage("Quantity does not match", Colors.red);
                          customPrint("Quantity does not matched");
                        }else{
                          AddOrderServices.addOrder(model, context).then((value){
                            AddCustomerServices.updateStock(newStockController.text.toString(), totalQuantityController.text.toString(),customerId);
                            materialController.clear();
                            addMakingController.clear();
                            totalQuantityController.clear();
                            totalProfitController.clear();
                            totalPriceController.clear();
                            cashController.clear();
                            pendingController.clear();
                            materialPriceController.clear();
                            marketRateController.clear();
                            rows.clear();
                            Navigator.pop(context);
                            // setState(() {
                            // });
                          });
                        }

                      },
                      color: Colors.blueGrey,
                      textColor: Colors.white,
                      elevation: 2.0,
                      borderRadius: 8.0,
                    ),
                    CustomButton(
                      buttonText: 'PDF',
                      onPressed: _generatePdf,
                      icon: Icons.print,
                      color: Colors.blueGrey,
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      elevation: 8.0,
                      borderRadius: 60.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}