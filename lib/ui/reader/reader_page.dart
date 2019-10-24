import 'package:battery/battery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ice_book/data/entity/article_entity.dart';
import 'package:ice_book/data/text.dart';
import 'package:ice_book/ui/reader/reader_bloc.dart';
import 'package:ice_book/ui/reader/reader_view.dart';
import 'package:ice_book/utils/screen.dart';

class ReaderPage extends StatefulWidget {
  final int bookId;
  final int articleId;

  ReaderPage({this.bookId, this.articleId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReaderPageState();
  }
}

class _ReaderPageState extends State<ReaderPage> {
  double topSafeHeight = 0;
  double _bottomOffset = 30;
  bool isLoading = false;

  PageController pageController = PageController();
  ReaderBloc _readerBloc;

  @override
  void initState() {
    _readerBloc = ReaderBloc();
    super.initState();
    setup();
    pageController.addListener(onScroll);
  }

  void setup() async {
    // 不延迟的话，安卓获取到的topSafeHeight是错的。
    await Future.delayed(const Duration(milliseconds: 100), () {});
    topSafeHeight = Screen.topSafeHeight;
    var contentHeight = Screen.height - topSafeHeight - _bottomOffset - 20;
    var contentWidth = Screen.width - paddingLeft - paddingLeft;
    _readerBloc.dispatch(InitPageEvent(
        fontSize: 16,
        pageIndex: 0,
        bookId: 0,
        articleId: 1,
        contentWidth: contentWidth,
        contentHeight: contentHeight));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider<ReaderBloc>(
      builder: (context) => _readerBloc,
      child: BlocListener<ReaderBloc, ReaderState>(
        listener: (context, state) {
          if( state.event is NextArticleEvent){
            pageController.jumpToPage(state.preArticle.pageCount);
          }else if (state.event is PreArticleEvent){
            int page = state.preArticle != null ? state.preArticle.pageCount : 0 ;
            page = page + state.currentArticle.pageCount - 1;
//            print("PreArticleEvent jumpPage=$page  prePageCount=${state.preArticle != null ? state.preArticle.pageCount : 0} curPageCount=${state.currentArticle.pageCount}");
            pageController.jumpToPage(page);
          }
        },
        child: BlocBuilder<ReaderBloc, ReaderState>(
          bloc: _readerBloc,
          builder: (context, state) {
//            print("PreArticleEvent current = ${state.currentArticle.id} pre = ${state.preArticle == null ? "" : state.preArticle.id} next = ${state.nextArticle == null ? "" : state.nextArticle.id}");
            return Scaffold(
              body: Stack(
                children: <Widget>[
                  SafeArea(
                    child: _buildPageView(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageView() {
    ReaderState state = _readerBloc.currentState;
    if (state.currentArticle == null) {
      return Container();
    }
    int itemCount =
        (state.preArticle != null ? state.preArticle.pageCount : 0) +
            state.currentArticle.pageCount +
            (state.nextArticle != null ? state.nextArticle.pageCount : 0);
    print("itemCount=$itemCount");
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      controller: pageController,
      itemCount: itemCount,
      itemBuilder: buildPage,
      onPageChanged: onPageChanged,
    );
  }

  Widget buildPage(BuildContext context, int index) {
    var state = _readerBloc.currentState;
    var page =
        index - (state.preArticle != null ? state.preArticle.pageCount : 0);
    var article;
    if (page >= state.currentArticle.pageCount) {
      // 到达下一章了
      article = state.nextArticle;
      page = 0;
    } else if (page < 0) {
      // 到达上一章了
      article = state.preArticle;
      page = state.preArticle.pageCount - 1;
    } else {
      article = state.currentArticle;
    }

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        onTap(details.globalPosition);
      },
      child: ReaderView(
        article: article,
        page: page,
        fontSize: state.fontSize,
      ),
    );
  }
  onTap(Offset position) async {
    double xRate = position.dx / Screen.width;
    //点击中间弹出菜单
    if (xRate > 0.33 && xRate < 0.66) {
//      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
//      setState(() {
//        isMenuVisiable = true;
//      });
    } else if (xRate >= 0.66) {
      nextPage();
    } else {
      previousPage();
    }
  }

  previousPage() {
    ReaderState state = _readerBloc.currentState;
    if (state.pageIndex == 0 && state.currentArticle.preArticleId == 0) {
      Fluttertoast.showToast(msg:'已经是第一页了');
      return;
    }
    pageController.previousPage(duration: Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  nextPage() {
    ReaderState state = _readerBloc.currentState;
    if (state.pageIndex >= state.currentArticle.pageCount - 1 && state.currentArticle.nextArticleId == 0) {
      Fluttertoast.showToast(msg:'已经是最后一页了');

      return;
    }
    pageController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  onScroll() {
    var page = pageController.offset / Screen.width;
    ReaderState state = _readerBloc.currentState;
    var nextArtilePage = state.currentArticle.pageCount +
        (state.preArticle != null ? state.preArticle.pageCount : 0);
    if (page >= nextArtilePage) {
      print('到达下个章节了');
      _readerBloc.dispatch(NextArticleEvent());
    }
    if (state.preArticle != null && page <= state.preArticle.pageCount - 1) {
      print('到达上个章节了');
      _readerBloc.dispatch(PreArticleEvent());


    }
  }

  onPageChanged(int index) {
    _readerBloc.dispatch(PageChangeEvent(index));
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
