import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class SelectedImage extends StatelessWidget {
  final XFile xfile;
  const SelectedImage({required this.xfile, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(xfile.path),
      width: 50,
    );
  }
}
