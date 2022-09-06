import 'package:aruna_articles/components/article_item.dart';
import 'package:aruna_articles/components/searchbar.dart';
import 'package:aruna_articles/providers/article_provider.dart';
import 'package:aruna_articles/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticleListView extends StatefulWidget {
  const ArticleListView({Key? key}) : super(key: key);

  @override
  State<ArticleListView> createState() => _ArticleListViewState();
}

class _ArticleListViewState extends State<ArticleListView> {
  final TextEditingController _searchbarController = TextEditingController();
  final FocusNode _searchbarNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ArticleProvider>().fetchArticles());
  }

  @override
  void dispose() {
    super.dispose();
    _searchbarController.dispose();
    _searchbarNode.dispose();
  }

  void openSearchView() {
    _searchbarNode.requestFocus();
  }

  void closeSearchView() {
    _searchbarController.clear();
    context.read<ArticleProvider>().clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ArticleProvider>();

    late Widget bodyWidget;

    switch (provider.status) {
      case NetworkStatus.fetching:
        bodyWidget = const Center(
          child: CircularProgressIndicator(),
        );
        break;
      case NetworkStatus.idle:
        bodyWidget = const Center(
          child: CircularProgressIndicator(),
        );
        break;
      case NetworkStatus.error:
        bodyWidget = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_sharp,
                size: 48,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text('Error fetching data. Please try again later'),
              TextButton(
                key: const Key('article-refresh-btn'),
                onPressed: () => provider.fetchArticles(),
                child: const Text('Refresh'),
              )
            ],
          ),
        );
        break;
      default:
        var viewedList = _searchbarController.text.isNotEmpty
            ? provider.searchResults
            : provider.articles;

        bodyWidget = RefreshIndicator(
          onRefresh: provider.fetchArticles,
          child: viewedList.isNotEmpty
              ? ListView.builder(
                  itemCount: viewedList.length,
                  itemBuilder: (context, index) =>
                      ArticleItem(data: viewedList[index]),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.search_sharp,
                        size: 48,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text('No result found')
                    ],
                  ),
                ),
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Searchbar(
          key: const Key('article-searchbar'),
          caption: 'Search article...',
          controller: _searchbarController,
          focusNode: _searchbarNode,
          onSubmitted: (text) => _searchbarNode.unfocus(),
          onChanged: provider.searchArticleByQuery,
          onClear: closeSearchView,
        ),
      ),
      body: bodyWidget,
    );
  }
}
