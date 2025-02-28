import 'package:flutter/material.dart';

class XibaoWidgetController extends ChangeNotifier {
  int _appCount = 0;

  get appCount => _appCount;

  /// 增加Count，执行一次增加一次
  void appCountAdd() {
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

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("image/background.png"),
          Text(
            "手机上一共有 $appCount 款应用接入了 DeepSeek",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
