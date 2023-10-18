// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, override_on_non_overriding_member

import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  PickedFile? _imageFile;
  bool _loading = false;

  late List _outputs;
  late List test;
  late String labelData;
  late File _image;
  late String newtest;

  @override
  // void initState() {
  //   super.initState();
  //   _loading = true;

  //   loadModel().then((value) {
  //     setState(() {
  //       _loading = false;
  //     });
  //   });
  // }

  final databaseReference = FirebaseDatabase.instance.reference();

  void initState() {
    super.initState();
    Tflite.loadModel(
      model:
          "assets/finalFlowerModel.tflite", // Replace with the path to your model
      labels: "assets/labels.txt", // Replace with the path to your labels file
    );
  }

  classifyImage(File image) async {
    try {
      var output = await Tflite.runModelOnImage(
          path: image.path,
          imageMean: 0.0,
          imageStd: 255.0,
          numResults: 2,
          threshold: 0.2,
          asynch: true);
      setState(() {
        _loading = false;
        _outputs = output!;
        labelData = _outputs[0]["label"].toString();
      });
    } catch (e) {
      // Handle and log the error
      print("Error: $e");
    }
  }

  var check = 'jasmine';

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _loading = true;
      _imageFile = pickedFile;
    });
    File image = File(pickedFile!.path);
    classifyImage(image);
  }

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _loading = true;
        _imageFile = pickedFile;
      });

      File image = File(pickedFile.path);
      classifyImage(image);
    }
  }

  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('FLOWER DETAILS'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: _imageFile == null
                      ? Image.asset(
                          'assets/default.jpg',
                          height: 300,
                          width: 300,
                        )
                      : Image.file(
                          File(_imageFile!.path),
                          height: 300,
                          width: 300,
                        ),
                ),
                _imageFile == null
                    ? Container()
                    : _outputs != null
                        ? Column(
                            children: [
                              StreamBuilder(
                                stream: databaseReference
                                    .child(
                                        _outputs[0]["label"].toString().trim())
                                    .onValue,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var data = snapshot.data!.snapshot.value;

                                    final jsonDataEncode = json.encode(data);
                                    // final jsonData = '''$data''';
                                    Map<String, dynamic> newData =
                                        json.decode(jsonDataEncode);
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _outputs[0]["label"].toString(),
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 163, 4, 137)),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Scientific Name :- ${newData['Scientific Name']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.blueAccent),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          color:
                                              Color.fromARGB(255, 196, 15, 15),
                                          child: SizedBox(
                                            height: 5,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: Text(
                                            'Details',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                                color: Colors.blueAccent),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Text(
                                            newData['Details'],
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  }
                                  return CircularProgressIndicator(); // Loading indicator
                                },
                              )
                            ],
                          )
                        : Container(child: Text("")),
                SizedBox(
                  height: 20,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     SizedBox(
                //       width: 100,
                //       child: ElevatedButton(
                //         style: ButtonStyle(
                //           backgroundColor:
                //               MaterialStateProperty.all(Colors.blue),
                //           foregroundColor:
                //               MaterialStateProperty.all(Colors.white),
                //           elevation: MaterialStateProperty.all(8),
                //           padding:
                //               MaterialStateProperty.all(EdgeInsets.all(16)),
                //           shape:
                //               MaterialStateProperty.all(RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10),
                //           )),
                //         ),
                //         onPressed: () {
                //           _pickImage();
                //         },
                //         child: Text(
                //           'Gallary',
                //           style: TextStyle(fontSize: 20),
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 100,
                //       child: ElevatedButton(
                //         style: ButtonStyle(
                //           backgroundColor:
                //               MaterialStateProperty.all(Colors.blue),
                //           foregroundColor:
                //               MaterialStateProperty.all(Colors.white),
                //           elevation: MaterialStateProperty.all(8),
                //           padding:
                //               MaterialStateProperty.all(EdgeInsets.all(16)),
                //           shape:
                //               MaterialStateProperty.all(RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10),
                //           )),
                //         ),
                //         onPressed: () {
                //           _pickImageFromCamera();
                //         },
                //         child: Text(
                //           'Camera',
                //           style: TextStyle(fontSize: 20),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_home,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
                label: 'Camera',
                backgroundColor: Colors.black,
                onTap: () => _pickImageFromCamera()),
            SpeedDialChild(
              child: Icon(
                Icons.image,
                color: Colors.white,
              ),
              label: 'Gallery',
              backgroundColor: Colors.black,
              onTap: () => _pickImage(),
            ),
          ],
        ),
      ),
    );
  }
}
