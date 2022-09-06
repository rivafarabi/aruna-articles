import 'package:aruna_articles/models/article_post.dart';
import 'package:aruna_articles/services/article_service.dart';
import 'package:aruna_articles/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class ArticleProvider extends ChangeNotifier {
  final ArticleService _service;
  List<ArticlePost> _articles = [];
  List<ArticlePost> _searchResults = [];
  String _searchQuery = '';
  NetworkStatus _status = NetworkStatus.idle;

  ArticleProvider(this._service);

  List<ArticlePost> get articles => _articles;
  NetworkStatus get status => _status;
  String get searchQuery => _searchQuery;
  List<ArticlePost> get searchResults => _searchResults;

  Future<void> fetchArticles() async {
    try {
      _status = _status == NetworkStatus.ready
          ? NetworkStatus.reloading
          : NetworkStatus.fetching;

      notifyListeners();

      _articles = await _service.fetchArticles();

      _status = NetworkStatus.ready;
      notifyListeners();
    } catch (err) {
      _status = NetworkStatus.error;
      notifyListeners();
    }
  }

  void searchArticleByQuery(String query) {
    RegExp exp = RegExp(query, caseSensitive: false);
    _searchQuery = query;
    _searchResults = _articles
        .where((article) =>
            exp.hasMatch(article.title) || exp.hasMatch(article.body))
        .toList();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults.clear();
    notifyListeners();
  }

  void openArticle(int index) async {}
}
