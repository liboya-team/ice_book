import 'package:bloc/bloc.dart';
import 'package:ice_book/data/entity/article_entity.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState>{
  @override
  // TODO: implement initialState
  ReaderState get initialState => ReaderState(fontSize: 16);

  @override
  Stream<ReaderState> mapEventToState(ReaderEvent event) {
    // TODO: implement mapEventToState
    return null;
  }

}

class ReaderState {
  double fontSize;
  ArticleEntity preArticle;
  ArticleEntity currentArticle;
  ArticleEntity nextArticle;

  ReaderState({this.fontSize, this.preArticle, this.currentArticle,
      this.nextArticle});

}

class ReaderEvent{}