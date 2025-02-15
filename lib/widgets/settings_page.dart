import 'package:flutter/material.dart';

class SettingsPage2 extends StatefulWidget {
  const SettingsPage2({super.key});

  @override
  State<SettingsPage2> createState() => _SettingsPage2State();
}

class _SettingsPage2State extends State<SettingsPage2> {
  bool _isLight = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isLight ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          // title: const Text("Settings", style: TextStyle(color: Colors.grey)),
          // backgroundColor: const Color(0xFF171821),Set the background color to black
          title: const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              children: [
                _SingleSection(
                  title: "General",
                  children: [
                    _CustomListTile(
                      title: "Dark Mode",
                      icon: Icons.dark_mode_outlined,
                      trailing: Switch(
                        value: _isLight,
                        onChanged: (value) {
                          setState(() {
                            _isLight = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const _SingleSection(
                  title: "Organization",
                  children: [
                    // _CustomListTile(
                    // title: "Profile", icon: Icons.person_outline_rounded),
                    // _CustomListTile(
                    //     title: "Calling", icon: Icons.phone_outlined),
                  ],
                ),
                const Divider(),
                const _SingleSection(
                  children: [
                    _CustomListTile(
                      title: "Help & Feedback",
                      icon: Icons.help_outline_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;

  const _CustomListTile({
    required this.title,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.grey), // Ensure grey color for title
      ),
      leading: Icon(icon, color: Colors.grey), // Ensure grey color for icon
      trailing: trailing,
      onTap: () {},
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SingleSection({
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
