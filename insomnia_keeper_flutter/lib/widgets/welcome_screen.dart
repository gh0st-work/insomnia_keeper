import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/widgets/login_screen.dart';
import 'package:insomnia_keeper_flutter/widgets/signup_screen.dart';

class WelcomeScreen extends HookWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome to Insomnia Keeper",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300
            ),
          ),
          //LOGO HERE
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.6, 50),
                ),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16
                  ),
                )
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.6, 50),
                ),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: const Text(
                  "SIGNUP",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}