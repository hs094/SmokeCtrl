import 'package:flutter/material.dart';
import 'package:telmed/components/dashboard_home.dart';
import 'package:telmed/widgets/menu.dart';
import 'package:telmed/utils/responsive.dart';
import 'package:telmed/models/user.dart'; // Adjust import according to your project structure

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
                    child: Row(children: <Widget>[
                      Menu(scaffoldKey: _scaffoldKey),
                      CircleAvatar(
                        backgroundColor: Colors.brown.shade800,
                        child: const Text('AH'),
                      )
                    ])),
              ),
            Expanded(
                flex: 8,
                child: DashHomePage(scaffoldKey: _scaffoldKey, user: user)),
          ],
        ),
      ),
    );
  }
}
