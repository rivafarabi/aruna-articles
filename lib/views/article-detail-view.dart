import 'dart:math';

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
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1024) {
      return Material(
        child: Row(
          children: [
            Container(
              width: max(screenWidth / 3 + 200, 400),
              color: Colors.black,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BackButton(
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 400,
                      child: Text(
                        widget.detail.title,
                        key: const Key('detail-title'),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 96, 16, 16),
                      child: Text(
                        widget.detail.body,
                        key: const Key('detail-body'),
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black87),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

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
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
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
