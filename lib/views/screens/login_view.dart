import 'package:flutter/cupertino.dart';
import 'package:webtoon_crawler_app/domain/service/authentication_service.dart';

import '../../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthenticationService authenticationService = AuthenticationService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _emailError = '';
  String _passwordError = '';

  void _attemptLogin() {
    setState(() {
      _emailError = '';
      _passwordError = '';
    });

    bool isValid = true;

    if (_emailController.text.isEmpty || !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(_emailController.text)) {
      isValid = false;
      setState(() {
        _emailError = 'Please enter a valid email.';
      });
    }

    if (_passwordController.text.isEmpty) {
      isValid = false;
      setState(() {
        _passwordError = 'Please enter your password.';
      });
    }

    if (isValid) {
      authenticationService.login(_emailController.text, _passwordController.text).then((value) {
        print(value);
        if (value) {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              builder: (context) => MyApp(),
            ),
          );
        } else {
          setState(() {
            _passwordError = 'Invalid email or password.';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Login'),

      ),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                CupertinoTextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  placeholder: 'Email',
                  clearButtonMode: OverlayVisibilityMode.editing,
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    border: Border.all(
                      color: CupertinoColors.lightBackgroundGray,
                      width: _emailError.isNotEmpty ? 1.0 : 0.0, // Highlight border if there's an error
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                if (_emailError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(_emailError, style: TextStyle(color: CupertinoColors.destructiveRed)),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                CupertinoTextField(
                  controller: _passwordController,
                  obscureText: true,
                  placeholder: 'Password',
                  clearButtonMode: OverlayVisibilityMode.editing,
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    border: Border.all(
                      color: CupertinoColors.lightBackgroundGray,
                      width: _passwordError.isNotEmpty ? 1.0 : 0.0, // Highlight border if there's an error
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                if (_passwordError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(_passwordError, style: TextStyle(color: CupertinoColors.destructiveRed)),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: CupertinoButton.filled(
              onPressed: _attemptLogin,
              child: const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

