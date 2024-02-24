import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import '../services/local_notification_service.dart';
import '../viewmodels/authorization_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AuthViewModel _authViewModel;
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeOutAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _fadeInAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _fadeOutAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(_controller);

    // Start fade-in animation
    _controller.forward();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    });
    checkLogin();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void checkLogin() async {
    String? token = await FirebaseMessaging.instance.getToken();

    await Future.delayed(Duration(seconds: 3));
    // check for user detail first
    try {
      await _authViewModel.checkLogin(token);
      if (_authViewModel.user == null) {
        await _navigateToLogin();
      } else {
        await _navigateToDashboard();
      }
    } catch (e) {
      await _navigateToLogin();
    }
  }

  Future<void> _navigateToLogin() async {
    // fade-out animation
    await _controller.reverse();
    Navigator.of(context).pushReplacementNamed("/login");
  }

  Future<void> _navigateToDashboard() async {
    // fade-out animation
    await _controller.reverse();
    NotificationService.display(
      title: "Welcome back",
      body:
      "Hello ${_authViewModel.loggedInUser?.name},\n We have been waiting for you.",
    );
    Navigator.of(context).pushReplacementNamed("/dashboard");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/furreverrfinds_logo.png",
                width: 350,
                height: 450,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
