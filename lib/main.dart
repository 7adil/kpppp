import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/firebase_options.dart';
import 'package:untitled/provider/accounts-filter-provider.dart';
import 'package:untitled/provider/backend-provider.dart';
import 'package:untitled/provider/customer-detail-provider.dart';
import 'package:untitled/provider/customer-filter-provider.dart';
import 'package:untitled/provider/maintenance-report-provider.dart';
import 'package:untitled/views/home-view.dart';
void main() async{
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>BackendProvider()),
      ChangeNotifierProvider(create: (_)=>CustomerDetailProvider()),
      ChangeNotifierProvider(create: (_)=>CustomerFilterProvider()),
      ChangeNotifierProvider(create: (_)=>AccountFilterProvider()),
      ChangeNotifierProvider(create: (_)=>MaintenanceReportProvider()),

    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kumail Plastic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    ),
    );
  }
}
