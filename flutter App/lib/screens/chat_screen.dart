import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:query_cortex/utlis/api%20details/api_details.dart';
import 'package:query_cortex/utlis/common%20widgets/custom_button.dart';
import 'package:query_cortex/utlis/common%20widgets/dynamic_table.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

import '../colors.dart';
import '../utlis/common widgets/chat_bubble.dart';
import '../utlis/common widgets/custom_text_field.dart';
import '../utlis/common widgets/widget_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBotPage extends StatefulWidget {
  final String model;
  final String dbms;
  final String user;
  final String host;
  final String password;
  final String port;
  final String database;
  const ChatBotPage({super.key, required this.model, required this.dbms, required this.user, required this.host, required this.password, required this.port, required this.database});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  List chatbotResponse = [];
  bool _isLoading = false;
  bool _viewInsights = false;
  final ScrollController _scrollController = ScrollController();
  final speechToText = SpeechToText();
  String lastWords = "";
  TextEditingController textEditingController = TextEditingController();
  List<Map<String, dynamic>> chatHistory = [];

  @override
  void initState() {
    super.initState();
    fetchChatHistory();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> fetchChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? historyJson = prefs.getString('chat_history');
    if (historyJson != null) {
      List<dynamic> decodedJson = jsonDecode(historyJson);
      chatHistory = List<Map<String, dynamic>>.from(decodedJson);
      setState(() {});
    }
  }

  void clearSpecificPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    await prefs.clear();
    print("Cleared");
    setState(() {});
  }

  Future<void> saveChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_history', jsonEncode(chatHistory));
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      textEditingController.text = lastWords;
    });
  }

  Future<void> getInsights() async {
    print(DATA_VISUALIZATION_ROUTE);
    Uri url = Uri.parse(DATA_VISUALIZATION_ROUTE);

    final chatResponse = chatHistory[chatHistory.length - 1]["response"];

    String jsonBody = jsonEncode({"results": chatResponse["results"], "model": widget.model
    });

    setState(() {
      _isLoading = true;
      _viewInsights = false; // Reset at the beginning
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final chatBotData = jsonDecode(response.body);

      chatHistory.add({
        "nlp_query": "Generate Insights",
        "response": chatBotData,
      });

      await saveChatHistory();
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      setState(() {
        _isLoading = false;
        _viewInsights = false;
        textEditingController.clear();
      });
    } else {
      print("Error: ${response.statusCode}");
      setState(() {
        _isLoading = false;
        _viewInsights = false; // Hide insights if the request failed
      });
    }
  }

  Future<void> sendPromptToChatBot(String query) async {
    Uri url = Uri.parse(QUERY_ROUTE);
    print(QUERY_ROUTE);
    String jsonBody = jsonEncode({
      "query": query,
      "model": widget.model,
      "dbms": widget.dbms,
      "credentials": {
        "user": widget.user,
        "host": widget.host,
        "database": widget.database,
        "password": "Amey1234",
        "port": "5432"
      }
    });

    setState(() {
      _isLoading = true;
      _viewInsights = false; // Reset at the beginning
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final chatBotData = jsonDecode(response.body);

      chatHistory.add({
        "nlp_query": query,
        "response": chatBotData,
      });

      await saveChatHistory();
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      setState(() {
        _isLoading = false;
        _viewInsights = true; // Show insights after successful response
        textEditingController.clear();
      });
    } else {
      print("Error: ${response.statusCode}");
      setState(() {
        _isLoading = false;
        _viewInsights = false; // Hide insights if the request failed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonColor,
        scrolledUnderElevation: 0.0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.17,
        title: Column(
          children: [
            Align(
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/chatbot.png"),
                radius: MediaQuery.of(context).size.height * 0.055,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Query Cortex Chatbot",
              style: AppWidget.boldTextStyle().copyWith(
                fontSize: MediaQuery.of(context).size.height * 0.028,
                color: Colors.white,
              ),
            )
          ],
        ),
        leading: Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              clearSpecificPreference("chat_history");
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close, size: 30),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {

                },
                icon: const Icon(Icons.more_vert,
                    size: 35, color: Colors.white60),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: AssetImage("assets/images/chatWallpaper.jpg"),
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              Visibility(
                visible: _isLoading,
                child: LinearProgressIndicator(
                  color: appBarColor,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: chatHistory.length,
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: ChatBubble(
                            message: chatHistory[index]["nlp_query"]!,
                            isCurrentUser: true,
                            timestamp: '',
                          ),
                        ),
                        buildResponseFromChatbot(chatHistory[index]["response"]),
                      ],
                    );
                  },
                ),
              ),
              Visibility(
                  visible: _viewInsights,
                  child: CustomButton(
                      onTap: () async {
                        await getInsights();
                      },
                      text: "View Insights")),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20, bottom: 30, top: 10),
                      child: CustomTextField(
                        hintText: "Message",
                        icon: IconButton(
                          icon: Icon(Icons.mic),
                          onPressed: () async {
                            if (await speechToText.hasPermission &&
                                !speechToText.isListening) {
                              await startListening();
                            } else if (speechToText.isListening) {
                              await stopListening();
                            } else {
                              initSpeechToText();
                            }
                          },
                        ),
                        obscureText: false,
                        textEditingController: textEditingController,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 30,
                        ),
                        onPressed: () {
                          sendPromptToChatBot(textEditingController.text);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildResponseFromChatbot(response) {

    Widget responseBubble = Container();

    if (response["query"] != null && response["query"].isNotEmpty) {
      final queries = response["query"];

      final results = response["results"];

      responseBubble = Column(
        children: [
          for (int i = 0;i<queries.length;i++)
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ChatBubble(
                message: queries[i], // Directly use the sqlQuery variable
                isCurrentUser: false,
                timestamp: '',
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width /
                        1.3,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),

                  child: DynamicTable(data: results[i])),
            )
          ],
        ),

        ],
      );
    }

    if (response["image_urls"] != null && response["image_urls"].isNotEmpty) {
      final images_urls  = response["image_urls"];
      print(images_urls);


      responseBubble = Column(
        children: [
          for (int i=0;i<images_urls.length;i++)
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ChatBubble(
                    message: images_urls[i], // Directly use the sqlQuery variable
                    isCurrentUser: false,
                    timestamp: '',
                    isImage: true,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ChatBubble(
                    message: "", // Directly use the sqlQuery variable
                    isCurrentUser: false,
                    timestamp: '',
                    isInsight: true,
                    insights: response["response"][i]["Insights"]!,
                  ),
                ),
              ],
            ),
        ],
      );
    }

    return responseBubble;
  }
}
