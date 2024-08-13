import 'package:flutter/material.dart';

/*

USER BIO BOX

This is a simple box with text inside. We will use this for the user bio on 
their profile pages.

--------------------------------------------------------------------------------

To use this widget, you just need:

- Text 

*/

class MyBioBox extends StatelessWidget {
  final String text;

  const MyBioBox({super.key, required this.text});

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // Container
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,

        // Curve corners
        borderRadius: BorderRadius.circular(8),
      ),

      // padding
      padding: const EdgeInsets.all(25),

      child: Text(
        text.isNotEmpty ? text : "Empty bio..",
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }
}
