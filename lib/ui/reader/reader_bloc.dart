import 'package:bloc/bloc.dart';
import 'package:ice_book/data/entity/article_entity.dart';
import 'package:ice_book/data/text.dart';
import 'reader_page_agent.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  @override
  // TODO: implement initialState
  ReaderState get initialState => ReaderState(pageIndex: 0, fontSize: 16);

  @override
  Stream<ReaderState> mapEventToState(ReaderEvent event) async* {
    print(event.toString());
    currentState.event = event;
    if (event is InitPageEvent) {
      yield* _initBook(event);
    } else if (event is NextArticleEvent) {
      yield* _nextArticle();
    } else if (event is PreArticleEvent) {
      yield* _preArticle();
    } else if (event is PageChangeEvent) {
      yield* _pageChange(event.index);
    } else if (event is MenuEvent){
      yield currentState.copyWith(showMenu: !currentState.showMenu);
    } else if (event is FontEvent){
      yield* _fontChange(event.fontSize);
    }
  }

  Stream<ReaderState> _initBook(InitPageEvent event) async* {
    ReaderState state = currentState.copyWith(
      pageIndex: event.pageIndex,
      fontSize: event.fontSize,
      contentWidth: event.contentWidth,
      contentHeight: event.contentHeight,
    );
    yield state;
    state.currentArticle =  await fetchArticle(event.articleId, contentWidth: event.contentWidth, contentHeight: event.contentHeight);
    if (state.currentArticle.nextArticleId != null &&
        state.currentArticle.nextArticleId > 0) {
      state.nextArticle =
      await fetchArticle(state.currentArticle.nextArticleId,contentWidth: event.contentWidth, contentHeight: event.contentHeight);
    }
    if (state.currentArticle.preArticleId != null &&
        state.currentArticle.preArticleId > 0) {
      state.preArticle = await fetchArticle(state.currentArticle.preArticleId,contentWidth: event.contentWidth, contentHeight: event.contentHeight);
    }
    yield state.copyWith();
  }

  Stream<ReaderState> _nextArticle() async* {
    ReaderState state = currentState.copyWith(
        preArticle: currentState.currentArticle,
        currentArticle: currentState.nextArticle, pageIndex: 0);
    state.nextArticle = null;

    yield state;
    if (state.currentArticle.nextArticleId != null &&
        state.currentArticle.nextArticleId > 0) {
      state.nextArticle =
      await fetchArticle(state.currentArticle.nextArticleId);
    }
    yield state.copyWith();
  }

  Stream<ReaderState> _preArticle() async* {
    print("_preArticle");
    ReaderState state  = currentState.copyWith(
      currentArticle: currentState.preArticle,
      nextArticle: currentState.currentArticle,
      pageIndex: currentState.preArticle.pageCount - 1,
    );
    state.preArticle = null;
    yield state;
    if (state.currentArticle.preArticleId != null &&
        state.currentArticle.preArticleId > 0) {
      state.preArticle = await fetchArticle(state.currentArticle.preArticleId);
    }
    yield state.copyWith();
  }

  Stream<ReaderState> _pageChange(int index) async* {
    var page = index - (currentState.preArticle != null
        ? currentState.preArticle.pageCount
        : 0);
    if (page < currentState.currentArticle.pageCount && page >= 0) {
      yield currentState.copyWith(pageIndex: page);
    }

  }
  Stream<ReaderState> _fontChange(double fontSize) async*{
    ReaderState state = currentState.copyWith(fontSize: fontSize);
    state.currentArticle.pageOffsets = ReaderPageAgent.getPageOffsets(
        state.currentArticle.content,
        currentState.contentHeight,
        currentState.contentWidth,
        currentState.fontSize);
    if (state.preArticle != null){
      state.preArticle.pageOffsets = ReaderPageAgent.getPageOffsets(
          state.preArticle.content,
          currentState.contentHeight,
          currentState.contentWidth,
          currentState.fontSize);
    }
    if (state.nextArticle != null){
      state.nextArticle.pageOffsets = ReaderPageAgent.getPageOffsets(
          state.nextArticle.content,
          currentState.contentHeight,
          currentState.contentWidth,
          currentState.fontSize);
    }
    yield state;


  }


  Future<ArticleEntity> fetchArticle(int articleId, {double contentWidth, double contentHeight}) async{
    var article;
    articleList.forEach((f){
      if (articleId == f.id){
        article = f;
      }
    });
    if (article == null){
      return article;
    }
    article.pageOffsets = ReaderPageAgent.getPageOffsets(
        article.content,
        contentHeight?? currentState.contentHeight,
        contentWidth?? currentState.contentWidth,
        currentState.fontSize);

    return article;
  }

}

class ReaderState {
  ReaderEvent event;
  int pageIndex;
  double fontSize;
  double contentWidth;
  double contentHeight;
  ArticleEntity preArticle;
  ArticleEntity currentArticle;
  ArticleEntity nextArticle;
  bool showMenu;

  ReaderState({
    this.event,
    this.pageIndex,
    this.fontSize,
    this.contentWidth,
    this.contentHeight,
    this.preArticle,
    this.currentArticle,
    this.nextArticle,
  this.showMenu = false});

  ReaderState copyWith({ReaderEvent event, int pageIndex,
    double fontSize,
    double contentWidth,
    double contentHeight,
    ArticleEntity preArticle,
    ArticleEntity currentArticle,
    ArticleEntity nextArticle,
  bool showMenu}) {
    return ReaderState(
      event: event?? this.event,
        pageIndex: pageIndex ?? this.pageIndex,
        fontSize: fontSize ?? this.fontSize,
        contentWidth: contentWidth ?? this.contentWidth,
        contentHeight: contentHeight ?? this.contentHeight,
        preArticle: preArticle ?? this.preArticle,
        currentArticle: currentArticle ?? this.currentArticle,
        nextArticle: nextArticle ?? this.nextArticle,
    showMenu: showMenu?? this.showMenu);
  }
}

class ReaderEvent {}

class NextArticleEvent extends ReaderEvent {}

class PreArticleEvent extends ReaderEvent {}

class MenuEvent extends ReaderEvent{

}

class InitPageEvent extends ReaderEvent {
  double fontSize;
  int bookId; //图书ID
  int articleId; //章节ID
  int pageIndex; //页
  double contentWidth; //显示区域宽度  用于计算分页数据
  double contentHeight; //显示区域高度

  InitPageEvent({
    this.fontSize,
    this.bookId,
    this.articleId,
    this.pageIndex,
    this.contentWidth,
    this.contentHeight,
  });
}

class PageChangeEvent extends ReaderEvent {
  int index;

  PageChangeEvent(this.index);

}

class FontEvent extends ReaderEvent{
  double fontSize;

  FontEvent(this.fontSize);

}
