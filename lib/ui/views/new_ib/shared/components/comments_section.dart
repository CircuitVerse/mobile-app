import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';

class CommentsSection extends StatelessWidget {
  const CommentsSection({super.key});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
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
    final comments = [
      {
        'author': 'Santam',
        'time': '2 hours ago',
        'text': 'Great explanation! This really helped me understand binary representation.',
        'likes': 12,
      },
      {
        'author': 'Roy',
        'time': '5 hours ago',
        'text': 'Can someone explain the difference between signed and unsigned numbers?',
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
      children: comments
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
              height: 1.5,
              color: IbTheme.textColor(context).withAlpha(204),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.thumb_up_outlined,
                      size: 18,
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
              const SizedBox(width: 24),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.reply_rounded,
                      size: 18,
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
            ],
          ),
        ],
      ),
    );
  }
}
