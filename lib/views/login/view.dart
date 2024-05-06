import 'package:flutter/material.dart';
import 'package:day_planner/connections/connections.dart';
import 'package:day_planner/models/models.dart';
import 'package:day_planner/utils/utils.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:objectid/objectid.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  // this is so we can easily call the route
  // to this component from other files
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final EncryptedLocallyStoredDataModel _storedData = EncryptedLocallyStoredDataModel();
  bool _showPassword = false;
  bool _loading = true;

  /// if the user is trying to sign up
  bool _signUp = false;

  Future<void> _handleLoadData() async {
    final success = await _storedData.loadFromStorage();

    if (!success) {
      // safely check if context exists
      if (mounted) showMessage(context, "Could not get login info", error: true);

      setState(() {
        _loading = false;
      });

      return;
    }

    final user = await UserModel.getLoggedInUser();

    if (user == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    if (mounted) Navigator.pushReplacementNamed(context, "/baskets");
  }

  @override
  void initState() {
    super.initState();

    _handleLoadData();
  }

  Future<void> _handleLogin() async {
    if (_email.text.trim().isEmpty) {
      showMessage(context, "Email should not be empty", error: true);
      return;
    }

    if (_password.text.trim().isEmpty) {
      showMessage(context, "Password should not be empty", error: true);
      return;
    }

    if (MongoDB.db == null) {
      showMessage(context, "Database connection issue... Are you online?", error: true);
      return;
    }

    final conn = MongoDB.db?.collection(UserModel.collectionName);

    // todo will be encrypted password in the future
    final existingUser = await conn?.findOne({
      "email": _email.text,
      "password": _password.text,
    });

    // make context safe after async
    if (!mounted) return;

    if (existingUser == null) {
      showMessage(context, "Email or password is incorrect", error: true);
      return;
    }

    showMessage(context, "Login success!");

    final user = UserModel.fromJson(existingUser);

    final loginToken = ObjectId().hexString;

    if (user.id == null) {
      return;
    }

    conn?.updateOne({
      "_id": mongo.ObjectId.parse(user.id!)
    }, {
      r"$set": {
        "loginToken": loginToken,
      }
    });

    setState(() {
      _storedData.loginToken = loginToken;
    });

    await _storedData.saveToStorage();

    if (mounted) Navigator.pushReplacementNamed(context, "/baskets");
  }

  Future<void> _handleSignUp() async {
    if (_email.text.trim().isEmpty) {
      showMessage(context, "Email should not be empty", error: true);
      return;
    }

    // todo better checking - maybe use regex
    if (_email.text.indexOf("@", 1) == -1 || _email.text.indexOf("@", 2) == -1) {
      showMessage(context, "Email is invalid");
      return;
    }

    if (_password.text.trim().isEmpty) {
      showMessage(context, "Password should not be empty", error: true);
      return;
    }

    if (_password.text.contains(" ")) {
      showMessage(context, "Password should not contain spaces", error: true);
      return;
    }

    if (_password.text.trim().length < 4) {
      showMessage(context, "Password is too short", error: true);
      return;
    }

    if (_userName.text.trim().length < 3) {
      showMessage(context, "Name is too short", error: true);
      return;
    }

    if (MongoDB.db == null) {
      showMessage(context, "Database connection issue... Are you online?", error: true);
      return;
    }

    final conn = MongoDB.db?.collection(UserModel.collectionName);

    final existingUser = await conn?.findOne({
      "email": _email.text,
    });

    // make context safe after async
    if (!mounted) return;

    if (existingUser != null) {
      showMessage(context, "User with this email already exists", error: true);
      return;
    }

    final loginToken = ObjectId().hexString;
    final newUser = UserModel(
      name: _userName.text,
      email: _email.text,
      password: _password.text,
      createdAt: DateTime.now(),
      loginToken: loginToken,
    );

    final res = await conn?.insertOne(newUser.toJson());

    if (!mounted) return;

    if (res == null) {
      showMessage(context, "Signup Failed", error: true);
      return;
    }

    showMessage(context, "Signup Success!");

    setState(() {
      _storedData.loginToken = loginToken;
    });

    await _storedData.saveToStorage();

    if (mounted) Navigator.pushReplacementNamed(context, "/baskets");
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text("Login"),
            _signUp
                ? TextField(
                    controller: _userName,
                    decoration: const InputDecoration(hintText: 'Your Name'),
                  )
                : Container(),
            TextField(
              controller: _email,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            TextField(
              controller: _password,
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: TextButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  child: Icon(
                    _showPassword ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                  ),
                ),
              ),
              obscureText: !_showPassword,
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  _loading = false;
                });

                if (_signUp) {
                  await _handleSignUp();
                } else {
                  await _handleLogin();
                }

                setState(() {
                  _loading = false;
                });
              },
              child: Text(_signUp ? "Sign Up" : "Log in"),
            ),
            const Divider(),
            Text(_signUp ? "Already have an account?" : "Don't have an account?"),
            TextButton(
              onPressed: () {
                setState(() {
                  _signUp = !_signUp;
                });
              },
              child: Text(_signUp ? "Log in" : "Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
