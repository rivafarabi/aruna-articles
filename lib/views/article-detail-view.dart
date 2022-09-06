import 'package:aruna_articles/models/article_post.dart';
import 'package:flutter/material.dart';

class ArticleDetailView extends StatefulWidget {
  const ArticleDetailView({Key? key, required this.detail}) : super(key: key);
  final ArticlePost detail;

  @override
  State<ArticleDetailView> createState() => _ArticleDetailViewState();
}

class _ArticleDetailViewState extends State<ArticleDetailView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            primary: true,
            snap: true,
            centerTitle: false,
            titleSpacing: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          SliverFillRemaining(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.detail.title,
                    key: const Key('detail-title'),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.detail.body,
                    key: const Key('detail-body'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
