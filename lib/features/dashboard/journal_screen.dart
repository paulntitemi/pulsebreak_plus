import 'package:flutter/material.dart';

class JournalEntry {
  final String id;
  final DateTime date;
  final String title;
  final String content;
  final String mood;
  final List<String> tags;

  JournalEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.mood,
    required this.tags,
  });
}

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final List<JournalEntry> _allEntries = [
    JournalEntry(
      id: '1',
      date: DateTime.now().subtract(const Duration(days: 1)),
      title: 'Great Day at Work',
      content: 'Had an amazing productive day. Completed the project milestone and felt really good about the progress. The team was supportive and collaborative.',
      mood: '😊',
      tags: ['work', 'productive', 'team'],
    ),
    JournalEntry(
      id: '2',
      date: DateTime.now().subtract(const Duration(days: 3)),
      title: 'Morning Reflection',
      content: 'Woke up feeling grateful today. Had a peaceful morning with coffee and watched the sunrise. Planning to make this a regular practice.',
      mood: '😌',
      tags: ['gratitude', 'morning', 'mindfulness'],
    ),
    JournalEntry(
      id: '3',
      date: DateTime.now().subtract(const Duration(days: 7)),
      title: 'Weekend Adventures',
      content: 'Went hiking with friends. The weather was perfect and the views were breathtaking. Feeling recharged and ready for the week ahead.',
      mood: '😍',
      tags: ['adventure', 'friends', 'nature'],
    ),
  ];

  List<JournalEntry> _filteredEntries = [];
  String _searchQuery = '';
  String _selectedMoodFilter = '';
  String _selectedTagFilter = '';
  DateTime? _startDateFilter;
  DateTime? _endDateFilter;
  bool _isSearchMode = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredEntries = _allEntries;
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        _applyFilters();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          },
          child: _isSearchMode 
              ? _buildSearchBar()
              : _buildTitle(),
        ),
        centerTitle: false,
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isSearchMode
                ? IconButton(
                    key: const ValueKey('close'),
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFF6B7280),
                    ),
                    onPressed: _exitSearchMode,
                  )
                : Row(
                    key: const ValueKey('actions'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Color(0xFF6B7280),
                        ),
                        onPressed: _enterSearchMode,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.filter_list,
                          color: Color(0xFF6B7280),
                        ),
                        onPressed: () => _showFilterDialog(),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      body: _filteredEntries.isEmpty ? _buildEmptyState() : _buildJournalList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateEntryDialog(),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Entry'),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Journal',
      key: ValueKey('title'),
      style: TextStyle(
        color: Color(0xFF2E3A59),
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      key: const ValueKey('searchbar'),
      height: 40,
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search journal entries...',
          hintStyle: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF6B7280),
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Color(0xFF6B7280),
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color(0xFF8B5CF6),
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        style: const TextStyle(
          color: Color(0xFF2E3A59),
          fontSize: 16,
        ),
        onSubmitted: (value) {
          // Optional: Handle search submission
        },
      ),
    );
  }

  void _enterSearchMode() {
    setState(() {
      _isSearchMode = true;
    });
  }

  void _exitSearchMode() {
    setState(() {
      _isSearchMode = false;
      _searchController.clear();
      _searchQuery = '';
      _applyFilters();
    });
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 80,
            color: Color(0xFFBBBBBB),
          ),
          SizedBox(height: 24),
          Text(
            'Start Your Journal',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3A59),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Capture your thoughts, feelings, and daily reflections. Your personal space for mindful writing.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with stats
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8F4F8),
                  Color(0xFFF0F9FF),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Journey',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_allEntries.length} entries • ${_getStreakDays()} day streak',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_stories,
                    color: Color(0xFF8B5CF6),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Recent Entries Section
          const Text(
            'Recent Entries',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),

          const SizedBox(height: 16),

          // Filter summary (search is now in app bar)
          if (_selectedMoodFilter.isNotEmpty || _selectedTagFilter.isNotEmpty || _startDateFilter != null || _endDateFilter != null)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _buildFilterSummary(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _clearFilters,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Entries List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredEntries.length,
              itemBuilder: (context, index) {
                final entry = _filteredEntries[index];
                return _buildJournalEntryCard(entry);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalEntryCard(JournalEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date and mood
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(entry.date),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  entry.mood,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Content preview
          Text(
            entry.content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),

          // Tags and actions
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  children: entry.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$tag',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )).toList(),
                ),
              ),
              GestureDetector(
                onTap: () => _showEntryDetails(entry),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateEntryDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateEntryModal(
        onSave: (title, content, mood, tags) {
          setState(() {
            _allEntries.insert(0, JournalEntry(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              date: DateTime.now(),
              title: title,
              content: content,
              mood: mood,
              tags: tags,
            ));
            _applyFilters();
          });
        },
      ),
    );
  }

  void _showEntryDetails(JournalEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EntryDetailsModal(entry: entry),
    );
  }


  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterModal(
        selectedMood: _selectedMoodFilter,
        selectedTag: _selectedTagFilter,
        startDate: _startDateFilter,
        endDate: _endDateFilter,
        onApplyFilters: (mood, tag, startDate, endDate) {
          setState(() {
            _selectedMoodFilter = mood;
            _selectedTagFilter = tag;
            _startDateFilter = startDate;
            _endDateFilter = endDate;
            _applyFilters();
          });
        },
      ),
    );
  }

  void _applyFilters() {
    _filteredEntries = _allEntries.where((entry) {
      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final titleMatch = entry.title.toLowerCase().contains(searchLower);
        final contentMatch = entry.content.toLowerCase().contains(searchLower);
        final tagMatch = entry.tags.any((tag) => tag.toLowerCase().contains(searchLower));
        
        if (!titleMatch && !contentMatch && !tagMatch) {
          return false;
        }
      }

      // Mood filter
      if (_selectedMoodFilter.isNotEmpty && entry.mood != _selectedMoodFilter) {
        return false;
      }

      // Tag filter
      if (_selectedTagFilter.isNotEmpty && !entry.tags.contains(_selectedTagFilter)) {
        return false;
      }

      // Date range filter
      if (_startDateFilter != null && entry.date.isBefore(_startDateFilter!)) {
        return false;
      }
      
      if (_endDateFilter != null && entry.date.isAfter(_endDateFilter!.add(const Duration(days: 1)))) {
        return false;
      }

      return true;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _selectedMoodFilter = '';
      _selectedTagFilter = '';
      _startDateFilter = null;
      _endDateFilter = null;
      _applyFilters();
    });
  }

  String _buildFilterSummary() {
    List<String> filters = [];
    
    if (_selectedMoodFilter.isNotEmpty) {
      filters.add('Mood: $_selectedMoodFilter');
    }
    
    if (_selectedTagFilter.isNotEmpty) {
      filters.add('Tag: #$_selectedTagFilter');
    }
    
    if (_startDateFilter != null || _endDateFilter != null) {
      if (_startDateFilter != null && _endDateFilter != null) {
        filters.add('Date: ${_formatDateShort(_startDateFilter!)} - ${_formatDateShort(_endDateFilter!)}');
      } else if (_startDateFilter != null) {
        filters.add('From: ${_formatDateShort(_startDateFilter!)}');
      } else if (_endDateFilter != null) {
        filters.add('Until: ${_formatDateShort(_endDateFilter!)}');
      }
    }
    
    String summary = filters.join(' • ');
    return '$summary (${_filteredEntries.length} ${_filteredEntries.length == 1 ? 'entry' : 'entries'})';
  }

  String _formatDateShort(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  int _getStreakDays() {
    // Simple streak calculation - can be enhanced
    return _allEntries.isNotEmpty ? 5 : 0;
  }
}

