import 'dart:convert';
import 'package:telmed/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chat';
  
  final User user;

  const ChatPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _chatHistory = [];
  late User user;

  @override
  void initState() {
    super.initState();
    user = widget.user; // Initialize the user from the widget
  }


Future<void> getAnswer(String userid, String prompt) async {
  final uri = Uri.parse("http://10.5.29.253:8000/inference/");
  final requestBody = jsonEncode({
    "prompt": prompt,
    "max_tokens": 128,
    "temperature": 0.3,
    "top_p": 0.95,
    "top_k": 40
  });

  try {
    final response = await http.post(
      uri,
      body: requestBody,
      headers: {"Content-Type": "application/json"},
    );

    String responseBody = response.body;
    Map<String, dynamic>? jsonData;

    if (response.statusCode == 307) {
      // Handle Redirect
      final redirectedUri = response.headers['location'];
      if (redirectedUri != null) {
        final newResponse = await http.post(
          Uri.parse(redirectedUri),
          body: requestBody,
          headers: {"Content-Type": "application/json"},
        );

        responseBody = newResponse.body;
      }
    }


    // Parse JSON response
    try {
      jsonData = jsonDecode(responseBody);
    } catch (e) {
      print('JSON Parsing Error: $e');
      return;
    }

    if (jsonData != null && jsonData.containsKey('generated_text')) {
      String markdownMessage = jsonData['generated_text'].trim(); // Trim whitespace

      if (markdownMessage.isNotEmpty) {
        // Ensure this is inside a StatefulWidget
        if (mounted) {
          setState(() {
            _chatHistory.add({
              "time": DateTime.now(),
              "message": markdownMessage, // Store the markdown-formatted message
              "isSender": false,
            });
          });

          // Ensure scrolling only if there is enough content
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            }
          });
        }
      } else {
        print("Warning: Empty response received.");
      }
    } else {
      print("Error: 'generated_text' key not found in response.");
    }
  } catch (e) {
    print('Exception: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          title: const Text("ChatMEDiX",
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: Stack(
          children: [
            // Chat history list view
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: ListView.builder(
                itemCount: _chatHistory.length,
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Align(
                      alignment: (_chatHistory[index]["isSender"]
                          ? Alignment.topRight
                          : Alignment.topLeft),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: (_chatHistory[index]["isSender"]
                              ? const Color(0xFFF69170)
                              : Colors.white),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _chatHistory[index]["message"],
                          style: TextStyle(
                            fontSize: 15,
                            color: _chatHistory[index]["isSender"]
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Chat input area
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          decoration: const BoxDecoration(
                            border: GradientBoxBorder(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.grey,
                                  Colors.grey,
                                ],
                              ),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 50.0),
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: "Type a message . . . .",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(8.0),
                                  ),
                                  controller: _chatController,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: MaterialButton(
                                  minWidth: 50.0,
                                  height: 45.0,
                                  onPressed: () {
                                    // Storing the text to send it to getAnswer before clearing
                                    String message = _chatController.text;

                                    setState(() {
                                      if (message.isNotEmpty) {
                                        _chatHistory.add({
                                          "time": DateTime.now(),
                                          "message": message,
                                          "isSender": true,
                                        });
                                        _chatController.clear();
                                      }
                                    });

                                    // Make sure to call getAnswer after clearing the chat controller
                                    getAnswer(user.userid , message);

                                    // // Ensuring scrolling happens after the UI is updated
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _scrollController.jumpTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                      );
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  padding: const EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.black,
                                          Colors.black,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)),
                                    ),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          minWidth: 50.0, minHeight: 45.0),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.arrow_upward_sharp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientBoxBorder extends BoxBorder {
  final Gradient gradient;
  final double width;

  const GradientBoxBorder({
    required this.gradient,
    this.width = 1.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRect(Rect.fromLTWH(
        rect.left + width / 2,
        rect.top + width / 2,
        rect.width - width,
        rect.height - width,
      ));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  ShapeBorder scale(double t) {
    return GradientBoxBorder(
      gradient: gradient,
      width: width * t,
    );
  }

  @override
  bool get isUniform => true;

  @override
  // TODO: implement bottom
  BorderSide get bottom => throw UnimplementedError();

  @override
  /* TODO: implement top */
  BorderSide get top => throw UnimplementedError();

  @override
  void paint(Canvas canvas, Rect rect,
      {TextDirection? textDirection,
      BoxShape shape = BoxShape.rectangle,
      BorderRadius? borderRadius}) {
    {
      final Paint paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width;

      if (shape == BoxShape.rectangle) {
        final RRect rRect = borderRadius != null
            ? RRect.fromRectAndCorners(
                rect,
                topLeft: borderRadius.topLeft,
                topRight: borderRadius.topRight,
                bottomLeft: borderRadius.bottomLeft,
                bottomRight: borderRadius.bottomRight,
              )
            : RRect.fromRectXY(rect, 0, 0);

        canvas.drawRRect(rRect, paint);
      } else {
        canvas.drawOval(rect, paint);
      }
    }
  }
}
