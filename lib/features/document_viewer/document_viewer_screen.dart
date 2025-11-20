import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/document.dart';
import '../../domain/entities/ai_summary_result.dart';
import '../../domain/entities/ai_search_hit.dart';
import '../../domain/entities/ai_chat_message.dart';
import 'widgets/ai_dock.dart';

/// Document viewer screen with PDF viewer and AI Dock
class DocumentViewerScreen extends StatefulWidget {
  final String documentId;
  final Document? document;

  const DocumentViewerScreen({
    super.key,
    required this.documentId,
    this.document,
  });

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  bool _showAiDock = false;
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // Mock document if not provided
    final doc = widget.document ??
        Document(
          id: widget.documentId,
          title: 'Sample Document.pdf',
          filePath: '/mock/sample.pdf',
          fileType: 'pdf',
          pageCount: 25,
          sizeBytes: 1500000,
          importedAt: DateTime.now(),
          lastOpenedAt: DateTime.now(),
          tags: [],
          isStarred: false,
          aiProcessed: true,
          userId: 'user1',
        );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doc.title,
              style: theme.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${isArabic ? 'صفحة' : 'Page'} $_currentPage / ${doc.pageCount}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showDocumentMenu(context, doc, isArabic),
          ),
        ],
      ),
      body: Column(
        children: [
          // PDF Viewer Area (mocked)
          Expanded(
            child: Stack(
              children: [
                // Mock PDF viewer
                _buildMockPdfViewer(doc, isArabic),

                // AI Dock overlay
                if (_showAiDock)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AiDock(
                      document: doc,
                      onClose: () => setState(() => _showAiDock = false),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom toolbar
          if (!_showAiDock)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      // TODO: Zoom out
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // TODO: Zoom in
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.brightness_6),
                    onPressed: () {
                      // TODO: Toggle dark mode
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _showAiDock = true),
                    icon: const Icon(Icons.auto_awesome, size: 20),
                    label: Text(isArabic ? 'مساعد AI' : 'AI'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentEmeraldGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMockPdfViewer(Document doc, bool isArabic) {
    return Container(
      color: AppColors.gray100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 16,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: AppColors.primaryInkBlue.withOpacity(0.05),
                    child: Row(
                      children: [
                        const Icon(Icons.picture_as_pdf, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            doc.title,
                            style: Theme.of(context).textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic
                                ? 'محتوى تجريبي للمستند'
                                : 'Mock PDF Content',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isArabic
                                ? 'هذا عارض PDF تجريبي. في التطبيق الحقيقي، سيتم عرض محتوى PDF الفعلي هنا باستخدام مكتبة مثل Syncfusion أو PDFView.'
                                : 'This is a mock PDF viewer. In the real app, actual PDF content would be rendered here using a library like Syncfusion or PDFView.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            '${isArabic ? 'صفحة' : 'Page'} $_currentPage ${isArabic ? 'من' : 'of'} ${doc.pageCount}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.gray500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: _currentPage > 1
                      ? () => setState(() => _currentPage--)
                      : null,
                  icon: Icon(isArabic ? Icons.chevron_right : Icons.chevron_left),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  onPressed: _currentPage < doc.pageCount
                      ? () => setState(() => _currentPage++)
                      : null,
                  icon: Icon(isArabic ? Icons.chevron_left : Icons.chevron_right),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDocumentMenu(BuildContext context, Document doc, bool isArabic) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.file_download),
              title: Text(isArabic ? 'تصدير كـ...' : 'Export as...'),
              onTap: () {
                Navigator.pop(context);
                _showExportOptions(context, isArabic);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: Text(isArabic ? 'مشاركة' : 'Share'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Share document
              },
            ),
            ListTile(
              leading: Icon(
                doc.isStarred ? Icons.star : Icons.star_border,
                color: doc.isStarred ? AppColors.warning : null,
              ),
              title: Text(
                isArabic
                    ? (doc.isStarred ? 'إزالة من المفضلة' : 'إضافة للمفضلة')
                    : (doc.isStarred ? 'Remove from favorites' : 'Add to favorites'),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Toggle star
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showExportOptions(BuildContext context, bool isArabic) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.text_snippet),
              title: Text(isArabic ? 'تحويل إلى نص' : 'Convert to Text'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Convert to text
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: Text(isArabic ? 'تحويل إلى Word' : 'Convert to Word'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Convert to DOCX
              },
            ),
          ],
        ),
      ),
    );
  }
}
