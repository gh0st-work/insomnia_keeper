import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../misc/already_have_an_account_acheck.dart';
import 'login_screen.dart';

class SignupScreen extends HookWidget{

  @override
  Widget build(BuildContext context) {
    final _isVisible = useState(false);
    final _isPasswordCharacters = useState(false);
    final theme = Theme.of(context);

    onPasswordChange(String password){
      _isPasswordCharacters.value = false;
      if(password.length >= 16){
        _isPasswordCharacters.value = true;
      }
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withOpacity(0.8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "SIGNUP",
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
              onChanged: (String value){},
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
              onChanged: (password) => onPasswordChange(password),
              obscureText: !_isVisible.value,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: _isPasswordCharacters.value ? Colors.green : Colors.transparent,
                    border: _isPasswordCharacters.value ? Border.all(color: Colors.transparent) : Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: _isPasswordCharacters.value ? 15 : 0,
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Text("Contains at least 16 characters")
            ],
          ),
          SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 50),
                ),
                onPressed: _isPasswordCharacters.value ? (){} : null,
                child: const Text(
                  "SIGNUP",
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
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          }, login: false,)
        ],
      ),
    );
  }
}