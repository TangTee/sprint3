// ignore_for_file: prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utils/color.dart';
import '../../widgets/custom_textfield.dart';

class TagCategory extends StatefulWidget {
  // final String categoryId; ต้องget data
  DocumentSnapshot categoryId;
  TagCategory({Key? key, required this.categoryId}) : super(key: key);

  @override
  _TagCategoryState createState() => _TagCategoryState();
}

class _TagCategoryState extends State<TagCategory> {
  var categoryData = {};
  var categoryNameData = {};
  bool isLoading = false;

  final CollectionReference _tags =
      FirebaseFirestore.instance.collection('tags');

  Future<void> _update(String tagId) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _tagController,
                  decoration: textInputDecorationp.copyWith(
                      hintText: 'change tag name'.toString()),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      child: const Text(
                        'change',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'MyCustomFont',
                          color: white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        final String tag = _tagController.text;

                        await _tags.doc(tagId).update({"tag": tag});
                        _tagController.text = '';
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lightGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ))
              ],
            ),
          );
        });
  }

  Future<void> _delete(String tagId) async {
    await _tags.doc(tagId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a category')));
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _tagController = TextEditingController();
  final tagSet = FirebaseFirestore.instance.collection('tags');

  bool _isLoading = false;
  bool submit = false;
  final tagController = TextEditingController();

  Future<void> _create() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  minLines: 1,
                  controller: tagController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a comment';
                    }
                    return null;
                  },
                  decoration:
                      textInputDecorationp.copyWith(hintText: 'tag'.toString()),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'create',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'MyCustomFont',
                            color: white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          var tagSet2 = tagSet.doc();
                          await tagSet2.set({
                            'tagId': tagSet2.id,
                            'tag': tagController.text,
                            'tagColor': widget.categoryId['color'],
                            'categoryId': widget.categoryId['categoryId']
                          }).whenComplete(() {
                            tagController.clear();
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: mobileBackgroundColor,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 713,
                  child: ListView(children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: tagSet
                          .where("categoryId",
                              isEqualTo: widget.categoryId['categoryId'])
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: unselected,
                                  radius: 61,
                                  child: CircleAvatar(
                                    backgroundColor: white,
                                    backgroundImage: NetworkImage(
                                      widget.categoryId['categoryImage']
                                          .toString(),
                                    ),
                                    radius: 60,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.98,
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: SizedBox(
                                          child: ListView.builder(
                                              itemCount:
                                                  snapshot.data!.docs.length,
                                              itemBuilder: (context, index) {
                                                final DocumentSnapshot
                                                    documentSnapshot =
                                                    snapshot.data!.docs[index];

                                                var Mytext = {};
                                                Mytext['tag'] =
                                                    documentSnapshot['tag'];
                                                Mytext['tagColor'] =
                                                    documentSnapshot[
                                                        'tagColor'];
                                                return Card(
                                                  elevation: 2,
                                                  child: ClipPath(
                                                    child: SizedBox(
                                                      height: 80,
                                                      child: Container(
                                                        child: Container(
                                                          height: 80,
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  left: BorderSide(
                                                                      color: HexColor(
                                                                          Mytext[
                                                                              'tagColor']),
                                                                      width:
                                                                          10))),
                                                          child: ListTile(
                                                            title: Text(
                                                                Mytext['tag']),
                                                            subtitle: Row(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8.0),
                                                                      child:
                                                                          SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.035,
                                                                        child:
                                                                            OutlinedButton(
                                                                          onPressed:
                                                                              () {},
                                                                          child:
                                                                              Text(
                                                                            Mytext['tag'],
                                                                            style:
                                                                                const TextStyle(color: mobileSearchColor),
                                                                          ),
                                                                          style: OutlinedButton.styleFrom(
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                              side: BorderSide(color: HexColor(Mytext['tagColor']), width: 2)),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            trailing:
                                                                SingleChildScrollView(
                                                              child: SizedBox(
                                                                  width: 100,
                                                                  child: Row(
                                                                    children: [
                                                                      IconButton(
                                                                        icon: const Icon(
                                                                            Icons.edit),
                                                                        onPressed:
                                                                            () =>
                                                                                _update(documentSnapshot.id),
                                                                      ),
                                                                      IconButton(
                                                                          icon: const Icon(Icons
                                                                              .delete),
                                                                          onPressed: () =>
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return AlertDialog(
                                                                                    title: const Text('Are you sure?'),
                                                                                    content: const Text('This action cannot be undone.'),
                                                                                    actions: [
                                                                                      TextButton(
                                                                                        child: const Text('Cancel'),
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                      ),
                                                                                      TextButton(
                                                                                        child: const Text('OK'),
                                                                                        onPressed: () {
                                                                                          _delete(documentSnapshot.id);
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              )),
                                                                    ],
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    clipper: ShapeBorderClipper(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3))),
                                                  ),
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                );
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

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
                      },
                    ),
                  ]),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _create(),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
