import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:howmany_deepseeks/func/ruleparse.dart';

import 'package:howmany_deepseeks/widget/dialogs.dart';
import 'package:howmany_deepseeks/widget/xibao.dart';

import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

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
            ).then((value) async {
              TomlRuleParser tomlRuleParser = TomlRuleParser();
              await tomlRuleParser.init(
                "https://ghfile.geekertao.top/https://raw.githubusercontent.com/TaoEngine/howmany_deepseeks/refs/heads/main/rules/deepseeks.toml",
              );
              if (value == true) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ErrorPage()),
                );
              }
            });
          });
          return Scaffold(body: Scaffold(body: Container()));
        },
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("抱歉")),
      body: Center(
        child: SizedBox(
          height: 100,
          child: Column(children: [Text("你没有为我申请权限，要不退出重进？")]),
        ),
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
  TomlRuleParser tomlRuleParser = TomlRuleParser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DeepSeeks有多少")),
      body: FutureBuilder(
        future: InstalledApps.getInstalledApps(false, true, ""),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final List<AppInfo> appManual = snapshot.data;
            final List<AppRule> appRule = tomlRuleParser.getRule();
            final List<AppInfo> appFinal = [];

            for (var app in appManual) {
              for (var rule in appRule) {
                if (rule.package == app.packageName) {
                  appFinal.add(app);
                  xibaocontroller.addAppInfo(app);
                }
              }
            }

            return ListView(
              children: <Widget>[XibaoWidget(controller: xibaocontroller)],
            );
          } else {
            return Center(
              child: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    Image.asset("image/check.png", scale: 2),
                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 140, right: 140),
                      child: LinearProgressIndicator(year2023: false),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
