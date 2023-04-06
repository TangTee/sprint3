import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tangteevs/admin/user/UserCard.dart';
import '../../utils/color.dart';
import '../../widgets/custom_textfield.dart';

class SearchData extends StatefulWidget {
  dynamic mobileBackgroundColor;
  SearchData({Key? key, this.mobileBackgroundColor}) : super(key: key);

  @override
  State<SearchData> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchData> {
  String name = '';
  final bool _isLoading = false;
  bool theme = false;

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

  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DismissKeyboard(
        child: Scaffold(
          backgroundColor: mobileBackgroundColor,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Search(),
          ),
        ),
      ),
    );
  }
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final userSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            forceElevated: innerBoxIsScrolled,
            backgroundColor: mobileBackgroundColor,
            elevation: 0,
            centerTitle: false,
            title: Padding(
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextFormField(
                  controller: userSearch,
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: searchInputDecoration.copyWith(
                    hintText: 'ค้นหา user ด้วย displayname หรือ email',
                    hintStyle: const TextStyle(
                      color: unselected,
                      fontFamily: 'MyCustomFont',
                    ),
                    prefixIcon: const Icon(
                      Icons.search_outlined,
                      color: orange,
                      size: 30,
                    ),
                    suffixIcon: userSearch.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            color: orange,
                            iconSize: 18,
                            onPressed: (() {
                              userSearch.clear();
                              setState(() {});
                            })),
                  ),
                  onFieldSubmitted: (value) {},
                ),
              ),
            ),
          ),
          //),
        ];
      },
      body: SafeArea(
        child: UserCard(userSearch: userSearch.text),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  //PostCard({super.key});
  final String userSearch;
  UserCard({Key? key, required this.userSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return userSearch != ""
        ? StreamBuilder<QuerySnapshot>(
            stream: _users
                .where('verify', isEqualTo: true)
                .where('Displayname', isGreaterThanOrEqualTo: userSearch)
                //.where('email', isGreaterThanOrEqualTo: userSearch)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  child: Center(
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
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('User not found',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'MyCustomFont',
                        color: unselected,
                        fontWeight: FontWeight.bold,
                      )),
                );
              }

              return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Container(
                        child: UCardWidget(
                            snap: (snapshot.data! as dynamic).docs[index]),
                      ));
            })
        : StreamBuilder<QuerySnapshot>(
            stream: _users.where('verify', isEqualTo: true).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  child: Center(
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
                  ),
                );
              }

              return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Container(
                        child: UCardWidget(
                            snap: (snapshot.data! as dynamic).docs[index]),
                      ));
            });
  }
}
