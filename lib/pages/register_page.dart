import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning/components/forms/my_textfield.dart';
import 'package:learning/components/micro/my_button.dart';
import 'package:learning/components/micro/square_tile.dart';
import 'package:learning/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    //menampilkan loading
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // mencoba login
    try {
      // cek password sesuai
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        // menampilkan pesan error
        Navigator.pop(context);
        showErrorMessage("Password don't match!");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                //logo
                const Icon(
                  Icons.lock,
                  size: 50,
                ),
                const SizedBox(
                  height: 30,
                ),
                //welcome back you've been missed!
                Text(
                  'Let\'s create an account for you!',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(height: 25),
                //email text scaffold
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                //passwro
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  textInputType: TextInputType.text,
                ),
                //forgot password

                const SizedBox(height: 25),
                MyButton(onTap: signUserUp, text: "Sign Up"),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Text(
                          'Or Continue With',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      imagePath: 'lib/images/g.png',
                      onTap: () => AuthService().signInWithGoogle(),
                    ),
                    const SizedBox(width: 20),
                    SquareTile(
                      imagePath: "lib/images/a.png",
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login Now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
          // signin button

          // or continue with

          // google_apple signin button

          // not a member? register now
          ),
    );
  }
}
