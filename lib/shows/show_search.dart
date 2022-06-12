import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tv_maze/models/show_model.dart';
import 'package:tv_maze/core/data_adapter.dart';
import 'package:tv_maze/core/container_loader.dart';
import 'package:tv_maze/shows/show_list_card.dart';
import 'package:tv_maze/core/empty_state.dart';
import 'package:tv_maze/core/search_textfield.dart';

class ShowSearch extends StatefulWidget {
  final List<ShowModel> showSavedList;
  Function handleOnShowSavedListChanged;
  final bool showFavoritesOnly;

  ShowSearch(
      {this.showSavedList,
      this.handleOnShowSavedListChanged,
      this.showFavoritesOnly = false});

  @override
  _ShowSearchState createState() => new _ShowSearchState();
}

class _ShowSearchState extends State<ShowSearch> {
  String previousSearch, search = "";
  Timer debounce;
  final searchInputController = TextEditingController();
  bool loading = false;
  List<ShowModel> shows;

  @override
  void initState() {
    super.initState();
    if (widget.showFavoritesOnly) {
      shows = widget.showSavedList;
      shows.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  @override
  void dispose() {
    searchInputController.dispose();
    if (debounce != null) {
      debounce.cancel();
    }
    super.dispose();
  }

  _ShowSearchState() {
    searchInputController.addListener(() {
      if (debounce?.isActive ?? false) debounce.cancel();
      debounce = Timer(const Duration(milliseconds: 400), () {
        setState(() {
          this.search = searchInputController.text;
        });

        if (previousSearch != search && search != "") {
          getShows();
          previousSearch = search;
        } else if (search == "" && widget.showFavoritesOnly) {
          setState(() {
            shows = widget.showSavedList;
            shows.sort((a, b) => a.name.compareTo(b.name));
          });
        }
      });
    });
  }

  void getShows() {
    DataAdapter adapter = DataAdapter();

    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    if (widget.showFavoritesOnly) {
      setState(() {
        shows = shows
            .where((show) =>
                show.name.toLowerCase().contains(this.search.toLowerCase()))
            .toList();

        loading = false;
      });
    } else {
      adapter.get("/search/shows?q=${this.search}").then((response) {
        setState(() {
          shows = ShowModel.fromJsonList(response.data);
        });
      }).whenComplete(() {
        setState(() {
          loading = false;
        });
      });
    }
  }

  handleOnShowSavedListChanged(ShowModel show, bool isFavorite,
      {bool fromShowProfile}) {
    setState(() {
      widget.handleOnShowSavedListChanged(show, isFavorite,
          fromShowProfile: fromShowProfile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Container(
              child: Row(
            children: <Widget>[
              Expanded(
                  child: SearchTextField(
                      hintText: 'Search series...',
                      controller: searchInputController))
            ],
          )),
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
        body: ContainerLoader(
            loading: loading,
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              shows == null
                  ? Expanded(
                      child: EmptyState(
                          icon: Icons.live_tv,
                          text: 'Search by name to find a particular serie.'))
                  : shows.isEmpty
                      ? Expanded(
                          child: EmptyState(
                              icon: Icons.live_tv, text: 'No series found.'))
                      : Expanded(
                          child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              1.4)),
                          itemBuilder: (_, index) => ShowListCard(
                              show: shows[index],
                              isFavorite:
                                  widget.showSavedList.contains(shows[index]),
                              handleOnShowSavedListChanged:
                                  this.handleOnShowSavedListChanged),
                          itemCount: shows == null ? 0 : shows.length,
                        ))
            ])));
  }
}
