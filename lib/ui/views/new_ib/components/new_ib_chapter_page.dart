import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/models/ib/ib_json_page_data.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/models/ib/ib_recommendation.dart';
import 'package:mobile_app/services/API/disqus_api.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/new_ib/components/json_content_renderer.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_markdown_parser.dart';
import 'package:mobile_app/ui/views/new_ib/components/structured_content_renderer.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';

class NewIbChapterPage extends StatefulWidget {
  final IbChapter chapter;
  final Function(IbChapter?) onNavigate;

  const NewIbChapterPage({
    super.key,
    required this.chapter,
    required this.onNavigate,
  });

  @override
  State<NewIbChapterPage> createState() => _NewIbChapterPageState();
}

class _NewIbChapterPageState extends State<NewIbChapterPage> {
  final ScrollController _scrollController = ScrollController();
  final DisqusApi _disqusApi = locator<DisqusApi>();
  final Map<String, GlobalKey> _headingKeys = {};
  bool _showFloatingButtons = true;
  List<IbRecommendation> _recommendations = [];
  bool _loadingRecommendations = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _loadRecommendations();
    _headingKeys.clear();
  }

  Future<void> _loadRecommendations() async {
    try {
      // Build the URL from the chapter ID
      final baseUrl = 'https://learn.circuitverse.org';
      final chapterId = widget.chapter.id.replaceAll('.md', '');
      final chapterPath = chapterId.replaceAll('docs/', '/docs/');
      final fullUrl = '$baseUrl$chapterPath/';

      final recommendations = await _disqusApi.fetchRecommendations(fullUrl);
      if (mounted) {
        setState(() {
          _recommendations = recommendations;
          _loadingRecommendations = false;
        });
      }
    } catch (e) {
      print('Error loading recommendations: $e');
      // Use fallback recommendations if API fails
      if (mounted) {
        setState(() {
          _recommendations = [
            IbRecommendation(
              title: 'Binary Arithmetic',
              url:
                  'https://learn.circuitverse.org/docs/binary-representation/binary-arithmetic/',
            ),
            IbRecommendation(
              title: 'Signed Numbers',
              url:
                  'https://learn.circuitverse.org/docs/binary-representation/signed-numbers/',
            ),
            IbRecommendation(
              title: 'Logic Gates',
              url: 'https://learn.circuitverse.org/docs/logic-gates/',
            ),
            IbRecommendation(
              title: 'Boolean Algebra',
              url: 'https://learn.circuitverse.org/docs/boolean-algebra/',
            ),
            IbRecommendation(
              title: 'Combinational Logic',
              url: 'https://learn.circuitverse.org/docs/combinational-logic/',
            ),
          ];
          _loadingRecommendations = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    // Hide buttons when scrolling down, show when scrolling up
    if (_scrollController.position.userScrollDirection == AxisDirection.down) {
      if (_showFloatingButtons) {
        setState(() => _showFloatingButtons = false);
      }
    } else if (_scrollController.position.userScrollDirection ==
        AxisDirection.up) {
      if (!_showFloatingButtons) {
        setState(() => _showFloatingButtons = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<IbPageViewModel>(
      onModelReady: (model) {
        // Use JSON API for binary-representation pages
        final isBinaryRepresentation = widget.chapter.id.contains(
          'binary-representation',
        );
        if (isBinaryRepresentation) {
          // Convert chapter ID to path format
          String path = widget.chapter.id.replaceAll('.md', '');
          model.fetchJsonPageData(path: path);
        } else {
          model.fetchPageData(id: widget.chapter.id);
        }
      },
      builder: (context, model, child) {
        // Show loading spinner while fetching
        if (model.isBusy(model.IB_FETCH_PAGE_DATA)) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error message if fetch failed
        if (model.isError(model.IB_FETCH_PAGE_DATA)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: IbTheme.textColor(context).withAlpha(128),
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load content',
                  style: TextStyle(
                    fontSize: 18,
                    color: IbTheme.textColor(context).withAlpha(179),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  model.errorMessageFor(model.IB_FETCH_PAGE_DATA),
                  style: TextStyle(
                    fontSize: 14,
                    color: IbTheme.textColor(context).withAlpha(128),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Check if we have JSON data or regular page data
        final hasJsonData = model.jsonPageData != null;
        final hasPageData = model.pageData != null;

        if (!hasJsonData && !hasPageData) {
          return Center(
            child: Text(
              'No content available',
              style: TextStyle(
                fontSize: 16,
                color: IbTheme.textColor(context).withAlpha(179),
              ),
            ),
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasJsonData)
                    _buildJsonContent(context, model.jsonPageData!)
                  else if (hasPageData)
                    _buildContent(context, model.pageData!),
                  // Show recommendations and comments for Binary Numbers and Binary Representation index page
                  if (widget.chapter.id.contains('binary-numbers') ||
                      widget.chapter.id.contains(
                        'binary-representation/index',
                      )) ...[
                    const SizedBox(height: 32),
                    _buildAlsoOnInteractiveBook(context),
                    const SizedBox(height: 32),
                    _buildCommentsSection(context),
                  ],
                  const SizedBox(height: 80), // Space for floating buttons
                ],
              ),
            ),
            _buildFloatingButtons(context),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, IbPageData pageData) {
    // Show "Coming Soon" for all pages except Binary Numbers and Binary Representation main page
    final isBinaryNumbers = widget.chapter.id.contains('binary-numbers');
    final isBinaryRepresentation = widget.chapter.id.contains(
      'binary-representation/index',
    );

    if (!isBinaryNumbers && !isBinaryRepresentation) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 80,
              color: IbTheme.getPrimaryColor(context).withAlpha(128),
            ),
            const SizedBox(height: 24),
            Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: IbTheme.primaryHeadingColor(context),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This page is under development',
              style: TextStyle(
                fontSize: 16,
                color: IbTheme.textColor(context).withAlpha(179),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chapter Title
        Text(
          widget.chapter.value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: IbTheme.primaryHeadingColor(context),
          ),
        ),
        const SizedBox(height: 8),
        Divider(thickness: 2, color: IbTheme.getPrimaryColor(context)),
        const SizedBox(height: 24),

        // Table of Contents
        if (pageData.tableOfContents != null &&
            pageData.tableOfContents!.isNotEmpty)
          _buildTableOfContents(context, pageData.tableOfContents!),

        // Content from API
        if (pageData.content != null && pageData.content!.isNotEmpty)
          ...pageData.content!.map((content) {
            if (content is IbMd) {
              // Check if we have structured content from the raw page data
              final rawPageData = pageData.rawPageData;
              if (rawPageData?.structuredContent != null &&
                  rawPageData!.structuredContent!.isNotEmpty) {
                // Use structured content renderer
                return StructuredContentRenderer(
                  content: rawPageData.structuredContent!,
                  headingKeys: NewIbMarkdownParser.headingKeys,
                );
              } else {
                // Fallback to markdown parser
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: NewIbMarkdownParser.parse(context, content.content),
                );
              }
            }
            return const SizedBox.shrink();
          }),

        // Chapter Contents (for parent pages like Binary Representation index)
        if (pageData.chapterOfContents != null &&
            pageData.chapterOfContents!.isNotEmpty)
          _buildChapterContents(context, pageData.chapterOfContents!),
      ],
    );
  }

  Widget _buildJsonContent(BuildContext context, IbJsonPageData jsonPageData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chapter Title
        Text(
          jsonPageData.title,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: IbTheme.primaryHeadingColor(context),
          ),
        ),
        if (jsonPageData.description != null) ...[
          const SizedBox(height: 8),
          Text(
            jsonPageData.description!,
            style: TextStyle(
              fontSize: 16,
              color: IbTheme.textColor(context).withAlpha(179),
            ),
          ),
        ],
        const SizedBox(height: 8),
        Divider(thickness: 2, color: IbTheme.getPrimaryColor(context)),
        const SizedBox(height: 24),

        // JSON Content
        if (jsonPageData.content != null &&
            jsonPageData.content!.sections.isNotEmpty)
          JsonContentRenderer(
            sections: jsonPageData.content!.sections,
            headingKeys: _headingKeys,
          ),

        // Children (for parent pages like Binary Representation index)
        if (jsonPageData.children != null && jsonPageData.children!.isNotEmpty)
          _buildJsonChildren(context, jsonPageData.children!),
      ],
    );
  }

  Widget _buildJsonChildren(BuildContext context, List<IbJsonChild> children) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            children
                .map((child) => _buildJsonChildCard(context, child))
                .toList(),
      ),
    );
  }

  Widget _buildJsonChildCard(BuildContext context, IbJsonChild child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IbTheme.textColor(context).withAlpha(26)),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to child page
          final childChapter = IbChapter(
            id: '${child.path}.md',
            value: child.title,
            navOrder: child.navOrder ?? '',
          );
          widget.onNavigate(childChapter);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: IbTheme.getPrimaryColor(context).withAlpha(51),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.article_rounded,
                  color: IbTheme.getPrimaryColor(context),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: IbTheme.primaryHeadingColor(context),
                      ),
                    ),
                    if (child.level != null)
                      Text(
                        'Level: ${child.level}',
                        style: TextStyle(
                          fontSize: 13,
                          color: IbTheme.textColor(context).withAlpha(128),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: IbTheme.textColor(context).withAlpha(128),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableOfContents(BuildContext context, List<IbTocItem> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IbTheme.textColor(context).withAlpha(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Table of contents',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: IbTheme.primaryHeadingColor(context),
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => _buildTocItem(context, item, 0)),
        ],
      ),
    );
  }

  Widget _buildTocItem(BuildContext context, IbTocItem item, int level) {
    final keyName = item.content
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _scrollToSection(keyName),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.only(
              left: level * 16.0,
              top: 8,
              bottom: 8,
              right: 8,
            ),
            child: Row(
              children: [
                if (item.leading.isNotEmpty)
                  Text(
                    '${item.leading} ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: IbTheme.getPrimaryColor(context),
                    ),
                  ),
                Expanded(
                  child: Text(
                    item.content,
                    style: TextStyle(
                      fontSize: 15,
                      color: IbTheme.textColor(context),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: IbTheme.textColor(context).withAlpha(128),
                ),
              ],
            ),
          ),
        ),
        if (item.items != null && item.items!.isNotEmpty)
          ...item.items!.map(
            (subItem) => _buildTocItem(context, subItem, level + 1),
          ),
      ],
    );
  }

  void _scrollToSection(String keyName) {
    final key = _headingKeys[keyName];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  Widget _buildChapterContents(BuildContext context, List<IbTocItem> items) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            items
                .map((item) => _buildChapterContentCard(context, item))
                .toList(),
      ),
    );
  }

  Widget _buildChapterContentCard(BuildContext context, IbTocItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IbTheme.textColor(context).withAlpha(26)),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to chapter
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: IbTheme.getPrimaryColor(context).withAlpha(51),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.article_rounded,
                  color: IbTheme.getPrimaryColor(context),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.content,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: IbTheme.primaryHeadingColor(context),
                      ),
                    ),
                    if (item.leading.isNotEmpty)
                      Text(
                        'Chapter ${item.leading}',
                        style: TextStyle(
                          fontSize: 13,
                          color: IbTheme.textColor(context).withAlpha(128),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: IbTheme.textColor(context).withAlpha(128),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlsoOnInteractiveBook(BuildContext context) {
    if (_loadingRecommendations) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories_rounded,
                color: IbTheme.getPrimaryColor(context),
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Also on Interactive Book',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: IbTheme.primaryHeadingColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (_recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_stories_rounded,
              color: IbTheme.getPrimaryColor(context),
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Also on Interactive Book',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: IbTheme.primaryHeadingColor(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:
                _recommendations.length > 5 ? 5 : _recommendations.length,
            itemBuilder: (context, index) {
              final recommendation = _recommendations[index];
              return _buildSuggestionCard(
                context,
                recommendation.title,
                recommendation.url,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(BuildContext context, String title, String url) {
    // Find the recommendation to get image, createdAt, and posts
    final recommendation = _recommendations.firstWhere(
      (r) => r.url == url,
      orElse: () => IbRecommendation(title: title, url: url),
    );

    // Format date
    String formattedDate = '';
    if (recommendation.createdAt != null) {
      try {
        final date = DateTime.parse(recommendation.createdAt!);
        formattedDate =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      } catch (e) {
        formattedDate = '';
      }
    }

    return Container(
      width: 280,
      height: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IbTheme.textColor(context).withAlpha(26)),
        color: IbTheme.getPrimaryColor(context).withAlpha(51),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            if (recommendation.image != null)
              Image.network(
                recommendation.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: ${recommendation.image}');
                  print('Error: $error');
                  return Container(
                    color: IbTheme.getPrimaryColor(context).withAlpha(51),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: IbTheme.getPrimaryColor(context).withAlpha(51),
                    child: Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    ),
                  );
                },
              ),
            // Dark overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Content
            InkWell(
              onTap: () {
                // TODO: Navigate to suggested chapter by URL
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (formattedDate.isNotEmpty) ...[
                          const Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                        if (formattedDate.isNotEmpty &&
                            recommendation.posts != null)
                          const SizedBox(width: 12),
                        if (recommendation.posts != null) ...[
                          const Icon(
                            Icons.comment,
                            size: 12,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${recommendation.posts} comment${recommendation.posts! > 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.comment_rounded,
              color: IbTheme.getPrimaryColor(context),
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Comments',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: IbTheme.primaryHeadingColor(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCommentInput(context),
        const SizedBox(height: 24),
        _buildCommentsList(context),
      ],
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IbTheme.textColor(context).withAlpha(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share your thoughts or ask a question...',
              hintStyle: TextStyle(
                color: IbTheme.textColor(context).withAlpha(128),
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(color: IbTheme.textColor(context), fontSize: 16),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Submit comment
              },
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Post Comment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: IbTheme.getPrimaryColor(context),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList(BuildContext context) {
    // Mock comments data
    final comments = [
      {
        'author': 'Santam',
        'time': '2 hours ago',
        'text':
            'Great explanation! This really helped me understand binary representation.',
        'likes': 12,
      },
      {
        'author': 'Roy',
        'time': '5 hours ago',
        'text':
            'Can someone explain the difference between signed and unsigned numbers?',
        'likes': 5,
      },
      {
        'author': 'Choudhury',
        'time': '1 day ago',
        'text': 'The examples are very clear. Thanks for this resource!',
        'likes': 8,
      },
    ];

    return Column(
      children:
          comments
              .map(
                (comment) => _buildCommentCard(
                  context,
                  comment['author'] as String,
                  comment['time'] as String,
                  comment['text'] as String,
                  comment['likes'] as int,
                ),
              )
              .toList(),
    );
  }

  Widget _buildCommentCard(
    BuildContext context,
    String author,
    String time,
    String text,
    int likes,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IbTheme.textColor(context).withAlpha(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: IbTheme.getPrimaryColor(context).withAlpha(51),
                child: Text(
                  author[0].toUpperCase(),
                  style: TextStyle(
                    color: IbTheme.getPrimaryColor(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: IbTheme.primaryHeadingColor(context),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: IbTheme.textColor(context).withAlpha(128),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: IbTheme.textColor(context),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              InkWell(
                onTap: () {
                  // TODO: Like comment
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: IbTheme.textColor(context).withAlpha(26),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.thumb_up_outlined,
                        size: 16,
                        color: IbTheme.textColor(context).withAlpha(179),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$likes',
                        style: TextStyle(
                          fontSize: 14,
                          color: IbTheme.textColor(context).withAlpha(179),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () {
                  // TODO: Reply to comment
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: IbTheme.textColor(context).withAlpha(26),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.reply_rounded,
                        size: 16,
                        color: IbTheme.textColor(context).withAlpha(179),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Reply',
                        style: TextStyle(
                          fontSize: 14,
                          color: IbTheme.textColor(context).withAlpha(179),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButtons(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: IgnorePointer(
        ignoring: !_showFloatingButtons,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _showFloatingButtons ? 1.0 : 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.chapter.prev != null)
                FloatingActionButton(
                  heroTag: 'prev_button',
                  onPressed: () => widget.onNavigate(widget.chapter.prev),
                  backgroundColor: IbTheme.getPrimaryColor(context),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                )
              else
                const SizedBox(width: 56),
              if (widget.chapter.next != null)
                FloatingActionButton(
                  heroTag: 'next_button',
                  onPressed: () => widget.onNavigate(widget.chapter.next),
                  backgroundColor: IbTheme.getPrimaryColor(context),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                )
              else
                const SizedBox(width: 56),
            ],
          ),
        ),
      ),
    );
  }
}
