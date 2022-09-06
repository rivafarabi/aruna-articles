import 'package:aruna_articles/components/article_item.dart';
import 'package:aruna_articles/models/article_post.dart';
import 'package:aruna_articles/providers/article_provider.dart';
import 'package:aruna_articles/services/article_service.dart';
import 'package:aruna_articles/views/article_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockArticleService extends Mock implements ArticleService {}

void main() {
  final articleOne = ArticlePost(
    id: 1,
    userId: 1,
    title: "Test Article One",
    body: "Lorem ipsum dolor sit amet",
  );
  final articleTwo = ArticlePost(
    id: 2,
    userId: 1,
    title: "Test Article Two",
    body: "ipsum dolor sit amet, consectetur",
  );
  final articleThree = ArticlePost(
    id: 3,
    userId: 1,
    title: "Test Article Three",
    body: "consectetur adipiscing elit",
  );
  final mockArticles = [
    articleOne,
    articleTwo,
    articleThree,
  ];

  late MockArticleService mockService;

  setUp(() {
    mockService = MockArticleService();
  });

  void setArticlesFromService() {
    when(
      () => mockService.fetchArticles(),
    ).thenAnswer((_) async => mockArticles);
  }

  void setArticlesFromServiceDelayed3Seconds() {
    when(
      () => mockService.fetchArticles(),
    ).thenAnswer((_) async {
      await Future.delayed((const Duration(seconds: 3)));
      return mockArticles;
    });
  }

  void throwErrorFromService() {
    when(
      () => mockService.fetchArticles(),
    ).thenThrow({'message': 'error'});
  }

  Widget createTestWidget() {
    return ChangeNotifierProvider(
      create: (context) => ArticleProvider(mockService),
      child: MaterialApp(
        title: 'Aruna Articles',
        initialRoute: '/',
        routes: {
          '/': (context) => const ArticleListView(),
        },
      ),
    );
  }

  testWidgets(
    "search bar is visible",
    (WidgetTester tester) async {
      setArticlesFromService();
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Search article...'), findsOneWidget);
    },
  );

  testWidgets(
    "loading the articles from service",
    (WidgetTester tester) async {
      setArticlesFromServiceDelayed3Seconds();
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    "show error message",
    (WidgetTester tester) async {
      throwErrorFromService();
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(seconds: 1));
      expect(
        find.text('Error fetching data. Please try again later'),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    "refresh list if error occured",
    (WidgetTester tester) async {
      throwErrorFromService();
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(seconds: 1));
      expect(
        find.text('Error fetching data. Please try again later'),
        findsOneWidget,
      );

      var refreshBtn = find.byKey(const Key('article-refresh-btn'));

      setArticlesFromService();
      await tester.tap(refreshBtn);
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(ArticleItem), findsWidgets);
    },
  );

  testWidgets(
    "searching article with zero result",
    (WidgetTester tester) async {
      setArticlesFromService();
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      var searchField = find.byKey(const Key('article-searchbar'));

      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'invalid search');
      await tester.pump();
      expect(find.textContaining('invalid search'), findsOneWidget);
      expect(find.byType(ArticleItem), findsNothing);
    },
  );

  testWidgets(
    "searching article with one result",
    (WidgetTester tester) async {
      setArticlesFromService();
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      var searchField = find.byKey(const Key('article-searchbar'));

      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'One');
      await tester.pump();
      expect(find.textContaining('One'), findsWidgets);
      expect(find.byType(ArticleItem), findsOneWidget);
    },
  );
}
