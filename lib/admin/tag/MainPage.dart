// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../widgets/custom_textfield.dart';
import 'Category.dart';
import 'hsv_picker.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final CollectionReference _categorys =
      FirebaseFirestore.instance.collection('categorys');
  final TextEditingController _CategoryController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final categorysSet = FirebaseFirestore.instance.collection('categorys').doc();

  Color currentColor = purple;
  List<Color> colorHistory = [];

  void changeColor(Color color) => setState(() => currentColor = color);

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
                        final String Category = _CategoryController.text;
                        await categorysSet.set({
                          "Category": Category,
                          "color":
                              '#${currentColor.toString().substring(10, currentColor.toString().length - 1)}',
                          "categoryId": categorysSet.id
                        });

                        _CategoryController.text = '';
                        _colorController.text = '';
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
    return MaterialApp(
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
            onPressed: () => _create(),
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
