import 'package:http/http.dart' as http;
import 'package:toml/toml.dart';
import 'dart:convert';

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
  static final TomlRuleParser _instance = TomlRuleParser._internal();
  List<AppRule> _rules = [];
  bool _isInitialized = false;

  // 私有构造函数
  TomlRuleParser._internal();

  // 工厂构造函数返回单例
  factory TomlRuleParser() => _instance;

  Future<void> init(String url) async {
    if (_isInitialized) return; // 防止重复初始化

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('我们连不上规则网址，出现 ${response.statusCode} 错误了');
    }

    final tomlDoc = TomlDocument.parse(utf8.decode(response.bodyBytes));
    final parsedToml = tomlDoc.toMap();

    _rules =
        parsedToml.entries.where((entry) => entry.key != 'sort').map((entry) {
          final data = entry.value as Map<String, dynamic>;
          return AppRule(
            package: entry.key,
            name: data['name'] as String,
            type: data['type'] as String,
            comment: data['comment'] as String,
          );
        }).toList();

    _isInitialized = true;
  }

  List<AppRule> getRule() {
    return _rules.toList(growable: false);
  }
}
