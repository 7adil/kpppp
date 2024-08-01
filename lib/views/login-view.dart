import 'package:flutter/material.dart';

import '../uiComponents/customer-button.dart';
import '../uiComponents/customer-textfield.dart';
import 'home-view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.purple],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Center(
                  child: Icon(
                    Icons.shopping_bag,
                    size: MediaQuery.of(context).size.width * 0.5,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(color: Colors.white, width: 1),
                        ),
                        child: SizedBox(
                          width: 300,
                          child: CustomTextField(
                            labelText: 'Email',
                            controller: TextEditingController(),
                            icon: Icons.email,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(color: Colors.white, width: 1),
                        ),
                        child: SizedBox(
                          width: 300,
                          child: CustomTextField(
                            labelText: 'Password',
                            controller: TextEditingController(),
                            obscureText: true,
                            icon: Icons.lock,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: 200,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: CustomButton(
                          buttonText: 'Login',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Home()),
                            );
                          },
                          color: Colors.deepPurpleAccent,
                          textColor: Colors.white,
                          icon: Icons.login,
                          iconSize: 24.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
