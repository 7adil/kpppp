import 'dart:ui';
import 'package:flutter/material.dart';
import 'accounts-view.dart';
import 'add-customer-view.dart';
import 'customer-report-view.dart';
import 'order-view.dart';
import 'maintenance-view.dart';
class Home extends StatelessWidget {
  const Home({super.key});
  final double buttonHeight = 150.0;
  final double buttonWidth = 300.0;
  final double iconSize = 32.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(

                    children: [
                      const SizedBox(height: 50),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                        leading: Image.asset(
                          'assets/images/kp.png', // Replace with your image asset path
                          height: 100,
                          width: 100,
                        ),
                        title: Text(
                          'Kumail Plastic',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                        ),

                      ),
                      const SizedBox(height: 30)
                    ],
                  ),
                ),
                // 0xFFC69840
                Container(
                  color: Colors.black87,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                     decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(200)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 26,
                          mainAxisSpacing: 26,
                          shrinkWrap: true,
                          children: <Widget>[
                            buildCard(context, 'ADD Customer', Icons.person_add, AddCustomerPage(), Colors.blueAccent),
                            buildCard(context, 'Order', Icons.shopping_cart, CustomerOrderPage(), Colors.green),
                            buildCard(context, 'Customer Details', Icons.person, CustomerReport(), Colors.purple),
                            buildCard(context, 'Accounts', Icons.account_balance, Accounts(), Colors.teal),
                            buildCard(context, 'Maintenance', Icons.build, Maintenance(), Colors.red),

                          ],

                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(BuildContext context, String title, IconData icon, Widget page, Color iconColor) {
    return GestureDetector(
      onTapDown: (_) {},
      onTapUp: (_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 50, color: iconColor),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


