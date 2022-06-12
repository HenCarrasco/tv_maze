import 'package:flutter/material.dart';
import 'package:tv_maze/models/show_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tv_maze/shows/show_profile.dart';

class ShowListCard extends StatefulWidget {
  ShowListCard({
    this.show,
    this.isFavorite,
    this.handleOnShowSavedListChanged,
    Key key,
  }) : super(key: key);

  final ShowModel show;
  final bool isFavorite;
  Function handleOnShowSavedListChanged;

  @override
  _ShowListCardState createState() => _ShowListCardState();
}

class _ShowListCardState extends State<ShowListCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShowProfile(
                      show: widget.show,
                      isFavorite: widget.isFavorite,
                      handleOnShowSavedListChanged:
                          widget.handleOnShowSavedListChanged)));
        },
        child: Card(
          key: Key('event-${widget.show.id}'),
          shape: BeveledRectangleBorder(),
          elevation: 4.0,
          margin: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      height: 30,
                      width: 50,
                      child: IconButton(
                          icon: Icon(
                            widget.isFavorite ? Icons.star : Icons.star_border,
                            size: 22,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.handleOnShowSavedListChanged(
                                  widget.show, widget.isFavorite);
                            });
                          }))
                ],
              ),
              widget.show.image != null
                  ? Container(
                      height: 205,
                      child: CachedNetworkImage(
                        imageUrl: widget.show.image['medium'],
                        placeholder: (context, url) => new Center(
                            child: CircularProgressIndicator(strokeWidth: 5)),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ))
                  : Icon(Icons.live_tv, size: 160, color: Colors.grey),
              SizedBox(height: 5),
              Expanded(
                  child: Text(widget.show.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13))),
              SizedBox(height: 8),
            ],
          ),
        ));
  }
}
