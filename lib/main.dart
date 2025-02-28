import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:howmany_deepseeks/widget/dialogs.dart';
import 'package:howmany_deepseeks/widget/xibao.dart';

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
    return MaterialApp(title: "DeepSeeks有多少", home: MainPage());
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SettingController settingcontroller = SettingController();
  XibaoWidgetController xibaocontroller = XibaoWidgetController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("喜报")),
      body: ListView(
        children: [
          XibaoWidget(controller: xibaocontroller),
          TextButton(
            onPressed: xibaocontroller.appCountAdd,
            child: Text("测试用增数按钮"),
          ),
        ],
      ),
    );
  }
}
