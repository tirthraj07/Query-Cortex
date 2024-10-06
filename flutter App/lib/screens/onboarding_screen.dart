import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors.dart';
import '../utlis/common widgets/custom_text_field.dart';
import '../utlis/common widgets/widget_support.dart';
import 'chat_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  TextEditingController userController = TextEditingController();
  TextEditingController dbmsController = TextEditingController();
  TextEditingController hostController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController databaseController = TextEditingController();

  bool isWorqhatSelected = false;
  bool isGeminiSelected = false;

  void signUp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTimeUser', false);
    var model = "";

    if(isWorqhatSelected)
      model = "gemini";
    else
      model = "gemini";

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChatBotPage(
                model: model,
                dbms: dbmsController.text,
                user: userController.text,
                host: hostController.text,
                password: passwordController.text,
                port: portController.text,
                database: databaseController.text,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://wallpapers.com/images/hd/database-info-exchange-03ghlfed30kkhvnj.jpg"),
                          fit: BoxFit.cover))),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Text(""),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image.asset("assets/images/logo.png",
                    //     width: MediaQuery.of(context).size.width/1.3),

                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      margin: EdgeInsets.only(top: 30),
                      alignment: Alignment.center,
                      child: Text(
                        "",
                        style: AppWidget.headlineTextStyle()
                            .copyWith(fontSize: 30),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(20),
                        height: 600,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Query Cortex",
                                  style: AppWidget.headlineTextStyle(),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: CustomTextField(
                                      hintText: "User",
                                      icon: Icon(Icons.person_outline),
                                      obscureText: false,
                                      textEditingController: userController,
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: CustomTextField(
                                      hintText: "Host",
                                      icon: Icon(Icons.public),
                                      obscureText: false,
                                      textEditingController: hostController,
                                    )),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: CustomTextField(
                                      hintText: "dbms",
                                      icon: Icon(Icons.storage),
                                      obscureText: false,
                                      textEditingController: dbmsController,
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: CustomTextField(
                                      hintText: "port",
                                      icon: Icon(Icons.router),
                                      obscureText: false,
                                      textEditingController: portController,
                                    )),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                CustomTextField(
                                  hintText: "Password",
                                  icon: Icon(Icons.lock_outlined),
                                  obscureText: true,
                                  textEditingController: passwordController,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                CustomTextField(
                                  hintText: "Database",
                                  icon: Icon(Icons.data_usage),
                                  obscureText: false,
                                  textEditingController: databaseController,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Select Model",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isGeminiSelected =
                                              true; // Select Gemini
                                          isWorqhatSelected =
                                              false; // Unselect Worqhat
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        decoration: BoxDecoration(
                                          color: isGeminiSelected
                                              ? Color.fromRGBO(231, 215, 245, 1)
                                              : Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isGeminiSelected
                                                ? Colors.deepPurple
                                                : Colors.black54,
                                            width: isGeminiSelected ? 3.0 : 2.0,
                                          ),
                                          boxShadow: isGeminiSelected
                                              ? [
                                                  BoxShadow(
                                                    color: Colors
                                                        .deepPurpleAccent
                                                        .withOpacity(0.6),
                                                    blurRadius: 15.0,
                                                    spreadRadius: 2.0,
                                                    offset: Offset(0,
                                                        4), // Glow effect when selected
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        height: 65,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isGeminiSelected =
                                                  true; // Select Gemini
                                              isWorqhatSelected =
                                                  false; // Unselect Worqhat
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image(
                                              image: AssetImage(
                                                  "assets/images/Gemini Image.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isWorqhatSelected =
                                              true; // Select Worqhat
                                          isGeminiSelected =
                                              false; // Unselect Gemini
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        decoration: BoxDecoration(
                                          color: isWorqhatSelected
                                              ? Color.fromRGBO(231, 215, 245, 1)
                                              : Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isWorqhatSelected
                                                ? Colors.deepPurple
                                                : Colors.black54,
                                            width:
                                                isWorqhatSelected ? 3.0 : 2.0,
                                          ),
                                          boxShadow: isWorqhatSelected
                                              ? [
                                                  BoxShadow(
                                                    color: Colors
                                                        .deepPurpleAccent
                                                        .withOpacity(0.6),
                                                    blurRadius: 15.0,
                                                    spreadRadius: 2.0,
                                                    offset: Offset(0,
                                                        4), // Glow effect when selected
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        height: 65,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isWorqhatSelected =
                                                  true; // Select Worqhat
                                              isGeminiSelected =
                                                  false; // Unselect Gemini
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Image(
                                              image: AssetImage(
                                                  "assets/images/WorqHat_TM_Logo-removebg-preview.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                onTap: signUp,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 70, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: appBarColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    "Start Chat",
                                    style: AppWidget.boldTextStyle().copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 100,
                    ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            "Use Saved Credentials !",
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          GestureDetector(
                              onTap: () {},
                              child: Text("  Forget Me",
                                  style: TextStyle(
                                      fontSize: 18, color: appBarColor))),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
