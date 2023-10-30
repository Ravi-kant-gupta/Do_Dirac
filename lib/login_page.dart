import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';
import 'package:another_flushbar/flushbar.dart';
import 'purchaseApp/home_page.dart' show HomeScreen;
import './exit_app.dart';
import 'junction_file.dart';

class Items {
  Items({
    this.token,
    this.uid,
    this.image,
    this.name,
    this.premium,
    this.result,
  });

  String? token;
  int? uid;
  String? image;
  String? name;
  bool? premium;
  String? result;

  factory Items.fromJson(Map<String, dynamic> json) => Items(
        token: json["token"],
        uid: json["uid"],
        image: json["image"],
        name: json["name"],
        premium: json["premium"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "uid": uid,
        "image": image,
        "name": name,
        "premium": premium,
        "result": result,
      };
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Items? responseBodyData;
  String url = "";
  String textfieldinitialurl = "";
  String email = "";
  String password = "";
  bool isLoading = true;
  String? token;
  bool hidePassword = true;
  bool showUrlField = false;

  @override
  void initState() {
    super.initState();
    initialUrl();
  }

  initialUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('url');
    if (data != null && data.isNotEmpty) {
      textfieldinitialurl = data;
      url = data;
      showUrlField = true;
    } else {
      showUrlField = true;
      textfieldinitialurl = "";
    }
    setState(() {});
  }

  void toggle() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  final formKey = GlobalKey<FormState>();

  void formSubmit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = false;
      });
      String apiUrl = 'http://$url/json-call/user_authenticate';

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "jsonrpc": "2.0",
            "params": {
              "app_type": "purchase",
              "login": email,
              "password": password,
            }
          }),
        );

        final body = response.body;
        final responseBody = jsonDecode(body);
        responseBodyData = Items.fromJson(responseBody['result']);
        if (responseBodyData!.result == "Success") {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseBodyData!.token.toString());
          await prefs.setInt('uid', responseBodyData!.uid!.toInt());
          await prefs.setString('image', responseBodyData!.image.toString());
          await prefs.setString('name', responseBodyData!.name.toString());
          await prefs.setBool('premium', responseBodyData!.premium!);
          await prefs.setString('url', url!.toString());
          await prefs.setString('result', responseBodyData!.result.toString());

          token = prefs.getString('token');

          if (token != null) {
            Future.delayed(
                const Duration(seconds: 0),
                () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SelectViewPage())));
          } else {
            setState(() {
              isLoading = true;
            });
            throw responseBody["result"]["error"];
          }
        } else {
          setState(() {
            isLoading = true;
          });
          throw responseBody["result"]["error"];
        }
      } catch (error) {
        setState(() {
          isLoading = true;
        });
        Flushbar(
          message: error.toString(),
          backgroundColor: Colors.black,
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          borderRadius: BorderRadius.circular(5),
          duration: const Duration(milliseconds: 1100),
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ),
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return showUrlField == false
        ? const Scaffold(
            backgroundColor: Color(0xffe6f7fd),
            body: Center(child: CircularProgressIndicator()),
          )
        : WillPopScope(
            onWillPop: () => ExitAppAlert(context),
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: const Color(0xffe6f7fd),
                body: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const Image(
                          image: AssetImage("assets/logo.png"),
                          width: 60,
                          height: 60,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 0, 12),
                        child: Text(
                          "DO DIRAC",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w900),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: Text(
                          "Please Sign in to continue",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Container(
                                padding: const EdgeInsets.all(30),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                child: Form(
                                    key: formKey,
                                    child: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(9),
                                        child: TextFormField(
                                          initialValue:
                                              "${textfieldinitialurl}",
                                          cursorColor: Colors.black,
                                          cursorWidth: 1,
                                          decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.person_search_outlined,
                                              size: 20,
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            labelText: 'URL',
                                            labelStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                            fillColor: Colors.black,
                                          ),
                                          validator: (value1) {
                                            if (value1!.isEmpty) {
                                              return "Enter Correct URL";
                                            } else {
                                              return null;
                                            }
                                          },
                                          onChanged: (url) =>
                                              {setState(() => this.url = url)},
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(9),
                                        child: TextFormField(
                                          cursorColor: Colors.black,
                                          cursorWidth: 1,
                                          decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.mail,
                                              size: 20,
                                            ),
                                            labelText: 'Email',
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            labelStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                            fillColor: Colors.black,
                                          ),
                                          validator: (value2) {
                                            if (value2!.isEmpty) {
                                              return "Enter Correct Email";
                                            } else {
                                              return null;
                                            }
                                          },
                                          onChanged: (email) => {
                                            setState(() => this.email = email)
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(9),
                                        child: TextFormField(
                                          cursorColor: Colors.black,
                                          cursorWidth: 1,
                                          obscureText: hidePassword,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.key,
                                              size: 20,
                                            ),
                                            labelText: 'Password',
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            labelStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                            fillColor: Colors.black,
                                            suffixIcon: InkWell(
                                              onTap: toggle,
                                              child: Icon(
                                                hidePassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                size: 15.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Enter Correct Password";
                                            } else {
                                              return null;
                                            }
                                          },
                                          onChanged: (password) => {
                                            setState(
                                                () => this.password = password)
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: formSubmit,
                                          child: isLoading
                                              ? const Text(
                                                  "Login",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                )
                                              : const CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF3498CC),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                      )
                                    ])))),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(
                              0,
                              20,
                              0,
                              5,
                            ),
                            child: Text(
                              "By login in you are agree with our",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                child: Link(
                                    target: LinkTarget.blank,
                                    uri: Uri.parse(
                                        'https://www.diracerp.com/terms.php'),
                                    builder: (context, FollowLink) {
                                      return GestureDetector(
                                        onTap: FollowLink,
                                        child: new Text(
                                          'Terms & Conditions',
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }),
                              ),
                              Text(" and ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  )),
                              Link(
                                  target: LinkTarget.blank,
                                  uri: Uri.parse(
                                      'https://www.diracerp.com/privecy.php'),
                                  builder: (context, FollowLink) {
                                    return GestureDetector(
                                      onTap: FollowLink,
                                      child: new Text(
                                        'Privacy Policy',
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 3),
                            child: Text(
                              "Copyright ©DiracERP Solution Pvt.Ltd.",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 3, 0, 10),
                            child: Link(
                                target: LinkTarget.blank,
                                uri: Uri.parse('https://www.diracerp.com/'),
                                builder: (context, FollowLink) {
                                  return GestureDetector(
                                    onTap: FollowLink,
                                    child: new Text(
                                      'visit: www.diracerp.com',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          );
  }
}
