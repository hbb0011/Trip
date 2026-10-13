import 'package:flutter/material.dart';
import 'package:rihla/widgets/search_box.dart';
import '../widgets/home_header.dart';

 
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const[
            HomeHeader(prenom: 'Hiba'),
            SizedBox(height: 20),
            SearchBox(),
          ],
        ),
      ),
    );
  }
}
