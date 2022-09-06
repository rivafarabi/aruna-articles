import 'package:dio/dio.dart';
import 'package:aruna_articles/models/article_post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleService {
  late SharedPreferences prefs;

  ArticleService() {
    SharedPreferences.getInstance().then((value) => prefs = value);
  }

  Future<List<ArticlePost>> fetchArticles() async {
    try {
      var response = await Dio().get(
        'https://jsonplaceholder.typicode.com/posts',
        options: Options(
          headers: {
            'Content-type': 'application/json',
          },
        ),
      );
      var mapList = response.data as List<dynamic>;
      var articles = mapList.map((e) => ArticlePost.fromJson(e)).toList();
      return articles;
    } catch (err) {
      rethrow;
    }
  }
}
