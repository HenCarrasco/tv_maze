import 'package:flutter/material.dart';
import 'package:tv_maze/core/container_loader.dart';
import 'package:tv_maze/models/show_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tv_maze/core/label_value.dart';
import 'package:html/parser.dart';
import 'package:tv_maze/core/data_adapter.dart';
import 'package:tv_maze/models/episode_model.dart';

class ShowProfile extends StatefulWidget {
  ShowModel show;
  bool isFavorite;
  Function handleOnShowSavedListChanged;

  ShowProfile({this.show, this.isFavorite, this.handleOnShowSavedListChanged});

  @override
  _ShowProfileState createState() => new _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  bool loading = false;
  Map<int, List<EpisodeModel>> seasons = Map();
  bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.show.episodes == null) {
        getEpisodes();
      } else if (seasons.isEmpty) {
        setSeasons();
      }
    });
  }

  void getEpisodes() {
    DataAdapter adapter = DataAdapter();

    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    adapter.get("/shows/${widget.show.id}/episodes").then((response) {
      setState(() {
        widget.show.episodes = EpisodeModel.fromJsonList(response.data);
        setSeasons();
      });
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  void setSeasons() {
    setState(() {
      widget.show.episodes.forEach((episode) {
        if (seasons[episode.season] == null) {
          seasons[episode.season] = [];
        }
        seasons[episode.season].add(episode);
      });
    });
  }

  showEpisodeInformation(
      BuildContext context, EpisodeModel episode, String season,
      {TextStyle valueStyle}) {
    String parsedSummary;

    if (episode.summary != null) {
      parsedSummary = getHtmlParsedValue(episode.summary);
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStates) {
            return SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                title: Column(
                  children: [
                    Text(
                      '${episode.number}. ${episode.name}',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Season',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 3),
                        Text(season, style: TextStyle(fontSize: 12))
                      ],
                    ),
                  ],
                ),
                children: <Widget>[
                  Container(
                      child: Padding(
                          padding:
                              EdgeInsets.only(left: 23.0, right: 15.0, top: 1),
                          child: Column(children: <Widget>[
                            episode.image == null
                                ? Icon(Icons.live_tv,
                                    size: 160, color: Colors.grey)
                                : Container(
                                    child: CachedNetworkImage(
                                    imageUrl: episode.image['medium'],
                                    placeholder: (context, url) => new Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 5)),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  )),
                            parsedSummary != null && parsedSummary != ""
                                ? Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      parsedSummary,
                                      style: valueStyle,
                                    ))
                                : Text(
                                    "We don't have a summary for ${episode.name} yet.",
                                    style: valueStyle),
                          ])))
                ]);
          });
        });
  }

  String getHtmlParsedValue(String value) {
    String parsedValue;
    var parsed = parse(value);
    parsedValue = parse(parsed.body.text).documentElement.text;
    return parsedValue;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

    TextStyle valueStyle = TextStyle(color: Colors.black.withOpacity(0.5));

    Widget spaceBetween = SizedBox(height: 20);
    String parsedSummary;

    if (widget.show.summary != null) {
      parsedSummary = getHtmlParsedValue(widget.show.summary);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("TV Maze", style: TextStyle(color: Colors.white)),
              Align(
                  alignment: Alignment.centerRight,
                  child: Row(children: <Widget>[
                    IconButton(
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                            widget.handleOnShowSavedListChanged(
                                widget.show, isFavorite,
                                fromShowProfile: true);
                          });
                        })
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
      body: ContainerLoader(
          loading: loading,
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(
                          top: 20, bottom: 20, left: 5, right: 5),
                      color: Colors.grey.withOpacity(0.2),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(widget.show.name,
                                style: labelStyle, textAlign: TextAlign.center),
                            SizedBox(height: 15),
                            widget.show.image == null
                                ? Icon(Icons.live_tv,
                                    size: 160, color: Colors.grey)
                                : Container(
                                    child: CachedNetworkImage(
                                    imageUrl: widget.show.image['medium'],
                                    placeholder: (context, url) => new Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 5)),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  )),
                          ])),
                  Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            widget.show.schedule['days'].isEmpty &&
                                    widget.show.averageRuntime == null
                                ? SizedBox.shrink()
                                : LabelValue(
                                    label: "SCHEDULE",
                                    value: widget.show.getSchedule(),
                                    valueStyle: valueStyle,
                                  ),
                            spaceBetween,
                            widget.show.genres.isNotEmpty
                                ? LabelValue(
                                    label: "GENRES",
                                    value: widget.show.getGenres(),
                                    valueStyle: valueStyle,
                                  )
                                : SizedBox.shrink(),
                            spaceBetween,
                            parsedSummary != null
                                ? LabelValue(
                                    label: "SUMMARY",
                                    value: parsedSummary,
                                    textAlign: TextAlign.justify,
                                    valueStyle: valueStyle,
                                  )
                                : SizedBox.shrink(),
                            spaceBetween,
                            LabelValue(
                              label: "EPISODES",
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount:
                                      seasons == Map() ? 0 : seasons.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return index == 0
                                        ? SizedBox.shrink()
                                        : ExpansionTile(
                                            leading: null,
                                            title: Text(
                                              'Season $index',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            children: <Widget>[
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      ClampingScrollPhysics(),
                                                  itemCount: seasons[index] ==
                                                          null
                                                      ? 0
                                                      : seasons[index].length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int episodeIndex) {
                                                    EpisodeModel episode =
                                                        seasons[index]
                                                            [episodeIndex];
                                                    return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: episodeIndex ==
                                                                  0
                                                              ? const Border()
                                                              : Border(
                                                                  top: BorderSide(
                                                                      width: 1,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor)),
                                                        ),
                                                        child: ListTile(
                                                          onTap: () {
                                                            showEpisodeInformation(
                                                                context,
                                                                episode,
                                                                index
                                                                    .toString(),
                                                                valueStyle:
                                                                    valueStyle);
                                                          },
                                                          leading: Text(
                                                            '${episode.number}.',
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                          title: Transform
                                                              .translate(
                                                                  offset:
                                                                      Offset(
                                                                          -20,
                                                                          -3),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Expanded(
                                                                          child:
                                                                              Text('${episode.name}')),
                                                                      episode.runtime !=
                                                                              null
                                                                          ? Text(
                                                                              '(${episode.runtime} min)',
                                                                              style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.5)),
                                                                            )
                                                                          : SizedBox
                                                                              .shrink(),
                                                                    ],
                                                                  )),
                                                        ));
                                                  })
                                            ],
                                          );
                                  }),
                            )
                          ]))
                ])
          ]))),
    );
  }
}
