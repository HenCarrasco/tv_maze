import 'package:flutter/material.dart';
import 'package:tv_maze/models/show_model.dart';
import 'package:tv_maze/shows/show_list.dart';
import 'package:tv_maze/shows/show_search.dart';
import 'package:tv_maze/core/empty_state.dart';

class ShowFavorites extends StatefulWidget {
  List<ShowModel> showSavedList;
  final Function handleOnShowSavedListChanged;

  ShowFavorites({this.handleOnShowSavedListChanged, this.showSavedList});

  @override
  _ShowFavoritesState createState() => new _ShowFavoritesState();
}

class _ShowFavoritesState extends State<ShowFavorites> {
  handleOnShowSavedListChanged(ShowModel show, bool isFavorite,
      {bool fromShowProfile}) {
    setState(() {
      if (isFavorite) {
        widget.showSavedList.remove(show);
      } else if (!isFavorite && !widget.showSavedList.contains(show)) {
        widget.showSavedList.add(show);
      }
      widget.handleOnShowSavedListChanged(show, isFavorite,
          fromShowProfile: fromShowProfile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('My Favorite Series', style: TextStyle(color: Colors.white)),
              widget.showSavedList.isEmpty || widget.showSavedList == null
                  ? SizedBox.shrink()
                  : Align(
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
                                          showFavoritesOnly: true,
                                          showSavedList: widget.showSavedList,
                                          handleOnShowSavedListChanged:
                                              handleOnShowSavedListChanged,
                                        )));
                          },
                        )
                      ]))
            ]),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: widget.showSavedList.isEmpty || widget.showSavedList == null
          ? EmptyState(icon: Icons.star, text: 'No favorite series found.')
          : Center(
              child: ShowList(
                  showFavoritesOnly: true,
                  showSavedList: widget.showSavedList,
                  handleOnShowSavedListChanged: handleOnShowSavedListChanged),
            ),
    );
  }
}
