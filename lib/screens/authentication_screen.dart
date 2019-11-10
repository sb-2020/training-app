import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AuthenticationScreen extends StatelessWidget {
  static const RouteName = '/auth';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(100, 110, 235, 1).withOpacity(0.5),
                  Color.fromRGBO(125, 200, 255, 1).withOpacity(0.7)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1]),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1, child: AuthCard())
              ],
            ),
          ),
        )
      ],
    ));
  }
}

class AuthCard extends StatefulWidget {
  AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _authFormKey = GlobalKey();
  Map<String, String> _authData = {
    'phone': '',
    'password': '',
  };
  var _isLoading = false;

  Future<void> _submit() async {
    print("login button clicked");
    if (!_authFormKey.currentState.validate()) {
      print("validation failed");
      return;
    }
    print("validation passed");
    _authFormKey.currentState.save();
    print(_authData);
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false)
          .login(_authData["phone"], _authData["password"]);
    } catch (error) {
      print(error);
      _showErrorDialog("Authentication failed");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("An error occurred"),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text("Okay"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Container(
        height: 260,
        constraints: BoxConstraints(minHeight: 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _authFormKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Mobile number"),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    var urlPattern = r"[0-9]{10}";

                    if ((value.length != 10) ||
                        !RegExp(urlPattern).hasMatch(value)) {
                      return "Mobile number is not valid";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _authData["phone"] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (value) {
                    //INTEGRATION TO DO: Do any validatity checks here
                    //after passwords are enabled in the backend.
                    return null;
                  },
                  onSaved: (value) {
                    _authData["password"] = value;
                  },
                ),
                SizedBox(height: 20),
                _isLoading == true
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        child: Text("Login"),
                        onPressed: _submit,
                        color: Theme.of(context).accentColor,
                        elevation: 16.0,
                        padding: EdgeInsets.all(10.0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
