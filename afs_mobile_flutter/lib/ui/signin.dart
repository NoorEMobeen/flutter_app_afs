import 'dart:convert';

import 'package:afs_mobile_flutter/dashboard_Receiver.dart';
import 'package:afs_mobile_flutter/dashboard_donor.dart';
//import 'package:afs_mobile_flutter/ui/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:afs_mobile_flutter/constants/constants.dart';
import 'package:afs_mobile_flutter/ui/widgets/custom_shape.dart';
import 'package:afs_mobile_flutter/ui/widgets/responsive_ui.dart';
import 'signup.dart';
import 'package:http/http.dart' as http;

//import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String roleId = "";
  List<DropdownMenuItem<String>> get dropdownRoles {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Student"), value: "Student"),
      DropdownMenuItem(child: Text("Donor"), value: "Donor"),
    ];
    return menuItems;
  }

  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  late String email, password, role;

  bool isLoading = false;
  double _height = 0;
  double _width = 0;
  double _pixelRatio = 0;
  bool _large = true;
  bool _medium = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              clipShape(),
              welcomeTextRow(),
              signInTextRow(),
              form(),
              forgetPassTextRow(),
              SizedBox(height: _height / 12),
              button(),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : signUpTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height / 30
                  : (_medium ? _height / 25 : _height / 20)),
          child: Image.asset(
            'assets/images/login.png',
            height: _height / 3.5,
            width: _width / 3.5,
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Sign in to your account",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  late final spinkit;
  late final String hint;
  late final TextEditingController? textEditingController;
  late final TextInputType keyboardType;
  late final bool obscureText;
  late final IconData icon;

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            //roleTextFormField(),
            SizedBox(height: _height / 40.0),
            emailTextFormField(),
            SizedBox(height: _height / 40.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  String selectedValue = "Student";
  Widget roleTextFormField() {
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            DropdownButton(
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                hint: Text("Enter Role"),
                items: dropdownRoles),
          ]),
    );
  }

  Widget emailTextFormField() {
    return Container(
        child: TextFormField(
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        email = value; // get value from TextField
      },
      decoration: InputDecoration(
        icon: Icon(Icons.email),
        hintText: "Email ID",
      ),
    ));
  }

  Widget passwordTextFormField() {
    return Container(
      child: TextFormField(
        obscureText: true,
        onChanged: (value) {
          password = value; //get value from textField
        },
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
          hintText: "Password",
        ),
      ),
    );
  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              //print("Routing");
            },
            child: Text(
              "Recover",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.orange[200]),
            ),
          )
        ],
      ),
    );
  }

  final String url = '$server/users/role';
  // var storeRole = "";
  getUserData() async {
    var currentTok = await FirebaseAuth.instance.currentUser?.getIdToken();
    //print('saffar khan'+currentTok!);
    var response =
        await http.get(Uri.parse(url), headers: {'authorization': currentTok!});
    //storeRole = response as String;
    //print("Response Body"+response.body);
    return response.body;
  }

  Widget button() {
    // ignore: deprecated_member_use
    return
        // ignore: deprecated_member_use
        RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        if (isLoading) return;
        setState(() => isLoading = true);
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          isLoading = false;
        });

        try {
          final newUser = await _auth.signInWithEmailAndPassword(
              email: email, password: password);

          // ignore: unnecessary_null_comparison
          if (newUser != null) {
            final snackbar = SnackBar(
              content: Text('Login Successful'),
              action: SnackBarAction(
                label: 'continue',
                textColor: Colors.white,
                onPressed: () {},
              ),
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              backgroundColor: Colors.orange,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackbar);

            setState(() {
              showProgress = false;
            });
          }
          final String url = '$server/users/role';
          var currentTok =
              await FirebaseAuth.instance.currentUser?.getIdToken();
          var response = await http
              .get(Uri.parse(url), headers: {'authorization': currentTok!});
          var data = jsonDecode(response.body);
          print("data value " + data["role"].toString());

          //print(SignUpScreen());
          if (data["role"].toString() == "student") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardReceiver()),
            );
          } else if (data["role"].toString() == "donor") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardDonor()),
            );
          }
        } catch (e) {
          final snackbar = SnackBar(
            content: Text('Login Failed'),
            action: SnackBarAction(
              label: 'Try again',
              textColor: Colors.white,
              onPressed: () {},
            ),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Colors.orange,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange, Colors.pinkAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('SIGN IN',
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              // Navigator.of(context).pushNamed(signUp);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
              //print("Routing to Sign up screen");
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: _large ? 19 : (_medium ? 17 : 15)),
            ),
          )
        ],
      ),
    );
  }
}
