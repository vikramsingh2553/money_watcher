import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/ui/add_money_record_screen.dart';
import 'package:money_watcher/dashboard/ui/money_record_chart_screen.dart';
import 'package:money_watcher/login/ui/money_record_list_screen.dart';
import 'package:money_watcher/shared/app_string.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabScreenList = [
    MoneyRecordListScreen(),
    MoneyRecordChartScreen(),
    AddMoneyRecordScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(appName),
          leading: Image(
            image: AssetImage(
              'assets/images/Money Watcher.png',
            ),
            height: 300 ,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.view_list), label: "Money Record"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: "Chart"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          ],
        ),
        body: _tabScreenList[_selectedIndex],
      ),
    );
  }
}
