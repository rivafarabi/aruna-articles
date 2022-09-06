import 'package:aruna_articles/models/article_post.dart';
import 'package:aruna_articles/providers/article_provider.dart';
import 'package:aruna_articles/services/article_service.dart';
import 'package:aruna_articles/views/article-detail-view.dart';
import 'package:aruna_articles/views/article_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArticleProvider(ArticleService()),
      child: MaterialApp(
        title: 'Aruna Articles',
        initialRoute: '/',
        routes: {
          '/': (context) => const ArticleListView(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/post') {
            return MaterialPageRoute(builder: (context) {
              ArticlePost articlePost = settings.arguments as ArticlePost;
              return ArticleDetailView(detail: articlePost);
            });
          }

          return null;
        },
      ),
    );
  }
}
