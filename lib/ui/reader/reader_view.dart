import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ice_book/data/entity/article_entity.dart';

const double bottomHeight = 30;
const double paddingLeft = 16;
const double paddingTopBottom = 8;
class ReaderView extends StatelessWidget {
  final ArticleEntity article;
  final int page;
  final double fontSize;
  ReaderView({this.article, this.page, this.fontSize});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var content = article.stringAtPageIndex(page);

    if (content.startsWith('\n')) {
      content = content.substring(1);
    }
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            page == 0 ? Container(
              width: double.infinity,
              height: 80,
              child: Center(
                child: Text(article.title, style: Theme.of(context).primaryTextTheme.title,),
              ),
            ) : Container(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top:8.0, bottom: 8, left: paddingLeft, right: paddingLeft),
                child:
                Text.rich(
                  TextSpan(children: [TextSpan(text: content, style: TextStyle(fontSize: fontSize))]),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: paddingTopBottom),
              width: double.infinity,
              height: 30,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(child: Text(
                      article == null ? "" : article.title)),
                  Text("${page + 1}/${article ==
                      null ? 0 : article.pageCount}"),
                ],
              ),
            )
          ],
        )

      ],
    );
  }
}
