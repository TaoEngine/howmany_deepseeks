import 'package:flutter/material.dart';

class RequestDialog extends StatelessWidget {
  final Function() doNext;

  const RequestDialog({super.key, required this.doNext});

  @override
  Widget build(BuildContext context) {
    const String titleText = "分析前需要告知";
    const String contentText =
        "这个应用需要比对你手机上的所有应用，\n因此我有必要提前告知并且请求获取相应权限。\n如果你同意授予权限请在此对话框中进行操作。";
    const String requireText = "读取应用列表";

    return AlertDialog(
      icon: Icon(Icons.query_stats),
      title: Text(titleText),
      content: Text(contentText),
      actions: <Widget>[
        Divider(),
        ListTile(leading: Icon(Icons.apps_outage), title: Text(requireText)),
        Divider(),
        TextButton(onPressed: doNext, child: Text("继续")),
      ],
    );
  }
}

class SettingController extends ChangeNotifier {
  bool _enableSound = true;
  String _sourceURL = "";

  bool get enableSound => _enableSound;
  String get sourceURL => _sourceURL;

  void setSound(bool value) {
    _enableSound = value;
    notifyListeners();
  }

  void setURL(String value) {
    _sourceURL = value;
    notifyListeners();
  }
}

class SettingDialog extends StatefulWidget {
  final Function() doFinal;
  final SettingController controller;

  const SettingDialog({
    super.key,
    required this.doFinal,
    required this.controller,
  });

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  void refresh() => setState(() {});

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

  @override
  Widget build(BuildContext context) {
    const String titleText = "分析设置";
    const String contentText =
        "1.这个应用在分析结束后会发出喜庆的声音，\n你可以现在决定是否关闭，\n社死的话别怪我！\n2.这个应用需要从Github解析列表，\n如果国内访问Github不畅可以自行使用国内镜像";
    const String soundText = "声音";

    return AlertDialog(
      icon: Icon(Icons.settings_applications),
      title: Text(titleText),
      content: Text(contentText),
      actions: [
        Divider(),
        ListTile(
          leading: Icon(Icons.volume_up),
          title: Text(soundText),
          trailing: Switch(
            value: widget.controller._enableSound,
            onChanged: (bool value) => widget.controller.setSound(value),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.link),
            hintText: "默认为Github上的",
            labelText: "列表地址",
          ),
          onChanged: (value) => widget.controller.setURL(value),
        ),
        Divider(),
        TextButton(onPressed: widget.doFinal, child: Text("开始")),
      ],
    );
  }
}
