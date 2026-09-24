import 'package:flutter/material.dart';
import 'package:saderi_silat/screens/home/tempahan/jersi_form.dart';
import 'package:saderi_silat/screens/home/tempahan/uniform_form.dart';
import 'package:saderi_silat/theme/app_theme.dart';


class TempahanPage extends StatefulWidget {
  const TempahanPage({super.key});

  @override
  State<TempahanPage> createState() => _TempahanPageState();
}

class _TempahanPageState extends State<TempahanPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tempahan'),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryGreen,
          unselectedLabelColor: AppTheme.textMuted,
          indicatorColor: AppTheme.primaryGreen,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700),
          tabs: const [
            Tab(text: 'Tempah Jersi'),
            Tab(text: 'Tempah Uniform'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          JersiFormPage(),
          UniformFormPage(),
        ],
      ),
    );
  }
}