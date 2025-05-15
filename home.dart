import 'package:flutter/material.dart';
import 'package:save_show_sqllite/db_helper.dart';
import 'package:save_show_sqllite/display_data.dart';
//import 'database_helper.dart';
//import 'user_list_screen.dart';

void main() {
  runApp(MaterialApp(
    home: UserFormScreen(),
  ));
}

// User Registration Page
class UserFormScreen extends StatefulWidget {
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Registration"),
        actions: [
          // 📌 Icon button to navigate to the data display page
          IconButton(
            icon: Icon(Icons.list), // List icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserListScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) => value!.isEmpty ? "Name is required" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return "Email is required";
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) => value!.isEmpty ? "Password is required" : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return "Phone number is required";
                  if (!RegExp(r'^03\d{9}$').hasMatch(value)) {
                    return "Enter a valid Pakistani phone number (e.g., 03001234567)";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await DatabaseHelper.insertUser(
                      nameController.text,
                      emailController.text,
                      passwordController.text,
                      phoneController.text,
                    );

                    // 📌 Clear input fields after successful submission
                    nameController.clear();
                    emailController.clear();
                    passwordController.clear();
                    phoneController.clear();

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Data submitted successfully!")),
                    );
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
