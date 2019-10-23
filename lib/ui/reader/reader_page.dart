import 'package:battery/battery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ice_book/data/entity/article_entity.dart';
import 'package:ice_book/data/text.dart';
import 'package:ice_book/ui/reader/reader_bloc.dart';
import 'package:ice_book/ui/reader/reader_view.dart';
import 'package:ice_book/utils/screen.dart';
import 'reader_page_agent.dart';

class ReaderPage extends StatefulWidget {
  final int articleId;

  ReaderPage({this.articleId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReaderPageState();
  }
}

class _ReaderPageState extends State<ReaderPage> {
//  var _battery = Battery();
//  int _batteryLevel;
  double topSafeHeight = 0;
  double _bottomOffset = 30;
  bool isLoading = false;
  int pageIndex = 0;

  ArticleEntity preArticle;
  ArticleEntity currentArticle;
  ArticleEntity nextArticle;
  PageController pageController = PageController(keepPage: false);
  ReaderBloc _readerBloc;

  @override
  void initState() {
//    _battery.onBatteryStateChanged.listen((BatteryState state) async {
//      // Do something with new state
//      setState(() async {
//        _batteryLevel = await _battery.batteryLevel;
//      });
//    });
    _readerBloc = ReaderBloc();
    super.initState();
    setup();
    pageController.addListener(onScroll);
  }

  void setup() async {
    // 不延迟的话，安卓获取到的topSafeHeight是错的。
    await Future.delayed(const Duration(milliseconds: 100), () {});
    topSafeHeight = Screen.topSafeHeight;
    await resetContent(widget.articleId);
  }

  resetContent(int articleId) async {
    currentArticle = await fetchArticle(articleId);
    if (currentArticle.preArticleId > 0) {
      preArticle = await fetchArticle(currentArticle.preArticleId);
    } else {
      preArticle = null;
    }
    if (currentArticle.nextArticleId > 0) {
      nextArticle = await fetchArticle(currentArticle.nextArticleId);
    } else {
      nextArticle = null;
    }
//    if (jumpType == PageJumpType.firstPage) {
//      pageIndex = 0;
//    } else if (jumpType == PageJumpType.lastPage) {
//      pageIndex = currentArticle.pageCount - 1;
//    }
//    if (jumpType != PageJumpType.stay) {
//      pageController.jumpToPage((preArticle != null ? preArticle.pageCount : 0) + pageIndex);
//    }

    setState(() {});
  }

  onScroll() {
    var page = pageController.offset / Screen.width;

    var nextArtilePage = currentArticle.pageCount +
        (preArticle != null ? preArticle.pageCount : 0);
    if (page >= nextArtilePage) {
      print('到达下个章节了');

      preArticle = currentArticle;
      currentArticle = nextArticle;
      nextArticle = null;
      pageIndex = 0;
      pageController.jumpToPage(preArticle.pageCount);
      fetchNextArticle(currentArticle.nextArticleId);
      setState(() {});
    }
    if (preArticle != null && page <= preArticle.pageCount - 1) {
      print('到达上个章节了');

      nextArticle = currentArticle;
      currentArticle = preArticle;
      preArticle = null;
      pageIndex = currentArticle.pageCount - 1;
      pageController.jumpToPage(currentArticle.pageCount - 1);
      fetchPreviousArticle(currentArticle.preArticleId);
      setState(() {});
    }
  }

  fetchPreviousArticle(int articleId) async {
    if (preArticle != null || isLoading || articleId == 0) {
      return;
    }
    isLoading = true;
    preArticle = await fetchArticle(articleId);
    pageController.jumpToPage(preArticle.pageCount + pageIndex);
    isLoading = false;
    setState(() {});
  }

  fetchNextArticle(int articleId) async {
    if (nextArticle != null || isLoading || articleId == 0) {
      return;
    }
    isLoading = true;
    nextArticle = await fetchArticle(articleId);
    isLoading = false;
    setState(() {});
  }

  Future<ArticleEntity> fetchArticle(int articleId) async {
    var article = ArticleEntity(
        id: 0,
        title: "第1222章 灵皇",
        content: txt,
        preArticleId: 0,
        nextArticleId: 0);
    var contentHeight = Screen.height - topSafeHeight - _bottomOffset - 20;
    var contentWidth = Screen.width - 8 - 8;
    article.pageOffsets = ReaderPageAgent.getPageOffsets(
        article.content, contentHeight, contentWidth, _readerBloc.currentState.fontSize);

    return article;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider<ReaderBloc>(
      builder: (context) => _readerBloc,
      child: BlocBuilder(
        bloc: _readerBloc,
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: <Widget>[
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: _buildPageView(),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        width: double.infinity,
                        height: _bottomOffset,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(child: Text("第1333章 灵皇")),
                            Text("1/12"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageView() {
    if (currentArticle == null) {
      return Container();
    }
    int itemCount = (preArticle != null ? preArticle.pageCount : 0) +
        currentArticle.pageCount +
        (nextArticle != null ? nextArticle.pageCount : 0);
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      controller: pageController,
      itemCount: itemCount,
      itemBuilder: buildPage,
      onPageChanged: onPageChanged,
    );
  }

  onPageChanged(int index) {
    var page = index - (preArticle != null ? preArticle.pageCount : 0);
    if (page < currentArticle.pageCount && page >= 0) {
      setState(() {
        pageIndex = page;
      });
    }
  }

  Widget buildPage(BuildContext context, int index) {
    var page = index - (preArticle != null ? preArticle.pageCount : 0);
    var article;
    if (page >= this.currentArticle.pageCount) {
      // 到达下一章了
      article = nextArticle;
      page = 0;
    } else if (page < 0) {
      // 到达上一章了
      article = preArticle;
      page = preArticle.pageCount - 1;
    } else {
      article = this.currentArticle;
    }

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
//        onTap(details.globalPosition);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ReaderView(
          article: article,
          page: page,
          fontSize: _readerBloc.currentState.fontSize,
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
