import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _supabase = Supabase.instance.client;
  File? _selectedImage;

  Future<void> signup() async {
    final AuthResponse response = await _supabase.auth.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (response == null) {
      print('SomeThing wrong');
    } else {
      final userId = _supabase.auth.currentUser?.id;
      String? imageUrl;

      // رفع الصورة إلى Supabase Storage إذا تم اختيار صورة
      if (_selectedImage != null) {
        final filePath = 'avatars/$userId.jpg';
        final bytes = await _selectedImage!.readAsBytes();

        final storageResponse = await _supabase.storage
            .from('avatars')
            .uploadBinary(filePath, bytes);

        if (storageResponse.error == null) {
          imageUrl =
              _supabase.storage.from('avatars').getPublicUrl(filePath);
        }
      }

      // إدخال بيانات المستخدم في قاعدة البيانات
      await _supabase.from('users').insert({
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'uid': userId,
        'avatar_url': imageUrl,
      });

      log('User Signup Successfully with user id: $userId');
      Navigator.pushNamed(context, "/home");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إنشاء حساب")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child: _selectedImage == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text("الاسم",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: "أدخل اسمك"),
                validator: (value) => value!.isEmpty ? "الاسم مطلوب" : null,
              ),
              SizedBox(height: 10),
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
                      signup();
                    }
                  },
                  child: Text("إنشاء حساب"),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("لديك حساب بالفعل؟ تسجيل الدخول"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on String {
  get error => null;
}
