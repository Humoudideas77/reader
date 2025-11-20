import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/routing/app_router.dart';
import '../../domain/entities/document.dart';
import '../../widgets/document_card.dart';
import '../../widgets/empty_state_widget.dart';

/// Library/Home screen showing user's documents
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _selectedFilter = 'all'; // all, starred, recent
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Mock documents (in real app, would come from repository via Riverpod)
  final List<Document> _mockDocuments = [
    Document(
      id: '1',
      title: 'Introduction to Machine Learning.pdf',
      filePath: '/mock/ml-intro.pdf',
      fileType: 'pdf',
      pageCount: 45,
      sizeBytes: 2500000,
      importedAt: DateTime.now().subtract(const Duration(days: 2)),
      lastOpenedAt: DateTime.now().subtract(const Duration(hours: 3)),
      tags: ['AI', 'Study'],
      isStarred: true,
      aiProcessed: true,
      userId: 'user1',
    ),
    Document(
      id: '2',
      title: 'Annual Report 2024.pdf',
      filePath: '/mock/report-2024.pdf',
      fileType: 'pdf',
      pageCount: 120,
      sizeBytes: 8500000,
      importedAt: DateTime.now().subtract(const Duration(days: 5)),
      lastOpenedAt: DateTime.now().subtract(const Duration(days: 1)),
      tags: ['Work', 'Reports'],
      isStarred: false,
      aiProcessed: true,
      userId: 'user1',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Document> get _filteredDocuments {
    var docs = _mockDocuments;

    if (_selectedFilter == 'starred') {
      docs = docs.where((doc) => doc.isStarred).toList();
    } else if (_selectedFilter == 'recent') {
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      docs = docs.where((doc) => doc.lastOpenedAt.isAfter(sevenDaysAgo)).toList();
    }

    if (_searchQuery.isNotEmpty) {
      docs = docs
          .where((doc) =>
              doc.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return docs;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final filteredDocs = _filteredDocuments;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accentEmeraldGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_stories,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(isArabic ? 'مكتبتي' : 'My Library'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRouter.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: isArabic ? 'بحث في المستندات...' : 'Search documents...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip(
                  context,
                  'all',
                  isArabic ? 'الكل' : 'All',
                  Icons.folder,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  'starred',
                  isArabic ? 'المفضلة' : 'Starred',
                  Icons.star,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  'recent',
                  isArabic ? 'الأخيرة' : 'Recent',
                  Icons.access_time,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Document list
          Expanded(
            child: filteredDocs.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.description_outlined,
                    title: isArabic ? 'لا توجد مستندات بعد' : 'No documents yet',
                    subtitle: isArabic
                        ? 'استورد أول ملف PDF أو مستند للبدء'
                        : 'Import your first PDF or document to get started',
                    action: ElevatedButton.icon(
                      onPressed: _showImportOptions,
                      icon: const Icon(Icons.add),
                      label: Text(isArabic ? 'إضافة مستند' : 'Add Document'),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      return DocumentCard(
                        document: doc,
                        onTap: () => _openDocument(doc),
                        onStar: () => _toggleStar(doc),
                        onMore: () => _showDocumentMenu(doc),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: filteredDocs.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _showImportOptions,
              icon: const Icon(Icons.add),
              label: Text(isArabic ? 'إضافة' : 'Add'),
            )
          : null,
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    final isSelected = _selectedFilter == value;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected
                ? AppColors.accentEmeraldGreen
                : Theme.of(context).textTheme.bodyMedium?.color,
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
    );
  }

  void _openDocument(Document doc) {
    context.push('/document/${doc.id}', extra: doc);
  }

  void _toggleStar(Document doc) {
    setState(() {
      // TODO: Update via repository
      final index = _mockDocuments.indexWhere((d) => d.id == doc.id);
      if (index != -1) {
        _mockDocuments[index] = doc.copyWith(isStarred: !doc.isStarred);
      }
    });
  }

  void _showDocumentMenu(Document doc) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(isArabic ? 'إعادة تسمية' : 'Rename'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show rename dialog
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
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: Text(
                isArabic ? 'حذف' : 'Delete',
                style: const TextStyle(color: AppColors.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteDocument(doc);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImportOptions() {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.folder),
              title: Text(isArabic ? 'من الجهاز' : 'From Device'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Open file picker
                _showComingSoonSnackbar();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(isArabic ? 'مسح ضوئي بالكاميرا' : 'Scan with Camera'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Open camera for scanning
                _showComingSoonSnackbar();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteDocument(Document doc) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'حذف المستند' : 'Delete Document'),
        content: Text(
          isArabic
              ? 'هل أنت متأكد أنك تريد حذف هذا المستند؟'
              : 'Are you sure you want to delete this document?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _mockDocuments.removeWhere((d) => d.id == doc.id);
              });
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(isArabic ? 'حذف' : 'Delete'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonSnackbar() {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic
              ? 'هذه الميزة قيد التطوير'
              : 'This feature is coming soon',
        ),
      ),
    );
  }
}
