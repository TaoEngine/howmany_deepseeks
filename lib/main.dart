import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:howmany_deepseeks/widget/dialogs.dart';
import 'package:howmany_deepseeks/widget/xibao.dart';
import 'package:installed_apps/app_info.dart';

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
      home: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (context) =>
                      RequestDialog(doNext: () => Navigator.pop(context, true)),
            ).then((value) {
              if (value == true) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              }
            });
          });
          return Scaffold(body: Container());
        },
      ),
    );
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
    final AppInfo testinfo = AppInfo(
      name: "name",
      icon: null,
      packageName: "packageName",
      versionName: "versionName",
      versionCode: 1,
      builtWith: BuiltWith.flutter,
      installedTimestamp: 1,
    );

    return Scaffold(
      appBar: AppBar(title: Text("喜报")),
      body: ListView(
        children: <Widget>[
          XibaoWidget(controller: xibaocontroller),
          TextButton(
            onPressed: () => xibaocontroller.addAppInfo(testinfo),
            child: Text("测试用增数按钮"),
          ),
        ],
      ),
    );
  }
}
