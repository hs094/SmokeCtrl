import 'package:flutter/material.dart';
import 'package:telmed/utils/responsive.dart';
import 'package:telmed/main.dart';
import 'package:telmed/models/menu_modal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:telmed/widgets/history.dart';
import 'package:telmed/widgets/notifications.dart';
import 'package:telmed/widgets/settings_page.dart';
import 'package:telmed/pages/home.dart';
import 'controller_page.dart';

class Menu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const Menu({super.key, required this.scaffoldKey});

  @override
  _MenuState createState() => _MenuState();
}

//menu page widgets..
class _MenuState extends State<Menu> {
  List<MenuModel> menu = [
    MenuModel(icon: 'assets/svg/home_black.svg', title: "Dashboard"),
    MenuModel(icon: 'assets/svg/remote_grey.svg', title: "User Database"),
    MenuModel(icon: 'assets/svg/bell_grey.svg', title: "Notification"),
    MenuModel(icon: 'assets/svg/history_grey.svg', title: "History"),
    MenuModel(icon: 'assets/svg/setting_grey.svg', title: "Settings"),
    MenuModel(icon: 'assets/svg/logout_grey.svg', title: "Sign Out"),
  ];

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.grey[800]!,
              width: 1,
            ),
          ),
          color: const Color(0xFF171821)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: Responsive.isMobile(context) ? 40 : 80,
            ),
            for (var i = 0; i < menu.length; i++)
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                  color: selected == i
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selected = i;
                    });
                    widget.scaffoldKey.currentState!.closeDrawer();

                    // Navigate to the corresponding page
                    switch (i) {
                      case 0: // Dashboard
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const MyApp()),
                        );
                        break;
                      case 1: // Controller
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ControllerPage()),
                        );
                        break;
                      // Add similar cases for other menu items
                      case 2: //Notification
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const NotificationPage()),
                        );
                        break;
                      case 3: //History
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const HistoryPage()),
                        );
                        break;
                      case 4: //Settings
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage2()),
                        );
                        break;
                      case 5: //Exit
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                    }
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 7),
                        child: SvgPicture.asset(
                          menu[i].icon,
                          // color: selected == i ? Colors.black : Colors.grey,
                        ),
                      ),
                      Text(
                        menu[i].title,
                        style: TextStyle(
                          fontSize: 16,
                          color: selected == i ? Colors.black : Colors.grey,
                          fontWeight: selected == i
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        )),
      ),
    );
  }
}
