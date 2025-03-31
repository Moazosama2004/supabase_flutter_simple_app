import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _supabase = Supabase.instance.client;

  login() async {
    final AuthResponse response = await _supabase.auth.signInWithPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (response == null) {
      print('SomeThing wrong');
    } else {
      log('User login Successifully');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User login Successifully')));
          Navigator.pushNamed(context, "/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تسجيل الدخول")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("البريد الإلكتروني",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(hintText: "example@email.com"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.contains("@") ? null : "بريد إلكتروني غير صالح",
              ),
              SizedBox(height: 10),
              Text("كلمة المرور",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: "********"),
                obscureText: true,
                validator: (value) => value!.length < 6
                    ? "يجب أن تكون كلمة المرور أطول من 6 أحرف"
                    : null,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      login();
                      print("تسجيل الدخول: ${_emailController.text}");
                    }
                  },
                  child: Text("تسجيل الدخول"),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    // الانتقال إلى شاشة التسجيل
                    Navigator.pushNamed(context, "/register");
                  },
                  child: Text("ليس لديك حساب؟ إنشاء حساب جديد"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
