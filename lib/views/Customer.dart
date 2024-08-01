import 'package:flutter/material.dart';

// Data model for customers
class Customer {
  final int id;
  final String name;

  Customer({required this.id, required this.name});
}

// Example data
List<Customer> customers = [
  Customer(id: 1, name: 'Customer 1'),
  Customer(id: 2, name: 'Customer 2'),
  Customer(id: 3, name: 'Customer 3'),
];

// List of materials
List<String> materials = ['Material A', 'Material B', 'Material C'];
