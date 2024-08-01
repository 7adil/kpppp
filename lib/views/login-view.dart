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
          decoration: BoxDecoration(
            color: Colors.grey[200],
            image: DecorationImage(
              image: AssetImage('assets/images/background_image.png'), // Add a background image if desired
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Center(
                  child: Image.asset(
                    'assets/images/cropped_image.png',
                    width: MediaQuery.of(context).size.width * 0.4, // Adjust size as needed
                    height: MediaQuery.of(context).size.width * 0.4, // Adjust size as needed
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Kumail Plastic',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: Column(
                    children: [
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: const BorderSide(color: Colors.blueGrey, width: 1), // Adjust border color if needed
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
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
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: const BorderSide(color: Colors.blueGrey, width: 1), // Adjust border color if needed
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
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
                        width: 150,
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