class _CreateEntryModal extends StatefulWidget {
  final Function(String title, String content, String mood, List<String> tags) onSave;

  const _CreateEntryModal({required this.onSave});

  @override
  State<_CreateEntryModal> createState() => _CreateEntryModalState();
}

class _CreateEntryModalState extends State<_CreateEntryModal> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedMood = '😊';
  final List<String> _selectedTags = [];
  
  final List<String> _availableMoods = ['😊', '😌', '😔', '😤', '😟', '😴', '🤔', '😍'];
  final List<String> _availableTags = [
    'work', 'family', 'friends', 'health', 'gratitude', 'goals', 
    'reflection', 'learning', 'travel', 'exercise', 'mindfulness'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'New Journal Entry',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _saveEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'What happened today?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Mood
                  const Text(
                    'How are you feeling?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: _availableMoods.map((mood) => GestureDetector(
                      onTap: () => setState(() => _selectedMood = mood),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedMood == mood 
                              ? const Color(0xFF8B5CF6).withValues(alpha: 0.1)
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedMood == mood 
                                ? const Color(0xFF8B5CF6)
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(mood, style: const TextStyle(fontSize: 24)),
                      ),
                    )).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Content
                  const Text(
                    'Your thoughts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contentController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'Write about your day, thoughts, or feelings...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tags
                  const Text(
                    'Tags (optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableTags.map((tag) => GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_selectedTags.contains(tag)) {
                            _selectedTags.remove(tag);
                          } else {
                            _selectedTags.add(tag);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedTags.contains(tag)
                              ? const Color(0xFF8B5CF6).withValues(alpha: 0.1)
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedTags.contains(tag)
                                ? const Color(0xFF8B5CF6)
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          '#$tag',
                          style: TextStyle(
                            fontSize: 14,
                            color: _selectedTags.contains(tag)
                                ? const Color(0xFF8B5CF6)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    )).toList(),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveEntry() {
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both title and content')),
      );
      return;
    }

    widget.onSave(
      _titleController.text.trim(),
      _contentController.text.trim(),
      _selectedMood,
      _selectedTags,
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Journal entry saved!')),
    );
  }
}

