import 'package:flutter/material.dart';
import '../domain/entities/document.dart';
import '../core/theme/app_colors.dart';

/// Card widget displaying document information
class DocumentCard extends StatelessWidget {
  final Document document;
  final VoidCallback onTap;
  final VoidCallback? onStar;
  final VoidCallback? onMore;

  const DocumentCard({
    super.key,
    required this.document,
    required this.onTap,
    this.onStar,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // File type icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryInkBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getFileIcon(document.fileType),
                      color: AppColors.primaryInkBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title and metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.title,
                          style: theme.textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${document.pageCount} pages • ${document.formattedSize}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  // Actions
                  if (onStar != null)
                    IconButton(
                      icon: Icon(
                        document.isStarred
                            ? Icons.star
                            : Icons.star_border,
                        color: document.isStarred
                            ? AppColors.warning
                            : null,
                      ),
                      onPressed: onStar,
                    ),
                  if (onMore != null)
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: onMore,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Badges and tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (document.aiProcessed)
                    _buildBadge(
                      context,
                      'AI Ready',
                      AppColors.accentEmeraldGreen,
                    ),
                  ...document.tags.take(3).map((tag) =>
                      _buildTagChip(context, tag)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildTagChip(BuildContext context, String tag) {
    return Chip(
      label: Text(tag),
      labelStyle: Theme.of(context).textTheme.labelSmall,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'docx':
      case 'doc':
        return Icons.description;
      case 'txt':
        return Icons.text_snippet;
      case 'imagescan':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}
