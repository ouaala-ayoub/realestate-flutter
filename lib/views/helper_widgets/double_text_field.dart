import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class DoubleTextFieldForm<T> extends StatelessWidget {
  final Function(String)? onChanged1;
  final Function(String)? onChanged2;
  final List<String> values;
  final List<TextEditingController> controllers;
  const DoubleTextFieldForm({
    this.onChanged1,
    this.onChanged2,
    required this.values,
    required this.controllers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoFormRow(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
            child: CupertinoTextFormFieldRow(
                onChanged: (value) => onChanged1?.call(value),
                placeholder: values[0],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                controller: controllers[0],
                maxLength: 10,
                placeholderStyle: const TextStyle(
                    color: CupertinoColors.inactiveGray,
                    overflow: TextOverflow.ellipsis))),
        Text(
          values[1],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Flexible(
            child: CupertinoTextFormFieldRow(
          onChanged: (value) => onChanged2?.call(value),
          placeholder: values[2],
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          controller: controllers[1],
          maxLength: 10,
          placeholderStyle: const TextStyle(
              color: CupertinoColors.inactiveGray,
              overflow: TextOverflow.ellipsis),
        ))
      ],
    ));
  }
}

class DoubleTextField<T> extends StatelessWidget {
  final Function(String)? onChanged1;
  final Function(String)? onChanged2;
  final List<String> values;
  final List<TextEditingController?> controllers;
  const DoubleTextField({
    this.onChanged1,
    this.onChanged2,
    required this.values,
    required this.controllers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoFormRow(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
            child: CupertinoTextField(
                onChanged: (value) => onChanged1?.call(value),
                placeholder: values[0],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                controller: controllers[0],
                maxLength: 10,
                placeholderStyle: const TextStyle(
                    color: CupertinoColors.inactiveGray,
                    overflow: TextOverflow.ellipsis))),
        const SizedBox(
          width: 10,
        ),
        Text(
          values[1],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
            child: CupertinoTextField(
          onChanged: (value) => onChanged2?.call(value),
          placeholder: values[2],
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          controller: controllers[1],
          maxLength: 10,
          placeholderStyle: const TextStyle(
              color: CupertinoColors.inactiveGray,
              overflow: TextOverflow.ellipsis),
        ))
      ],
    ));
  }
}
