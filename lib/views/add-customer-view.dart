import 'package:flutter/material.dart';
import 'package:untitled/models/add-customer-model.dart';
import 'package:untitled/services/add-customer-services.dart';
import '../uiComponents/customer-button.dart';
import '../uiComponents/customer-textfield.dart';

class AddCustomerPage extends StatelessWidget {
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cnicController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.grey.shade200, // Set the AppBar background color
        foregroundColor: Colors.black, // Set the text color of AppBar
      ),
      backgroundColor: Colors.grey.shade200, // Set the Scaffold background color
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Enable vertical scrolling
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Center( // Center the text
                child: Text(
                  'Kumail Plastic',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomTextField(
                  labelText: 'Name',
                  controller: _nameController,
                  icon: Icons.person,
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomTextField(
                  labelText: 'Company',
                  controller: _companyController,
                  icon: Icons.business,
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomTextField(
                  labelText: 'Address',
                  controller: _addressController,
                  icon: Icons.location_on,
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomTextField(
                  labelText: 'Phone',
                  controller: _phoneController,
                  icon: Icons.phone,
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomTextField(
                  labelText: 'CNIC',
                  controller: _cnicController,
                  icon: Icons.credit_card,
                ),
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                height: 50,
                width: 200, // Set the width to 200
                child: CustomButton(
                  buttonText: 'Add Customer',
                  onPressed: () {
                    var model = CustomerModel(
                        shopId: '',
                        customerId: '',
                        customerName: _nameController.text,
                        customerCompanyName: _companyController.text,
                        customerAddress: _addressController.text,
                        customerPhoneNumber: _phoneController.text,
                        customerCNIC: _cnicController.text,
                        newStock: '0',
                        oldStock: '0'
                    );
                    if (_formKey.currentState!.validate()) {
                      AddCustomerServices.addCustomer(model, context).then((value){
                        _nameController.clear();
                        _companyController.clear();
                        _addressController.clear();
                        _phoneController.clear();
                        _cnicController.clear();
                      });
                    } else {
                      // Handle form validation failure
                    }
                  },
                  icon: Icons.person_add,
                  iconSize: 24,
                  color: Colors.deepPurple,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
