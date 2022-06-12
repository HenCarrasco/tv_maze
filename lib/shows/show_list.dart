import 'package:flutter/material.dart';
import 'package:tv_maze/core/container_loader.dart';
import 'package:tv_maze/models/show_model.dart';
import 'package:tv_maze/core/data_adapter.dart';
import 'package:tv_maze/shows/show_list_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowList extends StatefulWidget {
  final List<ShowModel> showSavedList;
  final Function handleOnShowSavedListChanged;
  final Function handleOnShowSavedListInitialized;
  final bool showFavoritesOnly;

  ShowList(
      {this.showSavedList,
      this.handleOnShowSavedListChanged,
      this.handleOnShowSavedListInitialized,
      this.showFavoritesOnly = false});

  @override
  State<StatefulWidget> createState() => ShowListState();
}

class ShowListState extends State<ShowList> {
  List<ShowModel> shows;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.showFavoritesOnly) {
      shows = widget.showSavedList;
      shows.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (shows == null) {
        getShows();
      } else {
        getShowSavedList();
      }
    });
  }

  void getShows() {
    DataAdapter adapter = DataAdapter();

    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    adapter.get("/shows").then((response) {
      setState(() {
        shows = ShowModel.fromJsonList(response.data);
        getShowSavedList();
      });
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  getShowSavedList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> showsId = sharedPreferences.getStringList("showsId");
    print("SHOWS ID SAVED: " + showsId.toString());
    if (showsId != null && widget.handleOnShowSavedListInitialized != null) {
      widget.handleOnShowSavedListInitialized(shows, showsId);
    } else {
      print('No values to show');
    }
  }

  handleOnShowSavedListChanged(ShowModel show, bool isFavorite,
      {bool fromShowProfile}) {
    setState(() {
      if (widget.showFavoritesOnly) {
        if (!isFavorite) {
          shows.remove(show);
        } else if (isFavorite && !shows.contains(show)) {
          shows.add(show);
        }
      }
      widget.handleOnShowSavedListChanged(show, isFavorite,
          fromShowProfile: fromShowProfile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContainerLoader(
        loading: loading,
        child: Container(
            child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.4)),
          itemBuilder: (_, index) => ShowListCard(
              show: shows[index],
              isFavorite: widget.showSavedList.contains(shows[index]),
              handleOnShowSavedListChanged: this.handleOnShowSavedListChanged),
          itemCount: shows == null ? 0 : shows.length,
        )));
  }
}
