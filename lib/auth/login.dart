import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/components/customTextFormField.dart';
import 'package:flutter_firebase/components/custombuttonauth.dart';
import 'package:flutter_firebase/components/customlogoauth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      isLoading = true;
      setState(() {
        
      });
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      
      await FirebaseAuth.instance.signInWithCredential(credential);
      
      isLoading = false;
      setState(() {
        
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushNamedAndRemoveUntil("homepage", (route) => false);
      
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Form(
                    key: formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Center(child: CustomLogoAuth()),
                        const SizedBox(height: 20),
                        const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Login To Continue Using The App",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        CustomTextForm(
                            hint: "Enter Your Email",
                            mycontroller: email,
                            validator: (val) {
                              if (val == "") {
                                return "Can't be Empty";
                              }
                            }),
                        const SizedBox(height: 10),
                        const Text(
                          "Password",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        CustomTextForm(
                            hint: "Enter Your Password",
                            mycontroller: password,
                            validator: (val) {
                              if (val == "") {
                                return "Can't be Empty";
                              }
                            }),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () async {
                              if (email.text == "") {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error ',
                                  desc:
                                      'الرجاء ادخال بريدك الالكترونى قبل الضفط على \n ForgetPassword',
                                  
                                ).show();
                                return;
                              }
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: email.text);

                                // ignore: use_build_context_synchronously
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  animType: AnimType.rightSlide,
                                  title: 'Success ',
                                  desc:
                                      'الرجاء التوجه على بريدك الالكترونى و الضغط على اللينك و تجديد كلمة المرور',
                                  
                                ).show();
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error ',
                                  desc:
                                      'الرجاء التأكد ان البريد الالكترونى الذى ادخلته صحيح ثم اعد المحاولة ',
                                  
                                ).show();
                              }
                            },
                            child: const Text(
                              "Forget Password ?",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButtonAuth(
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          try {
                            isLoading = true;
                            setState(() {});

                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email.text, password: password.text);

                            isLoading = false;
                            setState(() {});

                            if (credential.user!.emailVerified) {
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "homepage", (route) => false);
                            } else {
                              // ignore: use_build_context_synchronously
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error ',
                                desc:
                                    'الرجاء التوجه على بريدك الالكترونى و الضغط على لينك التحقق من البريد حتى يتم تفعيل حسابك',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              ).show();
                            }
                          } on FirebaseAuthException catch (e) {
                            
                            isLoading = false;
                            setState(() {});

                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                              // ignore: use_build_context_synchronously
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error User Not Found',
                                desc: 'No user found for that email.',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              ).show();
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              // ignore: use_build_context_synchronously
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error wrong-password',
                                desc: 'Wrong password provided for that user.',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              ).show();
                            }
                          }
                        } else {
                          print("Invalid");
                        }
                      },
                      title: "Login"),
                  Container(
                    height: 30,
                  ),
                  MaterialButton(
                    height: 50,
                    onPressed: () async {
                      await signInWithGoogle();
                    },
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.red,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Login with Google"),
                          Image.asset(
                            "images/Google.png",
                            width: 30,
                          ),
                        ]),
                  ),
                  Container(
                    height: 35,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("signup");
                    },
                    child: const Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                          text: "Don't Have An Account ?",
                        ),
                        TextSpan(
                            text: "Register",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange)),
                      ])),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
