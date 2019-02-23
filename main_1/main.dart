import 'package:flutter/material.dart';

void main() => runApp(new RootPage());

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData base = new ThemeData.light();

    return new MaterialApp(
      title: 'HealthApp',
      theme: base.copyWith(
        buttonColor: Colors.blue,
        buttonTheme: const ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  void loginByGoogle() async {
  }

  void loginAnonymously() async {
  }

  Widget buildLoginButton() {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login page"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new RaisedButton(
                child: const Text('Google login'),
                onPressed: () => loginByGoogle(),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new RaisedButton(
                child: const Text('Anonymous Login'),
                onPressed: () => loginAnonymously(),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildLoginButton();
  }
}
