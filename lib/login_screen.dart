import 'package:flutter/material.dart';
import 'package:wherehouse/create_account.dart';
import 'package:wherehouse/database/UserManager.dart';
import 'package:wherehouse/home_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:wherehouse/database/User.dart';

class BackgroundVideo extends StatefulWidget {
  @override
  _BackgroundVideoState createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BackgroundVideo> {
  late VideoPlayerController _controller;
  late UserManager userManager;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signIn(BuildContext context) async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    User? user = await User.getUserLogin(username, password);
    print(user);
    // If user is valid, navigate to the home page
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp(user: user)),
      );
    } else {
      showCheckoutAlert(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/warehouse.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);

        setState(() {});
      });
    userManager = UserManager();
  }

  void showCheckoutAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Unsuccessful Login'),
          content: Text('Incorrect Username or password'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: _controller.value.size.width ?? 0,
                height: _controller.value.size.height ?? 0,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: 300, // Set the desired width
                    child: const Center(
                      child: Image(
                        image: AssetImage("assets/WhereHouse.png"),
                        width: 270,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Add a username text field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: 200, // Set the desired width
                    color: Colors.white, // Set the background color
                    child: Center(
                      child: TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    height: 16), // Add some spacing between the text fields
                // Add a password text field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: 200, // Set the desired width
                    color: Colors.white, // Set the background color
                    child: Center(
                      child: TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true, // To hide the entered password
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      signIn(context);
                    },
                    child: const Text('SIGN IN')),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    // Handle sign-in logic here
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateView(userManager: userManager)));
                  },
                  child: const Text('CREATE'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
