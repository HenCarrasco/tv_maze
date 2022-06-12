import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tv_maze/models/people_model.dart';
import 'package:tv_maze/core/data_adapter.dart';
import 'package:tv_maze/core/container_loader.dart';
import 'package:tv_maze/people/people_list_card.dart';
import 'package:tv_maze/core/empty_state.dart';
import 'package:tv_maze/core/search_textfield.dart';
import 'package:tv_maze/models/show_model.dart';

class PeopleSearch extends StatefulWidget {
  final List<ShowModel> showSavedList;
  Function handleOnShowSavedListChanged;

  PeopleSearch({this.handleOnShowSavedListChanged, this.showSavedList});

  @override
  _PeopleSearchState createState() => new _PeopleSearchState();
}

class _PeopleSearchState extends State<PeopleSearch> {
  String previousSearch, search = "";
  Timer debounce;
  final searchInputController = TextEditingController();
  bool loading = false;
  List<PeopleModel> people;

  @override
  void dispose() {
    searchInputController.dispose();
    if (debounce != null) {
      debounce.cancel();
    }
    super.dispose();
  }

  _PeopleSearchState() {
    searchInputController.addListener(() {
      if (debounce?.isActive ?? false) debounce.cancel();
      debounce = Timer(const Duration(milliseconds: 400), () {
        setState(() {
          this.search = searchInputController.text;
        });

        if (previousSearch != search && search != "") {
          getShows();
          previousSearch = search;
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

    adapter.get("/search/people?q=${this.search}").then((response) {
      setState(() {
        people = PeopleModel.fromJsonList(response.data);
      });
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
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
                      hintText: 'Search people...',
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
              people == null
                  ? Expanded(
                      child: EmptyState(
                          icon: Icons.people,
                          text: 'Search by name to find a particular people.'))
                  : people.isEmpty
                      ? Expanded(
                          child: EmptyState(
                              icon: Icons.people, text: 'No people found.'))
                      : Expanded(
                          child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              1.5)),
                          itemBuilder: (_, index) => PeopleListCard(
                            people[index],
                            showSavedList: widget.showSavedList,
                            handleOnShowSavedListChanged:
                                widget.handleOnShowSavedListChanged,
                          ),
                          itemCount: people == null ? 0 : people.length,
                        ))
            ])));
  }
}
