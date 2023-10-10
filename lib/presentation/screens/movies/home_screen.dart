import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  
  const HomeScreen({super.key, required this.childView});

  static const name = 'home-screen';

  final Widget childView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: childView,
      bottomNavigationBar: const CustomButtonNavigation(),
    );
  }
}


