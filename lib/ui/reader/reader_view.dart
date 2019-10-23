import 'package:flutter/cupertino.dart';
import 'package:ice_book/data/entity/article_entity.dart';

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
        Center(
          child: Text(content,
            style: TextStyle(fontSize: fontSize),
            textAlign: TextAlign.justify,),
        ),
      ],
    );
  }
}
