import 'package:flutter/material.dart';
import 'package:test_package_call/phone_state.dart';

class ListSolicitantes extends StatelessWidget {
  static const String route = 'list-solicitantes';

  const ListSolicitantes({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Solicitantes'),
        ),
        body: ListView(
          children: [
            ListTile(
              onTap: () async {
                Navigator.pushNamed(context, PhoneStatePage.route);
              },
              title: Text('Daniel'),
              leading: Icon(Icons.person),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
