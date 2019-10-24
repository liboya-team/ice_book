import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ice_book/ui/reader/reader_page.dart';

import '../../routes.dart';

class BookRackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BookRackPageState();
  }
}

class _BookRackPageState extends State<BookRackPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return _addListItem(index);
          }),
    );
  }

  Widget _addListItem(int index) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        onTap: () {
//          Navigator.pushNamed(context, Routes.reader);
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return ReaderPage(articleId: 0,);
          }));
        },
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          height: 110,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Material(
                elevation: 3,
                child: AspectRatio(
                  aspectRatio: 72 / 101,
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    placeholder: (context, url) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            border: Border.all(
                                color: Theme.of(context).dividerColor)),
                        child: Center(
                          child: Text(
                            "小冰阅读",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .caption
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      );
                    },
                    imageUrl:
                        "http://img2-ak.lst.fm/i/u/300x300/fa1ba2422a5d452797ba5eb8ddd61021.jpg",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "盘龙",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .subhead
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 4),
                            padding: EdgeInsets.only(
                              left: 4,
                              right: 4,
                            ),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.deepOrangeAccent),
                            child: Text(
                              "更新",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .overline
                                  .copyWith(color: Colors.white),
                            )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:4.0),
                      child: Text(
                        "我吃西红柿",
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      "119章未读　第1293章　灵皇",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).primaryTextTheme.caption,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
