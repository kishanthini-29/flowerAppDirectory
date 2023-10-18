// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flower/homepage.dart';
import 'package:flutter/material.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 6, 110, 158),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WELCOME',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.white),
            ),
            Text(
              'Flower Recognition',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white),
            ),
            SizedBox(
              height: 30,
            ),
            Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/default.jpg',
                  width: 300,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  elevation: MaterialStateProperty.all(8),
                  padding: MaterialStateProperty.all(EdgeInsets.all(16)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => home()),
                  );
                },
                child: Text(
                  'Click',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
