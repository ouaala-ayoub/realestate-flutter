import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:realestate/models/core/constants.dart';
import 'package:realestate/models/helpers/function_helpers.dart';
import 'package:realestate/providers/post_advert_provider.dart';
import '../double_text_field.dart';
import '../feature_widget.dart';

class DetailsStep extends StatelessWidget {
  const DetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostAdvertProvider>(
      builder: (context, provider, _) => CupertinoFormSection(
        header: const Text('Additional Informations'),
        children: [
          CupertinoFormRow(
              prefix: const Text('Property Condition'),
              child: Center(
                child: CupertinoButton(
                  child: Text(provider.data['condition'] ?? 'Choose'),
                  onPressed: () {
                    provider.updateNextStatus3();
                    showPicker(context, provider, conditions, 'condition');
                  },
                ),
              )),
          indicativeRow('Number of Rooms :'),
          CupertinoTextFormFieldRow(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => provider.updateNextStatus3(),
            maxLength: 10,
            placeholder: 'Enter',
            controller: provider.data['numRooms'],
            keyboardType: TextInputType.number,
          ),
          indicativeRow('Number of Bathrooms :'),
          CupertinoTextFormFieldRow(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => provider.updateNextStatus3(),
            maxLength: 10,
            placeholder: 'Enter',
            controller: provider.data['numBathrooms'],
            keyboardType: TextInputType.number,
          ),
          indicativeRow('Floor infos :'),
          DoubleTextFieldForm(
              onChanged1: (value) => provider.updateNextStatus3(),
              onChanged2: (value) => provider.updateNextStatus3(),
              values: const [
                'Floor Number',
                'Out of',
                'Floors in the building'
              ],
              controllers: [
                provider.data['floorNumber'],
                provider.data['floors']
              ]),
          indicativeRow('Space :'),
          DoubleTextFieldForm(
              onChanged1: (value) {
                provider.updateSquareFeet(value);
              },
              onChanged2: (value) {
                provider.updateSquareMeters(value);
              },
              values: const ['m²', '\u21C4', 'foot²'],
              controllers: [provider.data['m2'], provider.data['foot2']]),
          indicativeRow('Landmark/Facilities'),
          CupertinoFormRow(
              child: Center(
            child: CupertinoButton(
              child: const Text('Add features'),
              onPressed: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                          title: const Text(
                            'Please Check the features your property have !',
                            style: TextStyle(
                                fontSize: 18, color: CupertinoColors.white),
                          ),
                          cancelButton: CupertinoButton(
                              child: const Text(
                                'Done',
                                style: TextStyle(
                                    color: CupertinoColors.activeGreen),
                              ),
                              onPressed: () => context.pop(())),
                          actions: landMarks.entries
                              .map((entry) => FeatureWidget(
                                  isChecked: provider.data['features']
                                      .contains(entry.key),
                                  svgPath: entry.value,
                                  featureText: entry.key,
                                  onChecked: (checked) =>
                                      provider.handleFeature(entry.key)))
                              .toList(),
                        ));
              },
            ),
          ))
        ],
      ),
    );
  }

  indicativeRow(String text) => CupertinoFormRow(
          child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style: const TextStyle(color: CupertinoColors.systemYellow)),
      ));
}
