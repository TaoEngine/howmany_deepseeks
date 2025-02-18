import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:howmany_deepseeks/dialogs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DeepSeeks有多少",
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SettingController controller = SettingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              setState(() {
                showDialog(
                  context: context,
                  builder: (context) => SettingDialog(
                    doFinal: () {},
                    controller: controller,
                  ),
                );
              });
            },
            child: Text("测试dialog")),
      ),
    );
  }
}
