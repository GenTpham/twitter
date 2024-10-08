import 'package:flutter/material.dart';

/*

BUTTON

A simple button.

--------------------------------------------------------------------------------

To use this widget, you need:

- text 
- a function ( on tap )

*/

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const MyButton({super.key, required this.text, required this.onTap});

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Padding inside
        padding: const EdgeInsets.all(25),

        decoration: BoxDecoration(
          // Color of button
          color: Theme.of(context).colorScheme.secondary,

          // Curved corners
          borderRadius: BorderRadius.circular(12),
        ),

        // Text
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}