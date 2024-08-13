import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/components/my_settings_tile.dart';
import 'package:twitter_clone/themes/theme_provider.dart';

/*

SETTINGS PAGE

- Dark Mode 
- Block Users
- Account Settings

*/

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar
      appBar: AppBar(
        title: const Text("S E T T I N G S"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: Column(
        children: [
          // Dark mode tile
          MySettingsTile(
            title: "Dark Mode",
            action: CupertinoSwitch(
              onChanged: (value) =>
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme(),
              value:
                  Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            ),
          ),

          // Block users tile

          // Account settings tile
        ],
      ),
    );
  }
}