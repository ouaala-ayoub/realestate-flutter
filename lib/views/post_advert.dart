import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/providers/post_advert_provider.dart';

import '../main.dart';

class PostAdvert extends StatefulWidget {
  final String ownerId;
  const PostAdvert({required this.ownerId, super.key});

  @override
  State<PostAdvert> createState() => _PostAdvertState();
}

class _PostAdvertState extends State<PostAdvert> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !context.watch<PostAdvertProvider>().loading,
      child: CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: Text('Post Advert'),
          ),
          child: SafeArea(
            child: Consumer<PostAdvertProvider>(
                builder: (context, provider, _) => provider.loading
                    ? const Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Adding post'),
                              SizedBox(
                                height: 10,
                              ),
                              CupertinoActivityIndicator()
                            ]),
                      )
                    : _buildStepper(StepperType.horizontal, provider)),
          )),
    );
  }

  Step _buildStep({
    required Widget title,
    required Widget content,
    StepState state = StepState.indexed,
    bool isActive = false,
  }) {
    return Step(
      title: title,
      state: state,
      isActive: isActive,
      content: content,
    );
  }

  CupertinoStepper _buildStepper(
      StepperType type, PostAdvertProvider provider) {
    //todo dont forget to fix can continue
    //todo change logic to handle disable button if required info not entred
    return CupertinoStepper(
      key: Key("mysuperkey-${provider.steps.length}"),
      type: type,
      currentStep: currentStep,
      onStepTapped: (step) => setState(() => currentStep = step),
      onStepCancel: currentStep != 0
          ? () => setState(() {
                --currentStep;
              })
          : showLeaveDialog,
      onStepContinue: provider.canContinue[currentStep]
          ? () => setState(() {
                currentStep == provider.steps.length - 1
                    ? showSubmitDialog(provider, context)
                    : ++currentStep;
              })
          : null,
      steps: provider.steps.map((element) {
        final i = provider.steps.indexOf(element);
        return _buildStep(
          title: const Text(''),
          content: element,
          isActive: i == currentStep,
          state: i == currentStep
              ? StepState.editing
              : provider.canContinue[i]
                  ? StepState.complete
                  : StepState.indexed,
        );
      }).toList(),
    );
  }

  showSubmitDialog(PostAdvertProvider provider, BuildContext buildContext) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text('Last Step: Plegde'),
              content: const Text(
                'I pledge to bear all responsabilities resulting from this advertisement , Your post will be verified and approved by admins as soon as possible !',
                style: TextStyle(color: CupertinoColors.white, fontSize: 14),
              ),
              actions: [
                CupertinoDialogAction(
                    onPressed: () {
                      context.pop();
                      provider.submitPost(
                          ownerId: widget.ownerId,
                          onSuccess: (res) {
                            // logger.i(res['message']);
                            buildContext.pushReplacement('/post_created');
                          },
                          onFail: (e) {
                            logger.e(e);
                            context.pop();
                            showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                      title: const Text(
                                          'Unexcpected error please try again'),
                                      actions: [
                                        CupertinoDialogAction(
                                          isDestructiveAction: true,
                                          child: const Text('Cancel'),
                                          onPressed: () => context.pop(),
                                        )
                                      ],
                                    ));
                          });
                    },
                    isDefaultAction: true,
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: CupertinoColors.white),
                    )),
                CupertinoDialogAction(
                    onPressed: () => context.pop(),
                    isDestructiveAction: true,
                    child: const Text('Cancel')),
              ],
            ));
  }

  showLeaveDialog() {
    return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text('Leave the process ?'),
              content: const Text('All data will be lost'),
              actions: [
                CupertinoDialogAction(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(color: CupertinoColors.white),
                    )),
                CupertinoDialogAction(
                    onPressed: () {
                      context.pop();
                      context.pop();
                    },
                    isDestructiveAction: true,
                    child: const Text('Yes'))
              ],
            ));
  }
}
