import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toml/toml.dart';

class AppRule {
  final String package;
  final String name;
  final String type;
  final String comment;

  AppRule({
    required this.package,
    required this.name,
    required this.type,
    required this.comment,
  });

  @override
  String toString() {
    return "包名：$package\n应用名：$name\n应用分类：$type\n备注：$comment";
  }
}

class TomlRuleParser {
  List<AppRule> _rules = [];

  Future<void> init(String url) async {
    // 获取TOML文件内容
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load TOML file: ${response.statusCode}');
    }

    // 解析TOML
    final tomlDoc = TomlDocument.parse(utf8.decode(response.bodyBytes));
    final parsedToml = tomlDoc.toMap();

    // 构建规则列表
    _rules = parsedToml.entries
        .where((entry) => entry.key != 'sort') // 暂时过滤sort配置项，现在还没用
        .map((entry) {
      final packageName = entry.key;
      final data = entry.value as Map<String, dynamic>;
      return AppRule(
        package: packageName,
        name: data['name'] as String,
        type: data['type'] as String,
        comment: data['comment'] as String,
      );
    }).toList();
  }

  List<AppRule> getRule() {
    return _rules.toList(growable: false); // 返回不可修改列表
  }
}
