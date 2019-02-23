import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

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
  FirebaseUser loginUser;
  bool isLoginChecked = false;

  void setLoginUser(FirebaseUser user) {
    setState(() {
      loginUser = user;
    });
  }

  void checkLogin() async {
    FirebaseUser currentUser = await _auth.currentUser();

    setState(() {
      isLoginChecked = true;

      if(currentUser != null) {
        setLoginUser(currentUser);
      }
    });
  }

  void loginByGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    setLoginUser(user);
  }

  void loginAnonymously() async {
    FirebaseUser user = await _auth.signInAnonymously();
    setLoginUser(user);
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

  Widget buildWaitingLabel() {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login page"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Login checking....'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loginUser != null) {
      return new MainPage(loginUser: loginUser);
    }else if(isLoginChecked){
      return buildLoginButton();
    }else{
      checkLogin();
      return buildWaitingLabel();
    }
  }
}


class MainPageState extends State<MainPage> {
  bool isLogOut = false;

  void logout() async {
    await _auth.signOut();

    setState(() {
      isLogOut = true;
    });
  }

  Widget buildUserInfo() {
    String name = widget.loginUser.isAnonymous ? "Anonymous" : widget.loginUser.displayName;
    String message = "Hello! " + name + " " + widget.loginUser.uid;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('MainPage'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message),
            new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new RaisedButton(
                child: const Text('logout'),
                onPressed: () => logout(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(isLogOut) {
      return new LoginPage();
    }else {
      return buildUserInfo();
    }
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.loginUser}) : super(key: key);

  final FirebaseUser loginUser;

  @override
  MainPageState createState() => new MainPageState();
}
