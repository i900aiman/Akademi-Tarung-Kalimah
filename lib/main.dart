import 'package:flutter/material.dart';
import 'package:saderi_silat/screens/timeline/timeline_schedule.dart';
import 'theme/app_theme.dart';
import 'widgets/custom_bottom_nav.dart';
import 'screens/home/home_page.dart';
import 'screens/program/program_page.dart';
import 'screens/timeline/schedule_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akademi Tarung Kalimah',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainTabWrapper(),
    );
  }
}

class MainTabWrapper extends StatefulWidget {
  const MainTabWrapper({super.key});

  @override
  State<MainTabWrapper> createState() => _MainTabWrapperState();
}

class _MainTabWrapperState extends State<MainTabWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ProgramPage(),
    LatihanTimelineScreen()
    // SchedulePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}