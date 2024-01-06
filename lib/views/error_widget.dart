import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  final void Function() refreshFunction;
  const ErrorScreen(
      {required this.refreshFunction, super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (context.read<RealestateAuthProvider>().loading)
                const Center(
                  child: CupertinoActivityIndicator(),
                )
              else
                CupertinoButton(
                  onPressed: refreshFunction,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.refresh),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Refresh",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
            ]),
      ),
    );
  }
}
