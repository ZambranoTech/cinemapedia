import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomButtonNavigation extends StatelessWidget {

  final int currentIndex;

  void onItemTapped( BuildContext context, int index) => context.go('/home/$index');

  const CustomButtonNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      onTap: (index) => onItemTapped(context, index),
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          label: 'Inicio'

          ),

           BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          label: 'Populares'
          ),

           BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favoritos'
          ),
      ]
      );
  }
}