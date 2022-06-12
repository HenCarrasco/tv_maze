import 'package:flutter/material.dart';
import 'package:tv_maze/people/people_search.dart';
import 'package:tv_maze/models/show_model.dart';
import 'package:tv_maze/shows/show_favorites.dart';

class AppDrawer extends StatelessWidget {
  final List<ShowModel> showSavedList;
  Function handleOnShowSavedListChanged;

  AppDrawer({this.handleOnShowSavedListChanged, this.showSavedList});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Align(
                alignment: FractionalOffset.topLeft,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          iconSize: 20,
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 50, left: 30, right: 30),
                  child: ListTile(
                      leading: Icon(Icons.people, color: Colors.white),
                      title: Text(
                        'People',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      contentPadding: EdgeInsets.only(left: 0),
                      dense: true,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PeopleSearch(
                                    showSavedList: showSavedList,
                                    handleOnShowSavedListChanged:
                                        handleOnShowSavedListChanged)));
                      })),
              Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: ListTile(
                      leading: Icon(Icons.star, color: Colors.white),
                      title: Text(
                        'My Favorite Series',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      contentPadding: EdgeInsets.only(left: 0),
                      dense: true,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowFavorites(
                                    showSavedList: showSavedList,
                                    handleOnShowSavedListChanged:
                                        handleOnShowSavedListChanged)));
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
