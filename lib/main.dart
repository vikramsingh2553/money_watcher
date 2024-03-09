import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/provider/money_record_provider.dart';
import 'package:money_watcher/login/provider/auth_provider.dart';
import 'package:money_watcher/login/service/database_service.dart';
import 'package:money_watcher/login/ui/login_screen.dart';
import 'package:money_watcher/shared/app_colors.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseService databaseService = DatabaseService();
  await databaseService.initDatabase();

  runApp(MyApp(databaseService: databaseService));
 }

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.databaseService});

  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return AuthProvider(databaseService);
        }),

        ChangeNotifierProvider(create: (context) {
          return MoneyRecordProvider(databaseService);
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: appColorScheme),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
