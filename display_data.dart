import 'package:flutter/material.dart';
import 'package:save_show_sqllite/db_helper.dart';
import 'package:save_show_sqllite/home.dart';
//import 'database_helper.dart';
import 'main.dart'; // Import the registration page

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final data = await DatabaseHelper.getUsers();
    setState(() {
      users = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
        actions: [
          // 📌 Icon button to navigate back to registration page
          IconButton(
            icon: Icon(Icons.person_add), // Person add icon
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserFormScreen()),
              );
            },
          ),
        ],
      ),
      body: users.isEmpty
          ? Center(child: Text("No users found"))
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user["name"]),
            subtitle: Text(user["email"]),
          );
        },
      ),
    );
  }
}
