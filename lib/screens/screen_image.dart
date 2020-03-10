import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merch_2020/const.dart';

class ScreenImage extends StatefulWidget {
  @override
  _ScreenImageState createState() => _ScreenImageState();
}

class _ScreenImageState extends State<ScreenImage> {
  File _imageFile; // Active image file

  // Select an image via gallery or camera, Picker plugin
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selected;
    });
  }

  // Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(sourcePath: _imageFile.path);
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  // Remove Image
  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  Widget _iconButton(IconData icon, Function onPress) {
    return MaterialButton(
      onPressed: onPress,
      child: Icon(
        icon,
        color: Colors.white,
      ),
      color: mainColor,
      shape: CircleBorder(),
      padding: EdgeInsets.all(0),
      minWidth: 55,
      height: 55,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Upload image'),
        backgroundColor: mainColor,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          if (_imageFile != null) ...[
            Expanded(
              child: Container(
                  padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                  height: 300,
                  child: Image.file(
                    _imageFile,
                    fit: BoxFit.contain,
                  )),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _iconButton(Icons.crop, _cropImage),
                    _iconButton(Icons.refresh, _clear),
                  ]),
            ),
            Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Uploader(file: _imageFile)),
          ]
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                onPressed: () => _pickImage(ImageSource.camera),
                color: mainColor,
                child: Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
                shape: CircleBorder(),
                padding: EdgeInsets.all(0),
                minWidth: 55,
                height: 55,
              ),
              MaterialButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                color: mainColor,
                child: Icon(
                  Icons.photo_library,
                  color: Colors.white,
                ),
                shape: CircleBorder(),
                padding: EdgeInsets.all(0),
                minWidth: 55,
                height: 55,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;

  Uploader({this.file});

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://merch-2020.appspot.com');
  StorageUploadTask _uploadTask;

  void _startUpload() {
    String filePath = 'images/${DateTime.now()}.png';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  Widget _iconButton(IconData icon, Function onPress) {
    return MaterialButton(
      onPressed: onPress,
      child: Icon(
        icon,
        color: Colors.white,
      ),
      color: mainColor,
      shape: CircleBorder(),
      padding: EdgeInsets.all(0),
      minWidth: 55,
      height: 55,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;
          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;
          return Column(children: [
            if (_uploadTask.isComplete) Text('File uploaded'),
            if (_uploadTask.isPaused)
              _iconButton(Icons.play_arrow, () => _uploadTask),
            if (_uploadTask.isInProgress)
              _iconButton(Icons.pause, () => _uploadTask.pause()),
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 10, right: 10),
              alignment: Alignment.center,
              child: Theme(
                data: ThemeData(accentColor: mainColor),
                child: LinearProgressIndicator(
                  value: progressPercent,
                  backgroundColor: mainColor,
                ),
              ),
            ),
            Text('${(progressPercent * 100).toStringAsFixed(0)} %'),
          ]);
        },
      );
    } else {
      return Container(child: _iconButton(Icons.cloud_upload, _startUpload));
    }
  }
}
