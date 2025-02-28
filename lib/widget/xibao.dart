import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:installed_apps/app_info.dart';

class XibaoWidgetController extends ChangeNotifier {
  int _appCount = 0;
  final List<Uint8List?> _appIcons = [];

  /// 接入了DeepSeek的个数
  int get appCount => _appCount;

  /// 显示在喜报上的应用名以及对应图片
  List<Uint8List?> get appIcons => _appIcons;

  /// 向喜报中添加规则中的应用，
  /// 添加方式为AppInfo
  void addAppInfo(AppInfo appinfo) {
    // 添加应用标签
    final Uint8List? appIcon = appinfo.icon;
    _appIcons.add(appIcon);

    // 自增应用个数
    _appCount++;
    notifyListeners();
  }
}

class XibaoWidget extends StatefulWidget {
  final XibaoWidgetController controller;
  const XibaoWidget({super.key, required this.controller});

  @override
  State<XibaoWidget> createState() => _XibaoWidgetState();
}

class _XibaoWidgetState extends State<XibaoWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(refresh);
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final int appCount = widget.controller.appCount;
    final List<Uint8List?> appIcons = widget.controller.appIcons;

    // 生成应用图标
    final List<Widget> appIconsWidget = List.generate(
      widget.controller.appCount,
      (count) {
        if (appIcons[count] != null) {
          return Image.memory(appIcons[count]!);
        } else {
          return Icon(
            Icons.warning,
            color: Theme.of(context).colorScheme.primary,
          );
        }
      },
    );

    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset("image/xibao.png"),
          Padding(
            padding: EdgeInsets.only(top: 70),
            child: Text(
              "手机上一共有 $appCount 款应用接入了 DeepSeek",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: GridView.extent(
                  maxCrossAxisExtent: 40,
                  childAspectRatio: 1,
                  children: appIconsWidget,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
