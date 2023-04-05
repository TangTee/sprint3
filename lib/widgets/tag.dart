import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../utils/color.dart';

showModalBottomSheetC(BuildContext context) {
  final CollectionReference categorys =
      FirebaseFirestore.instance.collection('categorys');
  var value = {};

  showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.height * 0.5,
        child: StreamBuilder(
          stream: categorys.snapshots(),
          builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 180,
                    childAspectRatio: 1.4 / 2,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];

                  var Mytext = {};
                  Mytext['Category'] = documentSnapshot['Category'];
                  Mytext['categoryId'] = documentSnapshot['categoryId'];
                  Mytext['color'] = documentSnapshot['color'];
                  Mytext['categoryImage'] = documentSnapshot['categoryImage'];

                  return Container(
                    child: Column(
                      children: [
                        Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(
                              color: HexColor(Mytext['color']),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                Mytext["categoryImage"],
                                fit: BoxFit.fitWidth,
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          textColor: mobileSearchColor,
                          title: Center(
                              child: Text(
                            Mytext['Category'],
                            style: const TextStyle(
                              fontFamily: 'MyCustomFont',
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          )),
                          onTap: () {
                            value = showModalBottomSheetT(
                                context, Mytext['categoryId'], value);
                          },
                        ),
                      ],
                    ),
                  );
                },
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
          }),
        ),
      );
    },
  );
  return value;
}

showModalBottomSheetT(BuildContext context, categoryId, value) {
  final CollectionReference tags =
      FirebaseFirestore.instance.collection('tags');

  showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    builder: (BuildContext context) {
      return StreamBuilder(
        stream: tags.where("categoryId", isEqualTo: categoryId).snapshots(),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 700,
                height: 500,
                child: Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 145,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 5),
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (BuildContext ctx, index) {
                        final DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];

                        var Mytext = {};
                        Mytext['tag'] = documentSnapshot['tag'];
                        Mytext['tagColor'] = documentSnapshot['tagColor'];
                        return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Column(children: [
                              SizedBox(
                                child: OutlinedButton(
                                  onPressed: () {
                                    value['_tag2'] = Mytext['tag'].toString();
                                    value['_tag2Color'] =
                                        Mytext['tagColor'].toString();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      side: BorderSide(
                                          color: HexColor(
                                            Mytext['tagColor'],
                                          ),
                                          width: 1.5)),
                                  child: Text(
                                    Mytext['tag'],
                                    style: const TextStyle(
                                        color: mobileSearchColor, fontSize: 14),
                                  ),
                                ),
                              ),
                            ]));
                      }),
                ),
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
        }),
      );
    },
  );
  return value;
}
