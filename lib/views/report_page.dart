import 'package:flutter/cupertino.dart';

class ReportPage extends StatelessWidget {
  final String id;
  const ReportPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Report'),
        ),
        child: Center(
          child: Text(id),
        ));
  }
}
