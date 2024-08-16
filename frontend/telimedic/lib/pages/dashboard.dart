import 'package:flutter/material.dart';
import 'package:telemedic/components/dashboard_home.dart';
import 'package:telemedic/widgets/menu.dart';
import 'package:telemedic/utils/responsive.dart';
import 'package:telemedic/models/user.dart'; // Adjust import according to your project structure

class DashBoard extends StatelessWidget {
  final User user; // Add this line to accept the User object

  DashBoard({super.key, required this.user}); // Update the constructor

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: !Responsive.isDesktop(context)
          ? SizedBox(width: 250, child: Menu(scaffoldKey: _scaffoldKey))
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Menu(scaffoldKey: _scaffoldKey),
                ),
              ),
            Expanded(flex: 8, child: HomePage(scaffoldKey: _scaffoldKey, user: user)),
          ],
        ),
      ),
    );
  }
}
