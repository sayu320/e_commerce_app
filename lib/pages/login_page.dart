import 'package:ecommerce_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Future<bool> validateCredentials(
        String enteredName, String enteredPassword) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? storedName = preferences.getString('name');
      String? storedPassword = preferences.getString('password');
      return (storedName == enteredName && storedPassword == enteredPassword);
    }

    void login() async {
      String enteredName = nameController.text;
      String enteredPassword = passwordController.text;
      bool isValid = await validateCredentials(enteredName, enteredPassword);
      if (isValid) {
         Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) => HomePage(),));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Inavlid Credentials')));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title:  const Center(child: Text('Login Page')),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Password'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
                onPressed: () {
                  login();
                },
                icon: const Icon(Icons.login),
                label:const Text('Login'))
          ],
        ),
      )),
    );
  }
}
