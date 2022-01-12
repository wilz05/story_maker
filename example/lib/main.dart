import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:story_maker/story_maker.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Designer Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await [
                  Permission.photos,
                  Permission.storage,
                ].request();
                final picker = ImagePicker();
                await picker
                    .pickImage(source: ImageSource.gallery)
                    .then((file) async {
                  final File editedFile = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StoryMaker(
                        filePath: file!.path,
                        doneButtonChild: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: const [
                                SizedBox(width: 4),
                                Text(
                                  'Done Editing',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  CupertinoIcons.back,
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  setState(() {
                    image = editedFile;
                  });
                  print('editedFile: ${image!.path}');
                });
              },
              child: const Text('Pick Image'),
            ),
            if (image != null)
              Expanded(
                child: Image.file(image!),
              ),
          ],
        ),
      ),
    );
  }
}
