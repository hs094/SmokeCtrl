import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chat';
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _chatHistory = [];

  void getAnswer(String prompt) async {
    String res = " **Physiological Effects of Prolonged Alcohol Consumption**\n The physiological effects of prolonged alcohol consumption can be devastating, leading to various physical and psychological problems.\n**Physiological Effects:**\n1.  **Cardiovascular Problems**: Regular heavy drinking can lead to heart disease, increased blood pressure, and cardiac arrhythmias.\n2.  **Hormonal Imbalance**: Chronic alcohol use can disrupt hormone levels, including estrogen, testosterone, and thyroid hormones.\n3.  **Neurological Issues**: Alcohol consumption has been linked to neurological problems such as seizures, stroke, and dementia.\n\n**Psychological Effects:**\n\n1.  **Depression**: Prolonged heavy drinking is a well-established risk factor for depression.\n2.  **Anxiety Disorders**: Chronic alcohol use can also contribute to the development of anxiety disorders, such as social anxiety disorder.\n3.  **Impulsivity and Aggression**: Alcohol consumption has been linked to increased impulsivity and aggression in individuals with antisocial personality disorder.\n\nIn conclusion, prolonged alcohol consumption can have severe physiological effects on both physical and mental health. It is essential for individuals who consume alcohol regularly to understand the potential risks and take steps to mitigate them.";
    // List to store the messages for the prompt
    List<Map<String, String>> msg = [
      {"content": prompt}
    ];

    // Add the chat history messages to the prompt
    for (var i = 0; i < _chatHistory.length; i++) {
      msg.add({"content": _chatHistory[i]["message"]});
    }

    // Create the request object
    Map<String, dynamic> request = {
      "prompt": {"messages": msg},
      "temperature": 0.25,
      "candidateCount": 1,
      "topP": 1,
      "topK": 1
    };

    setState(() {
      if (res.isNotEmpty) {
        _chatHistory.add({
          "time": DateTime.now(),
          "message": res,
          "isSender": true,
        });
        _chatController.clear();
      }
    });

    // Send the request to the Spring backend
    // final uri = Uri.parse("http://localhost:8080/chat");
    // final response = await http.post(uri, body: jsonEncode(request), headers: {"Content-Type": "application/json"});

    // if (kDebugMode) {
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    // }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    });
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
                                    getAnswer(message);

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
