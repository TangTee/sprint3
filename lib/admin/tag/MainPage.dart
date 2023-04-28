// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tangteevs/utils/showSnackbar.dart';
import '../../widgets/custom_textfield.dart';
import 'Category.dart';
import 'hsv_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _ImageCategoryController = '';
  File? media;
  final CollectionReference _categorys =
      FirebaseFirestore.instance.collection('categorys');
  final TextEditingController _CategoryController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  var categorysSet;
  String ImageCategory = "";
  var isLoading = false;

  Color currentColor = purple;
  List<Color> colorHistory = [];

  void changeColor(Color color) => setState(() => currentColor = color);

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      categorysSet = FirebaseFirestore.instance.collection('categorys').doc();
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future selectFilever2() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('${file?.path}');

    if (file == null) return;
    String getRandomString(int length) {
      const characters =
          '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
      Random random = Random();
      return String.fromCharCodes(Iterable.generate(length,
          (_) => characters.codeUnitAt(random.nextInt(characters.length))));
    }

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('category');
    Reference referenceImageToUpload =
        referenceDirImages.child(getRandomString(40));
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(file.path));
      //Success: get the download URL
      ImageCategory = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      //Some error occurred
    }
    setState(() {
      media = File(file.path);
    });
    print(ImageCategory);
  }

  Future uploadFile() async {
    final path = 'img/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() => null);
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download linkL $urlDownload');
  }

  Future<void> _create() async {
    Color pickerColor2;
    ValueChanged<Color> onColorChanged = changeColor;
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pickedFile != null)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: mobileSearchColor,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 200,
                              child: Image.file(
                                File(pickedFile!.path!),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )),
                          ListTile(
                            textColor: mobileSearchColor,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                            title: Center(
                                child: Text(
                              "Demo",
                              style: const TextStyle(
                                fontFamily: 'MyCustomFont',
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            )),
                            onTap: () {},
                          )
                        ],
                      ),
                    ),
                  GestureDetector(
                    onTap: selectFilever2,
                    child: SizedBox(
                        height: 120,
                        child: media != null
                            ? Image.file(media!)
                            : Image.asset('assets/images/addimage.png')),
                  ),
                  TextField(
                    controller: _CategoryController,
                    decoration: textInputDecorationp.copyWith(
                        hintText: 'category'.toString()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  HSVColorPicker(
                    pickerColor: currentColor,
                    onColorChanged: changeColor,
                    colorHistory: colorHistory,
                    onHistoryChanged: (List<Color> colors) =>
                        colorHistory = colors,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lightGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () async {
                        uploadFile;
                        final String Category = _CategoryController.text;
                        await categorysSet.set({
                          "Category": Category,
                          "color":
                              '#${currentColor.toString().substring(10, currentColor.toString().length - 1)}',
                          "categoryId": categorysSet.id,
                          "categoryImage": ImageCategory
                        });
                        setState(() {
                          _CategoryController.clear();
                          _colorController.clear();
                          media = null;
                          currentColor = purple;
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Create',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'MyCustomFont',
                          color: white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Text('data')
        : MaterialApp(
            home: DismissKeyboard(
              child: Scaffold(
                backgroundColor: mobileBackgroundColor,
                appBar: AppBar(
                  toolbarHeight: 50,
                  backgroundColor: mobileBackgroundColor,
                  leadingWidth: 130,
                  centerTitle: true,
                  leading: Container(
                    padding: const EdgeInsets.all(0),
                    child: Image.asset('assets/images/logo with name.png',
                        fit: BoxFit.scaleDown),
                  ),
                ),
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                  child: Category(),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _create().whenComplete(() => getData()),
                  child: Icon(Icons.add),
                ),
              ),
            ),
          );
  }
}

class Category extends StatelessWidget {
  final CollectionReference _categorys =
      FirebaseFirestore.instance.collection('categorys');

  Category({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mobileBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
            child: Text(
              'Categorys',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _categorys.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const <Widget>[
                            SizedBox(
                              height: 30.0,
                              width: 30.0,
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                          return CategoryWidget(
                              snap: (snapshot.data! as dynamic).docs[index]);
                        });
                  })),
        ],
      ),
    );
  }
}
