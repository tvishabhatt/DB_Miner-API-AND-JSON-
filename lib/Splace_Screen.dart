import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:db_miner_pr7/Databasehelper.dart';
import 'package:db_miner_pr7/DeshaBord_Screen.dart';
import 'package:db_miner_pr7/QuotesApi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splace_Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Splace_ScreenState();
  }
}

class Splace_ScreenState extends State<Splace_Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),);
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),);
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1.0), // Delay the text fade animation
      ),);

    Future.delayed(Duration(seconds: 1), () {
      _animationController.forward();
    });

    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>DeshaBord_Screen()));

    },);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: Opacity(
                                opacity: _fadeAnimation.value,
                                child: Image(
                                  image: AssetImage(
                             "assets/sp.jpg"),
                                  height: 200,
                                ))));
                  })),
          SizedBox(
            height: 20,
          ),
          FadeTransition(
            opacity: _textFadeAnimation,
            child: Text(
              "Motivation",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,

              ),
            ),
          ),

        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