class _EntryDetailsModal extends StatelessWidget {
  final JournalEntry entry;

  const _EntryDetailsModal({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    entry.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date and mood
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formatDate(entry.date),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          entry.mood,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Content
                  Text(
                    entry.content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4B5563),
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tags
                  if (entry.tags.isNotEmpty) ...[
                    const Text(
                      'Tags',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: entry.tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '#$tag',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF8B5CF6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )).toList(),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}


class _FilterModal extends StatefulWidget {
  final String selectedMood;
  final String selectedTag;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(String mood, String tag, DateTime? startDate, DateTime? endDate) onApplyFilters;

  const _FilterModal({
    required this.selectedMood,
    required this.selectedTag,
    required this.startDate,
    required this.endDate,
    required this.onApplyFilters,
  });

  @override
  State<_FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<_FilterModal> {
  late String _selectedMood;
  late String _selectedTag;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _availableMoods = ['😊', '😌', '😔', '😤', '😟', '😴', '🤔', '😍'];
  final List<String> _availableTags = [
    'work', 'family', 'friends', 'health', 'gratitude', 'goals', 
    'reflection', 'learning', 'travel', 'exercise', 'mindfulness',
    'productive', 'team', 'morning', 'adventure', 'nature'
  ];

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.selectedMood;
    _selectedTag = widget.selectedTag;
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Filter Journal Entries',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: const Text('Clear All'),
                ),
                ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mood Filter
                  const Text(
                    'Filter by Mood',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: _availableMoods.map((mood) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMood = _selectedMood == mood ? '' : mood;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedMood == mood 
                              ? const Color(0xFF8B5CF6).withValues(alpha: 0.1)
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedMood == mood 
                                ? const Color(0xFF8B5CF6)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Text(mood, style: const TextStyle(fontSize: 24)),
                      ),
                    )).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Tag Filter
                  const Text(
                    'Filter by Tag',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableTags.map((tag) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTag = _selectedTag == tag ? '' : tag;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedTag == tag
                              ? const Color(0xFF8B5CF6).withValues(alpha: 0.1)
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedTag == tag
                                ? const Color(0xFF8B5CF6)
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          '#$tag',
                          style: TextStyle(
                            fontSize: 14,
                            color: _selectedTag == tag
                                ? const Color(0xFF8B5CF6)
                                : const Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Date Range Filter
                  const Text(
                    'Filter by Date Range',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Start Date
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'From Date',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectStartDate(context),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 16, color: Color(0xFF6B7280)),
                                    const SizedBox(width: 8),
                                    Text(
                                      _startDate != null ? _formatDateShort(_startDate!) : 'Select date',
                                      style: TextStyle(
                                        color: _startDate != null ? const Color(0xFF2E3A59) : const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'To Date',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectEndDate(context),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 16, color: Color(0xFF6B7280)),
                                    const SizedBox(width: 8),
                                    Text(
                                      _endDate != null ? _formatDateShort(_endDate!) : 'Select date',
                                      style: TextStyle(
                                        color: _endDate != null ? const Color(0xFF2E3A59) : const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _clearAllFilters() {
    setState(() {
      _selectedMood = '';
      _selectedTag = '';
      _startDate = null;
      _endDate = null;
    });
  }

  void _applyFilters() {
    widget.onApplyFilters(_selectedMood, _selectedTag, _startDate, _endDate);
    Navigator.pop(context);
  }

  String _formatDateShort(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}