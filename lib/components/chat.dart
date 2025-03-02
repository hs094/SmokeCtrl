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
  final FocusNode _focusNode = FocusNode();
  final List<Map<String, dynamic>> _chatHistory = [];
  bool useRAG = false; // Toggle for RAG
  late User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }


Future<void> getAnswer(String userid, String prompt) async {
  final String endpoint = useRAG ? "/rag/inference/" : "/inference/";
  final uri = Uri.parse("http://10.5.29.253:8000$endpoint");
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
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Row(
            children: [
              const Text("Use RAG", style: TextStyle(fontSize: 16)),
              Switch(
                value: useRAG,
                onChanged: (value) {
                  setState(() {
                    useRAG = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 45,
                          maxHeight: 150, // Expandable input
                        ),
                        child: TextField(
                          controller: _chatController,
                          focusNode: _focusNode,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: "Type a message...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: () {
                      String message = _chatController.text.trim();

                      if (message.isNotEmpty) {
                        setState(() {
                          _chatHistory.add({
                            "time": DateTime.now(),
                            "message": message,
                            "isSender": true,
                          });
                          _chatController.clear();
                        });

                        getAnswer(user.userid, message);

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_scrollController.hasClients) {
                            _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent);
                          }
                        });
                      }
                    },
                    backgroundColor: Colors.black,
                    child: const Icon(Icons.arrow_upward, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
