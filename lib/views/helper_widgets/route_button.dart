// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class RouteButton extends StatelessWidget {
  final String text;
  final String route;
  final Icon? icon;

  const RouteButton({
    Key? key,
    this.icon,
    required this.text,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
        borderRadius: BorderRadius.circular(25),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              icon != null
                  ? icon!
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              const SizedBox(
                width: 5,
              ),
              Text(
                text,
                overflow: TextOverflow.ellipsis,
              )
            ]),
        onPressed: () => context.push(route));
  }
}
