import 'package:adv_exam/service/auth_service.dart';

import 'package:adv_exam/view/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Signin extends StatelessWidget {
  const Signin({super.key});

  @override
  Widget build(BuildContext context) {
    var txtemail = TextEditingController();
    var txtpass = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(

              controller: txtemail,
              decoration: InputDecoration(label: Text('email'),enabledBorder: OutlineInputBorder()),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: txtpass,
              decoration: InputDecoration(label: Text('passward'),enabledBorder: OutlineInputBorder()),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () {
                  AuthServices.authServices.signInWithGoogle();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ));
                },
                child: Text('login '))
          ],
        ),
      ),
    );
  }
}
