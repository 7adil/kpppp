import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:untitled/models/maintenance-model.dart';
import 'package:untitled/services/maintenence-sevices.dart';
import 'package:untitled/views/maintenance-report-view.dart';
import '../uiComponents/customer-button.dart';
import '../uiComponents/customer-textfield.dart';

class Maintenance extends StatefulWidget {
  const Maintenance({super.key});

  @override
  _MaintenanceState createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Widget> _cards = [];
  List<Map<String, dynamic>> _controllers = [];

  // List of colors to cycle through
  final List<Color> _iconColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    _addNewCard(); // Initial card
  }

  void _addNewCard() {
    int currentIndex = _cards.length;

    TextEditingController field1Controller = TextEditingController();
    TextEditingController field2Controller = TextEditingController();
    TextEditingController field3Controller = TextEditingController();
    DateTime selectedDate = DateTime.now();

    _controllers.add({
      'reason': field1Controller,
      'amount': field2Controller,
      'date': field3Controller,
      'selectedDate': selectedDate,
    });

    setState(() {
      _cards.add(
        Card(
          color: Colors.grey[400], // Set the background color here
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Center(
                      child: Text(
                        'Kumail Plastic',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: _iconColors[currentIndex % _iconColors.length]),
                      onPressed: () => _removeCard(currentIndex),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                CustomTextField(
                  labelText: 'Reason',
                  controller: field1Controller,
                  icon: Icons.person,
                  iconColor: _iconColors[currentIndex % _iconColors.length], // Pass icon color here
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  labelText: 'Amount',
                  controller: field2Controller,
                  icon: Icons.attach_money,
                  iconColor: _iconColors[(currentIndex + 1) % _iconColors.length], // Pass icon color here
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                        field3Controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        _controllers[currentIndex]['selectedDate'] = pickedDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      labelText: 'Date',
                      controller: field3Controller,
                      icon: Icons.calendar_today,
                      iconColor: _iconColors[(currentIndex + 2) % _iconColors.length], // Pass icon color here
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _removeCard(int index) {
    setState(() {
      _cards.removeAt(index);
      _controllers.removeAt(index);
    });
  }

  Future<void> _submitCards() async {
    if (_formKey.currentState!.validate()) {
      for (var controllerMap in _controllers) {
        String reason = controllerMap['reason']!.text;
        String amount = controllerMap['amount']!.text;
        DateTime date = controllerMap['selectedDate'];

        MaintenanceModel model = MaintenanceModel(
          shopId: '',
          maintenanceId: '',
          reason: reason,
          amount: amount,
          dateTime: date,
        );

        await MaintenanceServices.addMaintenance(model, context);
      }
      setState(() {
        _cards.clear();
        _controllers.clear();
        _addNewCard();
      });


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[250], // Set the background color of the page here
      appBar: AppBar(
        title: const Text(''),backgroundColor: Colors.grey[200],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ..._cards,
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomButton(
                      buttonText: 'Add New',
                      onPressed: _addNewCard,
                      color: Colors.blueGrey,
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: CustomButton(
                      buttonText: 'Report',
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MaintenanceReportView()));
                      },
                      color: Colors.blueGrey,
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: CustomButton(
                      buttonText: 'Submit',
                      onPressed: _submitCards,
                      color: Colors.blueGrey,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
