import 'package:flutter/material.dart';
import 'package:gr_lrr/appbar.dart';
import 'package:gr_lrr/auth_service.dart';

import 'package:provider/provider.dart';

String developerPassword = "developer";
String maintenancePassword = "maintenance";
String operatorPassword = "operator";
String userName = "";

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _selectedRole = AccessLevel.developer; // Default role selection
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Role:',
              style: TextStyle(fontSize: 18),
            ),
            RadioListTile(
              title: Text('Developer'),
              value: AccessLevel.developer,
              groupValue: _selectedRole,
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('Maintenance'),
              value: AccessLevel.maintainer,
              groupValue: _selectedRole,
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('Operator'),
              value: AccessLevel.operator,
              groupValue: _selectedRole,
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authService.login(_selectedRole, _passwordController.text);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
