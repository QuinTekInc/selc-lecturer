
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selc_lecturer/pages/auth/login_page.dart';
import 'package:selc_lecturer/pages/dashboard.dart';
import 'package:selc_lecturer/providers/selc_provider.dart';




void main(){
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => SelcProvider(),
        child: SelcLecturerApp()
    )
  );
}




class SelcLecturerApp extends StatelessWidget {

  const SelcLecturerApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

