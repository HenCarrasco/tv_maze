import 'package:flutter/material.dart';
import 'package:tv_maze/shows/show_list.dart';
import 'package:tv_maze/shows/show_search.dart';
import 'package:tv_maze/drawer.dart';
import 'package:tv_maze/models/show_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ShowModel> showSavedList = List();

  handleOnShowSavedListInitialized(
      List<ShowModel> shows, List<String> showsId) {
    setState(() {
      showSavedList =
          shows.where((show) => showsId.contains(show.id.toString())).toList();
    });
  }

  handleOnShowSavedListChanged(ShowModel show, bool isFavorite,
      {bool fromShowProfile}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> showsId;

    if (fromShowProfile == null) {
      fromShowProfile = false;
    }

    setState(() {
      if (fromShowProfile) {
        if (!isFavorite) {
          showSavedList.remove(show);
        } else {
          showSavedList.add(show);
        }
      } else {
        if (isFavorite) {
          showSavedList.remove(show);
        } else {
          showSavedList.add(show);
        }
      }

      if (showSavedList.length > 0) {
        showsId = [];
        showSavedList.forEach((show) {
          showsId.add(show.id.toString());
        });
      }

      prefs.setStringList("showsId", showsId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(children: <Widget>[
          Expanded(child: Text(widget.title)),
          Align(
              alignment: Alignment.centerRight,
              child: Row(children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowSearch(
                                  showSavedList: showSavedList,
                                  handleOnShowSavedListChanged:
                                      handleOnShowSavedListChanged,
                                )));
                  },
                )
              ]))
        ])),
        body: Center(
          child: ShowList(
              showSavedList: showSavedList,
              handleOnShowSavedListChanged: handleOnShowSavedListChanged,
              handleOnShowSavedListInitialized:
                  handleOnShowSavedListInitialized),
        ),
        drawer: AppDrawer(
            showSavedList: showSavedList,
            handleOnShowSavedListChanged: handleOnShowSavedListChanged));
  }
}
