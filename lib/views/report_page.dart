import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/main.dart';
import 'package:realestate/models/core/post/owner.dart';
import 'package:realestate/models/core/report.dart';
import 'package:realestate/providers/auth_provider.dart';
import 'package:realestate/providers/report_provider.dart';
import 'package:realestate/views/error_widget.dart';
import 'package:realestate/views/login_page.dart';

class ReportPage extends StatelessWidget {
  final String id;
  static const list = [
    'Sold/Not Available',
    'No Response',
    'Wrong Information',
    'Other'
  ];
  const ReportPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text(
            'Report!',
            style: TextStyle(color: CupertinoColors.systemRed),
          ),
        ),
        child: SafeArea(
          child: Consumer<RealestateAuthProvider>(
              builder: (context, authProvider, _) => authProvider.loading
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : authProvider.auth!.fold((error) {
                      if (error == 'Unauthorized') {
                        logger.e('Unauthorized');
                        return LoginPage(
                          goType: GoType.pushReplaced,
                          sourceRoute: '/report/$id',
                        );
                      } else {
                        return ErrorScreen(
                          message: 'Unexpected error',
                          refreshFunction: () => authProvider.fetshAuth(),
                        );
                      }
                    }, (user) => reportScreen(user))),
        ));
  }

  Center reportScreen(RealestateUser user) {
    return Center(
      child: Consumer<ReportPageProvider>(
        builder: (context, provider, _) => provider.loading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            'Reasons :',
                            style:
                                TextStyle(color: CupertinoColors.systemYellow),
                          ),
                        ),
                        Column(
                          children: list.map((text) {
                            return SingleReason(
                                onChanged: (value) {
                                  // provider.setIsChecked(index, !value);
                                  if (value == null) {
                                    return;
                                  }
                                  provider.handleReason(value, text);
                                },
                                text: text);
                          }).toList(),
                        ),
                        provider.showOthers
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Specify :',
                                        style: TextStyle(
                                            color:
                                                CupertinoColors.systemYellow),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CupertinoTextField(
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                              color: CupertinoColors.white)),
                                      minLines: 5,
                                      maxLines: 5,
                                      maxLength: 250,
                                      controller: provider.othersTFController,
                                      onChanged: (value) {
                                        provider.nofityTextChange();
                                      },
                                    ),
                                    Text(
                                        '${provider.othersTFController.text.length}/250')
                                  ],
                                ),
                              )
                            : const SizedBox(
                                height: 0,
                              )
                      ],
                    ),
                  ),
                  CupertinoButton.filled(
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        if (provider.dataEntred()) {
                          //todo data
                          final report = Report(
                              post: id,
                              status: 'Pending',
                              reasons: provider.reasons,
                              message:
                                  provider.othersTFController.text.isNotEmpty
                                      ? provider.othersTFController.text
                                      : null,
                              user: user.id);

                          provider.sendReport(report, onSuccess: () {
                            logger.i('report success');
                            showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                      content: const Text(
                                        'Thanks For submitting this report !',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(CupertinoIcons.back),
                                              Text('Go back')
                                            ],
                                          ),
                                          onPressed: () {
                                            context.pop();
                                            context.pop();
                                          },
                                        )
                                      ],
                                    ));
                          }, onFail: (e) {
                            showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                      content: const Text(
                                          'Unexpected error while submitting your report !'),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: const Text('Try again'),
                                          onPressed: () {
                                            context.pop();
                                          },
                                        ),
                                        CupertinoDialogAction(
                                          isDestructiveAction: true,
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            context.pop();
                                            context.pop();
                                          },
                                        )
                                      ],
                                    ));
                          });
                        } else {
                          showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                    content: const Text(
                                        'Please enter all informations !',
                                        style: TextStyle(fontSize: 18)),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text('Ok'),
                                        onPressed: () => context.pop(),
                                      )
                                    ],
                                  ));
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
      ),
    );
  }
}

class SingleReason extends StatefulWidget {
  final Function(bool?) onChanged;
  final String text;
  const SingleReason({
    required this.onChanged,
    required this.text,
    super.key,
  });

  @override
  State<SingleReason> createState() => _SingleReasonState();
}

class _SingleReasonState extends State<SingleReason> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isChecked = !isChecked;
            });
            widget.onChanged(isChecked);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoCheckbox(
                checkColor: CupertinoColors.black,
                activeColor: CupertinoColors.systemYellow,
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = !isChecked;
                  });
                  widget.onChanged(value);
                },
              ),
              Text(widget.text)
            ],
          ),
        ),
      ],
    );
  }
}
