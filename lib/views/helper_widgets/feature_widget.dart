import 'package:flutter/cupertino.dart';
import 'package:svg_flutter/svg_flutter.dart';

class FeatureWidget extends StatefulWidget {
  final bool isChecked;
  final String svgPath;
  final String featureText;
  final void Function(bool?) onChecked;
  const FeatureWidget(
      {required this.isChecked,
      required this.svgPath,
      required this.featureText,
      required this.onChecked,
      super.key});

  @override
  State<FeatureWidget> createState() => _FeatureWidgetState();
}

class _FeatureWidgetState extends State<FeatureWidget> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
        widget.onChecked(isChecked);
      },
      child: Row(
        children: [
          CupertinoCheckbox(
              activeColor: CupertinoColors.systemYellow,
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = !isChecked;
                });
                widget.onChecked(value);
              }),
          SvgPicture.asset(widget.svgPath,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                  isChecked
                      ? CupertinoColors.systemYellow
                      : CupertinoColors.white,
                  BlendMode.srcIn),
              placeholderBuilder: (context) => const Icon(
                    CupertinoIcons.eye_slash_fill,
                    size: 24,
                  )),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              widget.featureText,
              style: TextStyle(
                  color: isChecked
                      ? CupertinoColors.systemYellow
                      : CupertinoColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
