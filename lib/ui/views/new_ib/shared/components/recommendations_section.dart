import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_recommendation.dart';

class RecommendationsSection extends StatelessWidget {
  final List<IbRecommendation> recommendations;
  final bool loading;

  const RecommendationsSection({
    super.key,
    required this.recommendations,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
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
        if (recommendations.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'No recommendations available',
                style: TextStyle(
                  fontSize: 14,
                  color: IbTheme.textColor(context).withAlpha(128),
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendations.length > 5 ? 5 : recommendations.length,
              itemBuilder: (context, index) {
                final rec = recommendations[index];
                return _buildRecommendationCard(context, rec);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    IbRecommendation recommendation,
  ) {
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
                        value: loadingProgress.expectedTotalBytes != null
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
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.title,
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
                        if (formattedDate.isNotEmpty && recommendation.posts != null)
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
}
