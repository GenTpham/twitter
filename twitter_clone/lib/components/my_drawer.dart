import 'package:flutter/material.dart';
import 'package:twitter_clone/components/my_drawer_tile.dart';
import 'package:twitter_clone/pages/profile_page.dart';
import 'package:twitter_clone/pages/settings_page.dart';
import 'package:twitter_clone/services/auth/auth_service.dart';

/*

This is a menu drawer which is usually access on the left side of the app bar

--------------------------------------------------------------------------------

Contains 5 menu options
- Home
- Profile
- Search
- Settings
- Logout

*/

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  // access auth service
  final _auth = AuthService();

  // logout
  void logout() {
    _auth.logout();
  }

  //Build UI
  @override
  Widget build(BuildContext context) {
    //Drawer
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              //app logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              // divider line
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(
                height: 10,
              ),
              //home list title
              MyDrawerTile(
                title: "H O M E",
                icon: Icons.home,
                onTap: () {
                  // pop menu drawer since we are already at home
                  Navigator.pop(context);
                },
              ),
              //profile list tile
              MyDrawerTile(
                title: "P R O F I L E",
                icon: Icons.person,
                onTap: () {
                  // pop menu drawer
                  Navigator.pop(context);

                  // go to profile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(uid: _auth.getCurrentUid()),
                    ),
                  );
                },
              ),

              // search list title

              //settings list
              MyDrawerTile(
                title: "S E T T I N G S",
                icon: Icons.settings,
                onTap: () {
                  // pop menu drawer
                  Navigator.pop(context);

                  //go to settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  );
                },
              ),

              const Spacer(),

              // logout list title
              MyDrawerTile(
                title: "L O G O U T",
                icon: Icons.logout,
                onTap: logout,
              )
            ],
          ),
        ),
      ),
    );
  }
}
