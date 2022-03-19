import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/widgets/signup_screen.dart';

import '../misc/already_have_an_account_acheck.dart';

class LoginScreen extends HookWidget{

  @override
  Widget build(BuildContext context) {
    final _isVisible = useState(false);
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withOpacity(0.8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "LOGIN",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300
            ),
          ),
          //LOGO HERE
          // Container(
          //   height: MediaQuery.of(context).size.height * 0.4,
          // ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: "Enter your tag"
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              obscureText: _isVisible.value,
              decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: "Enter your password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      _isVisible.value = !_isVisible.value;
                    },
                    icon: _isVisible.value ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                  )
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 50),
                ),
                onPressed: (){},
                child: const Text(
                  "LOGIN",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16
                  ),
                )
            ),
          ),
          AlreadyHaveAnAccountCheck(press: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupScreen()),
            );
          },)
        ],
      ),
    );
  }
}