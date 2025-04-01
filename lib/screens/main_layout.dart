import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // Lista de telas (remova a FireScreen)
  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  // Itens da bottom bar (mantenha apenas 3 itens)
  final List<BottomNavigationBarItem> _bottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Início',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Perfil',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Config',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _bottomItems,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}