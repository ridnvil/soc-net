import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/activity_feed.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin<Search> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;

  handleSearch(String query) {
    Future<QuerySnapshot> users = userRef
        .where("displayName", isGreaterThanOrEqualTo: query)
        .getDocuments();

    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSearch(){
    searchController.clear();
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintText: "Search for a user...",
          filled:  true,
          border: InputBorder.none,
          prefixIcon: Icon(Icons.account_circle, size: 28.0,),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              clearSearch();
            },
          ),
        ),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  buildSearchResult() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return circularProgress();
        }

        List<UserResult> searchResult = [];

        snapshot.data.documents.forEach((doc){
          User user = User.fromDocument(doc);
          UserResult searchResultsuser = UserResult(user);
          searchResult.add(searchResultsuser);
        });

        return ListView(
          children: searchResult,
        );
      },
    );
  }

  Container buildNoContent(){
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SvgPicture.asset('assets/images/search.svg', height: orientation == Orientation.portrait ? 300.0: 200.0,),
            Text("Find User", textAlign: TextAlign.center, style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              fontSize: 60.0
            ))
          ],
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: buildSearchField(),
      body: searchResultsFuture == null ? buildNoContent(): buildSearchResult(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;

  UserResult(this.user);


  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(children: <Widget>[
        // Divider(
        //   height: 2.0,
        //   color: Colors.blue,
        // ),
        GestureDetector(
          onTap: () => showProfile(context, profileId: user.id),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            title: Text(user.displayName, style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold
            ),),
            subtitle: Text(user.username, style: TextStyle(
              color: Colors.black38
            ),),
          ),
        ),
        // Divider(
        //   thickness: 5.0,
        //   height: 2.0,
        //   color: Colors.blue,
        // ),
      ],),
    );
  }
}
