// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shopping_client/main.dart';

class Node {
  int sortNo;
  String typeName;
  String? parentId;
  String? parentIds;
  String id;
  String? baseNote;
  List<Node> children = [];

  Node({
    required this.sortNo,
    required this.typeName,
    this.parentId,
    this.parentIds,
    required this.id,
    this.baseNote,
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      sortNo: json['SortNo'],
      typeName: json['TypeName'],
      parentId: json['ParentId'],
      parentIds: json['ParentIds'],
      id: json['Id'],
      baseNote: json['BaseNote'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SortNo': sortNo,
      'TypeName': typeName,
      'ParentId': parentId,
      'ParentIds': parentIds,
      'Id': id,
      'BaseNote': baseNote,
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}
List<Node> buildTree(List<Node> allNodes, [String? parentId]) {
  List<Node> tree = [];
  for (var node in allNodes) {
    if (node.parentId == parentId) {
      node.children = buildTree(allNodes, node.id);
      tree.add(node);
    }
  }
  return tree;
}
void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    String jsonStr = '''
[
    {
      "SortNo": 3,
      "TypeName": "人事科",
      "ParentId": null,
      "ParentIds": null,
      "Id": "819154792654835712",
      "BaseNote": null
    },
    {
      "SortNo": 7,
      "TypeName": "质量管理科",
      "ParentId": null,
      "ParentIds": null,
      "Id": "818146251320070144",
      "BaseNote": null
    },
    {
      "SortNo": 9,
      "TypeName": "献血服务一科",
      "ParentId": null,
      "ParentIds": null,
      "Id": "818140926584033280",
      "BaseNote": null
    },
    {
      "SortNo": 10,
      "TypeName": "院区1",
      "ParentId": "818140926584033280",
      "ParentIds": "818140926584033280",
      "Id": "818143869269970944",
      "BaseNote": null
    },
    {
      "SortNo": 10,
      "TypeName": "献血服务二科",
      "ParentId": null,
      "ParentIds": null,
      "Id": "818140940500733952",
      "BaseNote": null
    },
    {
      "SortNo": 12,
      "TypeName": "检验科",
      "ParentId": null,
      "ParentIds": null,
      "Id": "819482894324994048",
      "BaseNote": null
    },
    {
      "SortNo": 20,
      "TypeName": "院区2",
      "ParentId": "818140926584033280",
      "ParentIds": "818140926584033280",
      "BaseCreatorId": "16508640061130151",
      "Id": "818143933820309504",
      "BaseNote": null
    },
    {
      "SortNo": 30,
      "TypeName": "院区3",
      "ParentId": "818140926584033280",
      "ParentIds": "818140926584033280",
      "Id": "818146345645772800",
      "BaseNote": null
    }
    ,
    {
      "SortNo": 300,
      "TypeName": "院区300",
      "ParentId": "818146345645772800",
      "ParentIds": "818140926584033280",
      "Id": "818146345645772805",
      "BaseNote": null
    }
  ]
''';

    List<dynamic> jsonList = json.decode(jsonStr);
    List<Node> allNodes = jsonList.map((item) => Node.fromJson(item)).toList();
    List<Node> tree = buildTree(allNodes);

    String resultJson = json.encode(tree.map((node) => node.toJson()).toList());
    print(resultJson);
    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
