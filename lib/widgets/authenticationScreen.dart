import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:indieimprint/services/authentication.dart';
import 'package:sign_button/sign_button.dart' as sign_in_button;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' ;

class authenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<authenticationScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailControllerCreate = TextEditingController();
  TextEditingController _passwordRemoteControllerCreate = TextEditingController();
  TextEditingController _passwordControllerCreate = TextEditingController();
  bool appleAvailable = false;

  authentication authService = new authentication();

  Future<void> appleSignInAvailable() async{
    appleAvailable = await TheAppleSignIn.isAvailable();

    setState(() {
      print('in appleSiginInAvailable - $appleAvailable');
    });

  }



  @override
  void initState() {
    super.initState();

    if(Platform.isIOS) {
      appleSignInAvailable();
      print("in initState of Auth Screen - $appleAvailable");
      TheAppleSignIn.onCredentialRevoked?.listen((_) {
        print("Credentials revoked");
      });
    }
  }





  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: SafeArea(
          child: Container(
          color: Colors.black,
          child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 20.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(),
                    Expanded(
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Image.asset('assets/flatline/icon_large.png', height: 480),
                              ),
                              SizedBox(height: 80,),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0), // Clip to create a pill shape
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.6, // Reduce to 60% of the screen's width
                                      color: Colors.black, // Black background color
                                      child: Container(
                                        color: Colors.white, // White interior color
                                        child: TextField(
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                            labelText: '  Email',
                                            labelStyle: TextStyle(color: Colors.black), // Set label text color to black
                                            // You can customize other input decoration properties here
                                          ),
                                          style: TextStyle(color: Colors.black), // Set text color to black
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0), // Clip to create a pill shape
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.6, // Reduce to 60% of the screen's width
                                      color: Colors.black, // Black background color
                                      child: Container(
                                        color: Colors.white, // White interior color
                                        child: TextField(
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                            labelText: '  Password',
                                            labelStyle: TextStyle(color: Colors.black), // Set label text color to black
                                            // You can customize other input decoration properties here
                                          ),
                                          style: TextStyle(color: Colors.black), // Set text color to black
                                          obscureText: true,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10),
                                  sign_in_button.SignInButton(
                                    buttonType: sign_in_button.ButtonType.mail,
                                    buttonSize: sign_in_button.ButtonSize.medium,
                                    btnTextColor: Colors.white,
                                    btnColor: Color(0xFFB5CAF0),
                                    btnText: "Sign in with E-mail",
                                    onPressed: () async {
                                      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: 'Please Enter a Email and Password',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Color(0xFFB5CAF0).withOpacity(0.8),
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );

                                        return;
                                      }

                                      User? user = await authService.signInWithEmail(
                                          _emailController.text, _passwordController.text);

                                      if (user != null) {
                                        Navigator.pushReplacementNamed(
                                            context, 'mainScreen');
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: 'Incorrect Username or Password!',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.redAccent,
                                          textColor: Colors.white,
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  //TODO:  Fix Apple Sign In
                                  appleAvailable ?
                                  sign_in_button.SignInButton(
                                    buttonType: sign_in_button.ButtonType.apple,
                                    buttonSize: sign_in_button.ButtonSize.medium,
                                    onPressed: () async {
                                      User? user = await authService.signInWithApple();

                                      if (user != null){
                                        Navigator.pushReplacementNamed(context, 'mainScreen');
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: 'Issue with Apple Sign In, Please try again',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.redAccent,
                                          textColor: Colors.white,
                                        );}

                                    },

                                  ) : SizedBox(height: 8.0,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      sign_in_button.SignInButton(
                                        buttonType: sign_in_button.ButtonType.google,
                                        buttonSize: sign_in_button.ButtonSize.medium,
                                        onPressed: () async {
                                          User? user = await authentication.handleGoogleSignIn();
                                          if(user != null) {
                                            Navigator.pushReplacementNamed(
                                                context, 'mainScreen');
                                          }else {
                                            Fluttertoast.showToast(
                                              msg: 'Issue with Google Sign In, Please try again',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.redAccent,
                                              textColor: Colors.white,
                                            );}
                                        },

                                      ),


                                      SizedBox(height: 8,),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    title: Text("Create a New User"),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        TextField(
                                                          controller: _emailControllerCreate,
                                                          decoration: InputDecoration(
                                                            labelText: 'Email',
                                                          ),
                                                        ),
                                                        TextField(
                                                          controller: _passwordControllerCreate,
                                                          decoration: InputDecoration(
                                                            labelText: 'Password',
                                                          ),
                                                          obscureText: true,
                                                        ),
                                                        SizedBox(height: 10),
                                                        ElevatedButton(
                                                            onPressed: () async {
                                                              if (_emailControllerCreate.text.isEmpty || _passwordControllerCreate.text.isEmpty) {
                                                                Fluttertoast.showToast(
                                                                  msg: 'Please Enter a Email and Password',
                                                                  toastLength: Toast.LENGTH_SHORT,
                                                                  gravity: ToastGravity.CENTER,
                                                                  backgroundColor: Color(0xFFB5CAF0).withOpacity(0.8),
                                                                  textColor: Colors.white,
                                                                  fontSize: 16.0,
                                                                );

                                                                return;
                                                              }

                                                              User? cu = await authService.createUserWithEmail(
                                                                  _emailControllerCreate.text,
                                                                  _passwordControllerCreate.text);

                                                              if (cu != null) {
                                                                Fluttertoast.showToast(
                                                                  msg: 'Go to Profile to Set Your Image and Name!',
                                                                  toastLength: Toast.LENGTH_SHORT,
                                                                  gravity: ToastGravity.CENTER,
                                                                  backgroundColor: Color(0xFFB5CAF0).withOpacity(0.8),
                                                                  textColor: Colors.white,
                                                                  fontSize: 16.0,
                                                                );

                                                                Navigator.pushReplacementNamed(context, 'mainScreen');

                                                              } else {
                                                                Fluttertoast.showToast(
                                                                  msg: 'Issue with Creating User, please try again.',
                                                                  toastLength: Toast.LENGTH_SHORT,
                                                                  gravity: ToastGravity.CENTER,
                                                                  timeInSecForIosWeb: 1,
                                                                  backgroundColor: Colors.redAccent,
                                                                  textColor: Colors.white,
                                                                );
                                                              }


                                                            },
                                                            child: Text("Create Account"))
                                                      ],
                                                    ));
                                              });
                                        },
                                        child: Text("New User? Click here", style: TextStyle(color: Colors.white),),
                                      ),
                                      SizedBox(height: 10,),
                                      GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                      title: Text("Reset Password", style: TextStyle(color: Colors.white),),

                                                      content: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text("Enter the Email Address you registered with"),
                                                          TextField(
                                                            controller: _passwordRemoteControllerCreate,
                                                            decoration: InputDecoration(
                                                              labelText: 'E-mail Address',
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          //TODO: Why is this here?
                                                          /*ElevatedButton(
                                                        onPressed: () async {
                                                          if (_passwordRemoteControllerCreate.text.isEmpty) {
                                                            Fluttertoast.showToast(
                                                              msg: 'Please Enter your E-mail',
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              gravity: ToastGravity.CENTER,
                                                              backgroundColor: Color(0xFFB5CAF0).withOpacity(0.8),
                                                              textColor: Colors.white,
                                                              fontSize: 16.0,
                                                            );

                                                            return;
                                                          }

                                                        },
                                                        child: Text("Reset My Password"))*/
                                                        ],

                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text('Cancel'),
                                                          onPressed: () {
                                                            Navigator.of(context).pop(); // Close the dialog
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text('Reset My Password', style: TextStyle(color: Colors.red)),
                                                          onPressed: () async { await authentication.resetPassword(
                                                              _passwordRemoteControllerCreate.text);


                                                          Fluttertoast.showToast(
                                                            msg: 'If you are a registered user, you will receive an e-mail with instructions',
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.CENTER,
                                                            backgroundColor: Color(0xFFB5CAF0).withOpacity(0.8),
                                                            textColor: Colors.white,
                                                            fontSize: 16.0,
                                                          );

                                                          Navigator.of(context).pop();

                                                            // Close the dialog
                                                          },
                                                        ),
                                                      ]);
                                                });
                                          },
                                          child: Text("Forgot Password? Click Here", style: TextStyle(color: Colors.grey),)
                                      )
                                    ],
                                  ),
                                ],
                              ),

                            ])
                    )],
                )),)),);
  }


}
