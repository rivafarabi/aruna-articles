import 'package:aruna_articles/models/article_post.dart';
import 'package:aruna_articles/providers/article_provider.dart';
import 'package:aruna_articles/services/article_service.dart';
import 'package:aruna_articles/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

  late ArticleProvider provider;
  late MockArticleService mockService;

  setUp(() {
    mockService = MockArticleService();
    provider = ArticleProvider(mockService);
  });

  test("initial provider values", () {
    expect(provider.status, NetworkStatus.idle);
    expect(provider.articles, []);
  });

  group(':articles service test', () {
    void setArticlesFromService() {
      when(
        () => mockService.fetchArticles(),
      ).thenAnswer((_) async => mockArticles);
    }

    test(':fetch articles from ArticleService', () async {
      setArticlesFromService();
      expect(provider.status, NetworkStatus.idle);
      final future = provider.fetchArticles();
      expect(provider.status, NetworkStatus.fetching);
      await future;
      verify(() => mockService.fetchArticles()).called(1);
      expect(provider.articles, mockArticles);
      expect(provider.status, NetworkStatus.ready);
    });

    test(':reload articles from ArticleService', () async {
      setArticlesFromService();
      final future1 = provider.fetchArticles();

      expect(provider.status, NetworkStatus.fetching);
      await future1;
      expect(provider.status, NetworkStatus.ready);

      final future2 = provider.fetchArticles();
      expect(provider.status, NetworkStatus.reloading);
      await future2;
      expect(provider.status, NetworkStatus.ready);
    });

    group(':search article from existing list', () {
      test(':same case string title search', () async {
        setArticlesFromService();
        await provider.fetchArticles();
        provider.searchArticleByQuery('one');
        expect(provider.searchResults, [articleOne]);
      });

      test(':same case string body search', () async {
        setArticlesFromService();
        await provider.fetchArticles();
        provider.searchArticleByQuery('consectetur');
        expect(provider.searchResults, [articleTwo, articleThree]);
      });

      test(':diff case string body search', () async {
        setArticlesFromService();
        await provider.fetchArticles();
        provider.searchArticleByQuery('Amet, CONSectetUr');
        expect(provider.searchResults, [articleTwo]);
      });
    });
  });
}
