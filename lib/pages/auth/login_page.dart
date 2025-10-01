
// ignore_for_file: unused_catch_stack

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selc_lecturer/pages/dashboard.dart';

import '../../components/alert_dialog.dart';
import '../../components/button.dart';
import '../../components/text.dart';
import '../../providers/selc_provider.dart';
import 'auth_pages_background.dart';
import 'forgot_password_page.dart';


class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return AuthPagesBackground(      
      body: Card(
        elevation: 12,


        child: Container(
          width: 470,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            //Colors.grey.shade300
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
        
            children: [
      
              const SizedBox(
                height: 12,
              ),
      
              CircleAvatar(
                backgroundColor: Colors.green.shade400,
                radius: 50,
                child: Icon(
                  CupertinoIcons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
        
              SizedBox(height: 8,),
        
              HeaderText('Sign In'),
        
              const SizedBox(height: 24,),
        
        
              CustomTextField(
                controller: usernameController,
                hintText: 'Username',
                useLabel: true,
                leadingIcon: CupertinoIcons.person,
                onChanged: (newValue) => setState((){}),
              ),
        
              const SizedBox(height: 12,),
        
              CustomPasswordField(
                controller: passwordController,
                hintText: 'Password',
                onChanged: (newValue) => setState((){})
              ),
        
              const SizedBox(height: 12,),
        
              CustomButton.withText(
                'Login',
                onPressed: () => handleLogin(context),
                width: double.infinity,
                disable: usernameController.text.isEmpty && passwordController.text.isEmpty,
              ),
      
      
              const SizedBox(height: 24,),
      
      
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
      
                  CustomText('Forgot your password ?', fontSize: 14,), 
      
                  TextButton(
                    onPressed: () => handleReset(context),
                    child: CustomText(
                      'Click here to reset',
                      textColor: Colors.green.shade400,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      softwrap: true,
                      maxLines: 2,
                    ),
                  )
      
                ],
              )
        
            ]
          )
        ),
      )
    );
  }

  void handleLogin(BuildContext context) async {

    showDialog(  
      context: context,
      builder: (_) => LoadingDialog(message: 'Logging In',)
    );

    try{

      String username = usernameController.text;
      String password = passwordController.text;
      
      await Provider.of<SelcProvider>(context, listen: false).login(username: username, password: password);

      Navigator.pop(context); //closes the loading alert dialog

      //moves to the homepage.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const Dashboard()
        )
      );

    }on SocketException catch(_){

      Navigator.pop(context); //closes the loading alert dialog
      showNoConnectionAlertDialog(context);

    }on Exception catch(exception, stackTrace){

      Navigator.pop(context); //closes the loading alert dialog


      debugPrint(stackTrace.toString());

      showCustomAlertDialog(
        context, 
        title: 'Error', 
        contentText: exception.toString()
      );

    }on Error catch(error, stackTrace){

      Navigator.pop(context);

      showCustomAlertDialog(
        context, 
        title: 'Error', 
        contentText: 'An unexpected error occurred'
      );

      //debugPrint(stackTrace.toString());
    }


  }


  

  void handleReset(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ForgotPasswordPage()
      )
    );
  }
}

