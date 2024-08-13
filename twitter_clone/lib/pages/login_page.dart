import "package:flutter/material.dart";
import "package:twitter_clone/components/my_button.dart";
import "package:twitter_clone/components/my_loading_circle.dart";
import "package:twitter_clone/components/my_text_field.dart";
import "package:twitter_clone/services/auth/auth_service.dart";

/* 

LOGIN PAGE

On this page, an existing user can log in with their:

- email
- password 

--------------------------------------------------------------------------------

Once the user successfully logs in, they will be redirected to the home page.

If the user doesn't have an account yet, they can go to the register page from here.


*/

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //access auth service
  final _auth = AuthService();

  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  // login method
  void login() async {
    // show loading circle
    showLoadingCircle(context);

    // attempt login
    try {
      // trying to login...
      await _auth.loginEmailPassword(emailController.text, pwController.text);

      // finished loading...
      if (mounted) hideLoadingCircle(context);
    }

    // catch any error..
    catch (e) {
      // finished loading...
      if (mounted) hideLoadingCircle(context);

      // let user know there was an error
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // Scaffold
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // Body
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),

                //Logo
                Icon(
                  Icons.lock_open_rounded,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(
                  height: 50,
                ),
                // Welcome back message
                Text(
                  "Welcome back, you\'ve been missed!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: "Enter email",
                  obscureText: false,
                ),

                const SizedBox(
                  height: 10,
                ),
                // password textfield
                MyTextField(
                  controller: pwController,
                  hintText: "Enter password",
                  obscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                // forgot password?
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                // sign in button
                MyButton(
                  text: "Login",
                  onTap: login,
                ),
                const SizedBox(
                  height: 50,
                ),
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),

                    const SizedBox(
                      width: 5,
                    ),

                    // user can tap this to go to register page
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
