import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/pages/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _numberController = TextEditingController();

  void _saveUserData(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String name = _nameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;
    String phoneNumber = _numberController.text;

    if (name.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty) {
      // Show an error message if any of the fields is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return; // Exit the method early
    }

    try {
      await preferences.setString('name', _nameController.text);
      await preferences.setString('password', _passwordController.text);
      await preferences.setString('email', _emailController.text);
      await preferences.setString('phoneNumber', _numberController.text);

      _showSnackbar(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
    } catch (e) {
      print('Error navigating to login page: $e');
    }
  }

  void _showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signup Successful'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Signup Page')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Name'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Password'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Email'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Phone Number'),
              ),
              const SizedBox(
                height: 10,
              ),
              Builder(
                builder: (context) => ElevatedButton.icon(
                  onPressed: () => _saveUserData(context),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Signup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
