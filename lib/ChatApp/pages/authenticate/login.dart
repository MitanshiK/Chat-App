import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/helpers/ui_helper.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:proj/ChatApp/pages/home_page.dart';
import 'package:proj/ChatApp/pages/authenticate/sign_in.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final loginKey = GlobalKey<FormState>();
  bool obscure = true; // visibility of password
  String password = "";
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const SizedBox(
                height: 40,
              ),
              const Image(
                image: AssetImage("assets/chat.png"),
                height: 150,
                width: 150,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Chat App",
                style: TextStyle(
                  fontFamily:"EuclidCircularB",
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 239, 125, 116)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 3,
              ),
              const Text(
                "Login to your Chat App Account ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600    ,fontFamily:"EuclidCircularB"),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                  key: loginKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(fontFamily:"EuclidCircularB"),
                        decoration: const InputDecoration(
                            label: Text("Email Id",style: TextStyle(fontFamily:"EuclidCircularB")),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value.toString().trim() == "") {
                            return "empty field";
                          }
                          else
                         { return null;}
                        },
                        onSaved: (value) {
                          setState(() {
                            email = value!;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: const TextStyle(fontFamily:"EuclidCircularB"),
                          obscureText: obscure,
                          decoration: InputDecoration(
                              suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscure = !obscure;
                                  });
                                },
                                child: Image(
                                  image: AssetImage((obscure == true)
                                      ? "assets/eyebrow.png"
                                      : "assets/visibility.png"),
                                  width: 25,
                                  height: 20,
                                ),
                              ),
                              label: const Text("Password" ,style: TextStyle(fontFamily:"EuclidCircularB")),
                              border: const OutlineInputBorder()),
                          validator: (value) {
                            if (value.toString().trim() == "") {
                              return "empty field";
                            }
                            else
                            {return null;}
                          },
                          onSaved: (value) {
                            setState(() {
                              password = value!;
                            });
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: TextButton(
                            onPressed: () {
                              loginKey.currentState!.save();
                              if (loginKey.currentState!.validate()) {
                                loginFun();
                              }
                            },
                            style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(
                                    EdgeInsets.all(10)),
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                                backgroundColor: const WidgetStatePropertyAll(
                                    Color.fromARGB(255, 240, 217, 148))),
                            child: const Text(
                              "Log In ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily:"EuclidCircularB",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )),
                      ),
                    ],
                  )),
              // const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account ?",
                    style: TextStyle(
                      fontFamily:"EuclidCircularB",
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInPage()));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontFamily:"EuclidCircularB",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 239, 144, 138)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginFun() async {
    auth.UserCredential? userCredential;
    UiHelper.loadingDialogFun(context,"logging In...");
    try {
      userCredential = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on auth.FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Could Not Login :$e" ,style: const TextStyle(fontFamily:"EuclidCircularB"))));

      debugPrint("login exception $e");
    }
    if (userCredential != null) {
      final userId = userCredential.user!.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection("ChatAppUsers")
          .doc(userId)
          .get();
      UserModel userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: ((context) => HomePage(
                    firebaseUser: userCredential!.user!,
                    userModel: userModel,
                  ))
                )
              );
    }
  }
}
