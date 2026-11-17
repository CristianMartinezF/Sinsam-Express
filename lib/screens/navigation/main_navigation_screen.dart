import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../associates/associates_list_screen.dart';
import '../home/home_screen.dart';
import '../more/more_menu_screen.dart';
import '../sheets/sheets_list_screen.dart';
import '../vehicles/vehicles_list_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;

  final _pages = const [
    HomeScreen(),
    AssociatesListScreen(),
    VehiclesListScreen(),
    SheetsListScreen(),
    MoreMenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.navyPrimary,
        unselectedItemColor: AppColors.textSecondary,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Asociados'),
          BottomNavigationBarItem(icon: Icon(Icons.local_taxi_outlined), label: 'Vehículos'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Planillas'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Más'),
        ],
      ),
    );
  }
}
