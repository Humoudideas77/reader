import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/document.dart';
import '../../../domain/entities/ai_summary_result.dart';
import '../../../domain/entities/ai_search_hit.dart';
import '../../../domain/entities/ai_chat_message.dart';
import '../../../data/services/document_ai_service.dart';

/// AI Dock widget with Summary, Ask, and Search tabs
class AiDock extends StatefulWidget {
  final Document document;
  final VoidCallback onClose;

  const AiDock({
    super.key,
    required this.document,
    required this.onClose,
  });

  @override
  State<AiDock> createState() => _AiDockState();
}

class _AiDockState extends State<AiDock> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MockDocumentAiService _aiService = MockDocumentAiService();

  // Summary tab state
  AiSummaryResult? _summary;
  bool _summaryLoading = false;

  // Search tab state
  List<AiSearchHit> _searchResults = [];
  bool _searchLoading = false;
  final TextEditingController _searchController = TextEditingController();

  // Chat tab state
  List<AiChatMessage> _chatMessages = [];
  bool _chatLoading = false;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.gray200),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.accentEmeraldGreen,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isArabic ? 'المساعد الذكي' : 'AI Assistant',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: AppColors.accentEmeraldGreen,
            unselectedLabelColor: theme.textTheme.bodyMedium?.color,
            indicatorColor: AppColors.accentEmeraldGreen,
            tabs: [
              Tab(text: isArabic ? 'ملخص' : 'Summary'),
              Tab(text: isArabic ? 'اسأل' : 'Ask'),
              Tab(text: isArabic ? 'بحث' : 'Search'),
            ],
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTab(isArabic),
                _buildChatTab(isArabic),
                _buildSearchTab(isArabic),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTab(bool isArabic) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary mode buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _generateSummary(SummaryMode.short),
                  icon: const Icon(Icons.short_text, size: 18),
                  label: Text(isArabic ? 'قصير' : 'Short'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _generateSummary(SummaryMode.detailed),
                  icon: const Icon(Icons.subject, size: 18),
                  label: Text(isArabic ? 'مفصل' : 'Detailed'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Loading or summary content
          if (_summaryLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Generating summary...'),
                  ],
                ),
              ),
            )
          else if (_summary != null)
            _buildSummaryCard(_summary!, isArabic)
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  isArabic
                      ? 'اختر نوع الملخص للبدء'
                      : 'Select a summary mode to begin',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.gray500,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(AiSummaryResult summary, bool isArabic) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(
                    summary.mode == SummaryMode.short
                        ? (isArabic ? 'ملخص قصير' : 'Short Summary')
                        : (isArabic ? 'ملخص مفصل' : 'Detailed Summary'),
                  ),
                  backgroundColor: AppColors.accentEmeraldGreen.withOpacity(0.1),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: summary.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isArabic ? 'تم النسخ' : 'Copied'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              summary.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTab(bool isArabic) {
    return Column(
      children: [
        // Chat messages
        Expanded(
          child: _chatMessages.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      isArabic
                          ? 'اسأل أي شيء عن هذا المستند'
                          : 'Ask anything about this document',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.gray500,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _chatScrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, index) {
                    return _buildChatMessage(_chatMessages[index], isArabic);
                  },
                ),
        ),

        // Loading indicator
        if (_chatLoading)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                SizedBox(width: 16),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('AI is thinking...'),
              ],
            ),
          ),

        // Input field
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.gray200),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  decoration: InputDecoration(
                    hintText: isArabic ? 'اطرح سؤالاً...' : 'Ask a question...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendChatMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _sendChatMessage,
                icon: Icon(isArabic ? Icons.send : Icons.send),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.accentEmeraldGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatMessage(AiChatMessage message, bool isArabic) {
    final isUser = message.role == MessageRole.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accentEmeraldGreen.withOpacity(0.1),
              child: const Icon(
                Icons.auto_awesome,
                size: 16,
                color: AppColors.accentEmeraldGreen,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primaryInkBlue
                    : AppColors.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isUser ? Colors.white : null,
                        ),
                  ),
                  if (message.sourceReference != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      message.sourceReference!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isUser
                                ? Colors.white70
                                : AppColors.gray500,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryInkBlue.withOpacity(0.1),
              child: const Icon(
                Icons.person,
                size: 16,
                color: AppColors.primaryInkBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchTab(bool isArabic) {
    return Column(
      children: [
        // Search input
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: isArabic ? 'ابحث عن فكرة...' : 'Search for a concept...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _performSearch,
              ),
            ),
            onSubmitted: (_) => _performSearch(),
          ),
        ),

        // Search results
        Expanded(
          child: _searchLoading
              ? const Center(child: CircularProgressIndicator())
              : _searchResults.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          isArabic
                              ? 'ابحث عن أي مفهوم في المستند'
                              : 'Search for any concept in the document',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.gray500,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        return _buildSearchResult(_searchResults[index], isArabic);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildSearchResult(AiSearchHit hit, bool isArabic) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: Jump to page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${isArabic ? 'الانتقال إلى صفحة' : 'Jump to page'} ${hit.pageNumber}',
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Chip(
                    label: Text('${isArabic ? 'صفحة' : 'Page'} ${hit.pageNumber}'),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: AppColors.accentEmeraldGreen.withOpacity(0.1),
                  ),
                  const Spacer(),
                  Text(
                    '${(hit.score * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.gray500,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                hit.snippet,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Actions

  Future<void> _generateSummary(SummaryMode mode) async {
    setState(() {
      _summaryLoading = true;
    });

    try {
      final summary = await _aiService.summarizeDocument(widget.document, mode);
      setState(() {
        _summary = summary;
        _summaryLoading = false;
      });
    } catch (e) {
      setState(() {
        _summaryLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _sendChatMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty || _chatLoading) return;

    final userMessage = AiChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.user,
      content: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _chatMessages.add(userMessage);
      _chatController.clear();
      _chatLoading = true;
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    try {
      final response = await _aiService.chatWithDocument(
        widget.document,
        _chatMessages,
        text,
      );

      setState(() {
        _chatMessages.add(response);
        _chatLoading = false;
      });

      // Scroll to bottom again
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_chatScrollController.hasClients) {
          _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      setState(() {
        _chatLoading = false;
      });
    }
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty || _searchLoading) return;

    setState(() {
      _searchLoading = true;
    });

    try {
      final results = await _aiService.semanticSearch(widget.document, query);
      setState(() {
        _searchResults = results;
        _searchLoading = false;
      });
    } catch (e) {
      setState(() {
        _searchLoading = false;
      });
    }
  }
}
