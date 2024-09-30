import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'result_screen.dart';

void main() {
  runApp(const MaterialApp(
    home: ControllerPage(),
  ));
}

class ControllerPage extends StatefulWidget {
  const ControllerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ControllerPageState createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  bool _isDeviceOn = false;

  void _toggleDevicePower() {
    setState(() {
      _isDeviceOn = !_isDeviceOn;
    });

    // Implement the logic for sending power on/off command to the remote device
    //print('Device power ${_isDeviceOn ? 'on' : 'off'}');
    // You can replace the print statement with actual command sending logic
  }

  void _onButtonPressed(String action) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(buttonText: action),
      ),
    );
  }
  // http://localhost:8080/all?page=3
  @override
  Widget build(BuildContext context) {
    // double buttonSize = MediaQuery.of(context).size.width * 0.25;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Database', style: TextStyle(fontWeight: FontWeight.bold)),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.grey),
        //   onPressed: () {
        //     Navigator.pop(context); // Navigating back to the previous page (menu page).
        //   },
        // ),
      ),
    );
  }

  Widget _buildButton(
    String iconPath,
    String label,
    void Function() onPressed,
    double buttonSize,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // ignore: deprecated_member_use
        backgroundColor: const Color(0xFF21222D),
        side: const BorderSide(color: Colors.white),
        minimumSize: Size(buttonSize, buttonSize),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            // ignore: deprecated_member_use
            color: Colors.white, // Apply color to the icon if needed
            width: 48, // Adjust the width of the SVG
            height: 48, // Adjust the height of the SVG
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14), // Use a modern font size
          ),
        ],
      ),
    );
  }
}
