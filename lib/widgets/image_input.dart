import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;


  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;
  final _picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera, maxWidth: 600);
    if(pickedFile == null) return;

    File tmpFile = File(pickedFile.path);

    final appDir = await syspath.getApplicationDocumentsDirectory();
    final pathName = path.basename(pickedFile.path);
    tmpFile = await tmpFile.copy('${appDir.path}/$pathName');
    widget.onSelectImage(tmpFile);
    setState(() {
      _storedImage = tmpFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey)
          ),
          child: _storedImage != null ?
          Image.file(_storedImage, width: double.infinity, fit: BoxFit.cover,) : Text('No image Taken', textAlign: TextAlign.center,),
          alignment: Alignment.center,
        ),
        SizedBox(width: 10,),
        Expanded(
            child: TextButton.icon(
              onPressed: getImage,
                icon: Icon(Icons.camera),
                label: Text('Take Picture'),
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
        )
      ],

    );
  }
}
