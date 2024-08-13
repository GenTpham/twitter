import 'package:flutter/material.dart';
import 'package:twitter_clone/components/my_button.dart';
import 'package:twitter_clone/components/my_loading_circle.dart';
import 'package:twitter_clone/components/my_text_field.dart';
import 'package:twitter_clone/services/auth/auth_service.dart';
import 'package:twitter_clone/services/database/database_service.dart';

/*

REGISTER PAGE

On this page, a new user can fill out the form and create an account.

The data we want from the user is:

- name
- email
- password
- confirm password

--------------------------------------------------------------------------------

Once the user successfully creates an account -> they will be redirected to
home page.

Also, if user already has an account, they can go to login page from here.


*/

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // access auth and db service
  final _auth = AuthService();
  final _db = DatabaseService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  // register button tapped
  void register() async {
    // password match -> create user
    if (pwController.text == confirmPwController.text) {
      // show loading circle
      showLoadingCircle(context);

      // attempt to register new user
      try {
        // trying to register..
        await _auth.registerEmailPassword(
            emailController.text, pwController.text);

        // finished loading..
        if (mounted) hideLoadingCircle(context);

        // once registered, create and save user profile in database
        await _db.saveUserInfoInFirebase(
          name: nameController.text,
          email: emailController.text,
        );
        // btw, every time you add a new package, it's a good idea to kill the app and restart.
        //
      }

      // catch any error..
      catch (e) {
        // finished
        if (mounted) hideLoadingCircle(context);

        // let user know of the error
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

    // password don't match -> show error
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Password don't match"),
        ),
      );
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
            child: SingleChildScrollView(
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

                  // create an account message
                  Text(
                    "Let's create an account for you",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  // name textfield
                  MyTextField(
                    controller: nameController,
                    hintText: "Enter name",
                    obscureText: false,
                  ),

                  const SizedBox(
                    height: 10,
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
                  // confirm password textfield
                  MyTextField(
                    controller: confirmPwController,
                    hintText: "Confirm password",
                    obscureText: true,
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // sign up button
                  MyButton(
                    text: "Register",
                    onTap: register,
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  // already a member? login here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a member?",
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
                          "Login now",
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
      ),
    );
  }
}
