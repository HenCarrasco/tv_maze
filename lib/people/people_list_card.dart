import 'package:flutter/material.dart';
import 'package:tv_maze/core/container_loader.dart';
import 'package:tv_maze/models/people_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tv_maze/core/data_adapter.dart';
import 'package:tv_maze/models/show_model.dart';
import 'package:tv_maze/shows/show_profile.dart';
import 'package:tv_maze/core/sliver_delegate.dart';

class PeopleListCard extends StatefulWidget {
  final List<ShowModel> showSavedList;
  Function handleOnShowSavedListChanged;

  PeopleListCard(
    this.people, {
    this.showSavedList,
    this.handleOnShowSavedListChanged,
    Key key,
  }) : super(key: key);

  PeopleModel people;

  @override
  _PeopleListCardState createState() => _PeopleListCardState();
}

class _PeopleListCardState extends State<PeopleListCard> {
  bool loading = false;

  void getPeopleShows(setStates) {
    DataAdapter adapter = DataAdapter();

    if (mounted) {
      setStates(() {
        loading = true;
      });
    }

    adapter
        .get("/people/${widget.people.id}/castcredits?embed=show")
        .then((response) {
      setStates(() {
        widget.people.shows = ShowModel.fromJsonList(response.data);
      });
    }).whenComplete(() {
      setStates(() {
        loading = false;
      });
    });
  }

  Widget sliverHeader(BuildContext context, String title) {
    return SliverPersistentHeader(
        pinned: false,
        delegate: SliverDelegate(
            minHeight: 20,
            maxHeight: 25,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            )));
  }

  Widget buildSliver(BuildContext context, List shows) {
    if (shows == null || shows.length == 0)
      return SliverFixedExtentList(
        itemExtent: 20,
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return (Text("N/A"));
          },
          childCount: 1,
        ),
      );
    return SliverFixedExtentList(
      itemExtent: 40,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          var show = shows[index];
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowProfile(
                            show: show,
                            isFavorite: widget.showSavedList.contains(show),
                            handleOnShowSavedListChanged:
                                widget.handleOnShowSavedListChanged)));
              },
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text('• '),
                      Text(show.name,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black.withOpacity(0.5),
                              decoration: TextDecoration.underline))
                    ],
                  )));
        },
        childCount: shows.length,
      ),
    );
  }

  showPeopleInformation(BuildContext context, {TextStyle valueStyle}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStates) {
            if (widget.people.shows == null) {
              getPeopleShows(setStates);
            }
            return SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                title: Text(
                  widget.people.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  ContainerLoader(
                      loading: loading,
                      child: Container(
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: 23.0, right: 15.0, top: 1),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    widget.people.image == null
                                        ? Icon(Icons.person,
                                            size: 160, color: Colors.grey)
                                        : Container(
                                            child: CachedNetworkImage(
                                            imageUrl:
                                                widget.people.image['medium'],
                                            placeholder: (context, url) =>
                                                new Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            strokeWidth: 5)),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          )),
                                    SizedBox(height: 10),
                                    widget.people.shows != null &&
                                            widget.people.shows.isNotEmpty
                                        ? Container(
                                            height: 200,
                                            width: 500,
                                            padding: EdgeInsets.all(10),
                                            child: CustomScrollView(
                                              slivers: [
                                                sliverHeader(context, "Series"),
                                                buildSliver(context,
                                                    widget.people.shows),
                                              ],
                                            ))
                                        : Container(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                                "${widget.people.name} doesn't have registered series yet.",
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5)))),
                                  ]))))
                ]);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showPeopleInformation(context);
        },
        child: Card(
          key: Key('people-${widget.people.id}'),
          shape: BeveledRectangleBorder(),
          elevation: 4.0,
          margin: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 8),
              widget.people.image != null
                  ? Container(
                      height: 210,
                      child: CachedNetworkImage(
                        imageUrl: widget.people.image['medium'],
                        placeholder: (context, url) => new Center(
                            child: CircularProgressIndicator(strokeWidth: 5)),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ))
                  : Icon(Icons.person, size: 160, color: Colors.grey),
              SizedBox(height: 5),
              Expanded(
                  child: Text(widget.people.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13))),
              SizedBox(height: 8),
            ],
          ),
        ));
  }
}
