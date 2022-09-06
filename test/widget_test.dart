import 'package:aruna_articles/components/article_item.dart';
import 'package:aruna_articles/models/article_post.dart';
import 'package:aruna_articles/providers/article_provider.dart';
import 'package:aruna_articles/services/article_service.dart';
import 'package:aruna_articles/views/article-detail-view.dart';
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

  Future<void> renderInitialList(WidgetTester tester) async {
    setArticlesFromService();
    await tester.pumpWidget(createTestWidget());
    await tester.pump();
  }

  group('article test view', () {
    testWidgets(
      "search bar is visible",
      (WidgetTester tester) async {
        await renderInitialList(tester);
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
        await renderInitialList(tester);

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
        await renderInitialList(tester);

        var searchField = find.byKey(const Key('article-searchbar'));

        expect(searchField, findsOneWidget);

        await tester.enterText(searchField, 'One');
        await tester.pump();
        expect(find.textContaining('One'), findsWidgets);
        expect(find.byType(ArticleItem), findsOneWidget);
      },
    );

    testWidgets("navigate to 'Test Article Two' detail page",
        (WidgetTester tester) async {
      await renderInitialList(tester);

      var articleTwoCard = find.byType(ArticleItem).at(1);

      await tester.tap(articleTwoCard);
      await tester.pumpAndSettle();

      expect(find.byType(ArticleDetailView), findsOneWidget);

      var detailTitleWidget = find.byKey(const Key('detail-title'));
      var detailBodyWidget = find.byKey(const Key('detail-body'));
      var detailTitleText = detailTitleWidget.evaluate().single.widget as Text;
      var detailBodyText = detailBodyWidget.evaluate().single.widget as Text;

      expect(detailTitleWidget, findsOneWidget);
      expect(detailTitleText.data, articleTwo.title);

      expect(detailBodyWidget, findsOneWidget);
      expect(detailBodyText.data, articleTwo.body);
    });
  });
}
