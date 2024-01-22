import 'package:flutter/cupertino.dart';
import 'package:realestate/models/core/country.dart';
import 'package:svg_flutter/svg.dart';

class CountryInfo extends StatelessWidget {
  final Country country;
  final bool showCode;
  const CountryInfo({
    required this.showCode,
    required this.country,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(mainAxisSize: MainAxisSize.max, children: [
        SvgPicture.network(country.image,
            height: 32,
            width: 32,
            placeholderBuilder: (context) =>
                const CupertinoActivityIndicator()),
        const SizedBox(
          width: 5,
        ),
        showCode
            ? Text(country.dialCode)
            : const SizedBox(
                width: 5,
              ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(
            country.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ]),
    );
  }
}
