import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklr/database/database.dart';
import 'package:sklr/Skills/skillInfo.dart';
import '../database/models.dart';

class SearchResultsPage extends StatefulWidget {
  final String search;
  const SearchResultsPage({super.key, required this.search});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late Future<List<Map<String, dynamic>>> _searchResults;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  bool _isSearching = false;
  String? _selectedCategory;
  String _sortBy = 'recent'; // Default sort

  // Add your categories here
  final List<String> _categories = [
    'Cooking & Baking',
    'Fitness',
    'IT & Tech',
    'Languages',
    'Music & Audio',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.search;
    _searchResults = _fetchSearchResults();
  }

  Future<List<Map<String, dynamic>>> _fetchSearchResults() async {
    if (_searchController.text.trim().isEmpty) {
      return [];
    }

    setState(() => _isSearching = true);
    try {
      final results = await DatabaseHelper.searchResults(
        _searchController.text.trim(),
        category: _selectedCategory,
        minPrice: _minPriceController.text.isNotEmpty
            ? double.parse(_minPriceController.text)
            : null,
        maxPrice: _maxPriceController.text.isNotEmpty
            ? double.parse(_maxPriceController.text)
            : null,
        sortBy: _sortBy,
      );
      return results;
    } catch (err) {
      throw Exception('Failed to fetch search results: $err');
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _handleSearch() {
    setState(() {
      _searchResults = _fetchSearchResults();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Filter Results',
                style: GoogleFonts.mulish(
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category dropdown
                    Text(
                      'Category',
                      style: GoogleFonts.mulish(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: InputBorder.none,
                        ),
                        hint: Text(
                          'Select category',
                          style: GoogleFonts.mulish(color: Colors.grey),
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text(
                              'All Categories',
                              style: GoogleFonts.mulish(),
                            ),
                          ),
                          ..._categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(
                                category,
                                style: GoogleFonts.mulish(),
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Price range
                    Text(
                      'Price Range',
                      style: GoogleFonts.mulish(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Min',
                              hintStyle: GoogleFonts.mulish(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              prefixText: '£',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _maxPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Max',
                              hintStyle: GoogleFonts.mulish(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              prefixText: '£',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Sort by
                    Text(
                      'Sort By',
                      style: GoogleFonts.mulish(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _sortBy,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: InputBorder.none,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'recent',
                            child: Text(
                              'Most Recent',
                              style: GoogleFonts.mulish(),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'price_asc',
                            child: Text(
                              'Price: Low to High',
                              style: GoogleFonts.mulish(),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'price_desc',
                            child: Text(
                              'Price: High to Low',
                              style: GoogleFonts.mulish(),
                            ),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _sortBy = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = null;
                      _minPriceController.clear();
                      _maxPriceController.clear();
                      _sortBy = 'recent';
                    });
                  },
                  child: Text(
                    'Reset',
                    style: GoogleFonts.mulish(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleSearch();
                  },
                  child: Text(
                    'Apply',
                    style: GoogleFonts.mulish(
                      color: const Color(0xFF6296FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          style: GoogleFonts.mulish(
            color: Colors.white,
            fontSize: isLargeScreen ? 20 : 18,
          ),
          decoration: InputDecoration(
            hintText: 'Search skills...',
            hintStyle: GoogleFonts.mulish(
              color: Colors.white70,
              fontSize: isLargeScreen ? 20 : 18,
            ),
            border: InputBorder.none,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: _showFilterDialog,
                  tooltip: 'Filter results',
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: _handleSearch,
                  tooltip: 'Search',
                ),
              ],
            ),
          ),
          onSubmitted: (_) => _handleSearch(),
        ),
        backgroundColor: const Color(0xFF6296FF),
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _searchResults,
        builder: (context, snapshot) {
          if (_isSearching) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6296FF)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Searching...',
                    style: GoogleFonts.mulish(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: GoogleFonts.mulish(
                      fontSize: 16,
                      color: Colors.red[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6296FF).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search_off,
                      size: 64,
                      color: Color(0xFF6296FF),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No results found',
                    style: GoogleFonts.mulish(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Try different keywords or check your spelling',
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final skill = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Skillinfo(id: skill['id']),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6296FF).withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6296FF).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getCategoryIcon(skill['category']),
                                  color: const Color(0xFF6296FF),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      skill['name'] ?? 'Unnamed Skill',
                                      style: GoogleFonts.mulish(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                          Text(
                                      skill['category'] ?? 'Uncategorized',
                                      style: GoogleFonts.mulish(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6296FF).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '£${(skill['cost'] ?? 0).toStringAsFixed(2)}',
                            style: GoogleFonts.mulish(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF6296FF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            skill['description'] ?? 'No description available',
                            style: GoogleFonts.mulish(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          FutureBuilder<DatabaseResponse>(
                            future: DatabaseHelper.fetchUserFromId(skill['user_id']),
                            builder: (context, userSnapshot) {
                              if (!userSnapshot.hasData) {
                                return const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF6296FF),
                                    ),
                                  ),
                                );
                              }

                              final user = userSnapshot.data!.data;
                              return Row(
                                  children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(0xFF6296FF).withOpacity(0.1),
                                    child: Text(
                                      (user['username'] ?? 'U')[0].toUpperCase(),
                                      style: GoogleFonts.mulish(
                                        color: const Color(0xFF6296FF),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    user['username'] ?? 'Unknown User',
                                    style: GoogleFonts.mulish(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'cooking & baking':
        return Icons.restaurant;
      case 'fitness':
        return Icons.fitness_center;
      case 'it & tech':
        return Icons.computer;
      case 'languages':
        return Icons.translate;
      case 'music & audio':
        return Icons.music_note;
      default:
        return Icons.category;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }
}
