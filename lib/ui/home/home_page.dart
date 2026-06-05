import 'package:zzuna/ui/auth/logout/widgets/logout_button.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: const Center(
        child: SizedBox(
          width: double.infinity,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Welcome to the Home Page!'),
              Spacer(),
              Icon(Icons.home),
              Spacer(),
              LogoutButton(), //
            ],
          ),
        ),
      ),
    );
  }
}
