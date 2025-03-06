import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklr/database/database.dart';
import 'package:sklr/Skills/skillInfo.dart';

class SearchResultsPage extends StatefulWidget {
  final String search;
  const SearchResultsPage({super.key, required this.search});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late Future<List<Map<String, dynamic>>> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = _fetchSearchResults();
  }

  Future<List<Map<String, dynamic>>> _fetchSearchResults() async {
    if (widget.search.trim().isEmpty) {
      return [];
    }

    try {
      // Search in both skill names and descriptions
      final results = await DatabaseHelper.searchResults(widget.search.trim());

      // Sort results by relevance - exact matches first, then partial matches
      results.sort((a, b) {
        final aName = (a['name'] ?? '').toString().toLowerCase();
        final bName = (b['name'] ?? '').toString().toLowerCase();
        final searchLower = widget.search.toLowerCase();

        // Exact matches get highest priority
        if (aName == searchLower && bName != searchLower) return -1;
        if (bName == searchLower && aName != searchLower) return 1;

        // Then check if name contains search term
        final aContains = aName.contains(searchLower);
        final bContains = bName.contains(searchLower);
        if (aContains && !bContains) return -1;
        if (bContains && !aContains) return 1;

        // Finally sort alphabetically
        return aName.compareTo(bName);
      });

      return results;
    } catch (error) {
      throw Exception('Failed to fetch search results: $error');
    }
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Results for "${widget.search}"',
          style: GoogleFonts.mulish(
            color: Colors.white,
            fontSize: isLargeScreen ? 24 : 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF6296FF),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6296FF)),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: GoogleFonts.mulish(
                      fontSize: isLargeScreen ? 18 : 16,
                      color: Colors.red[700],
                    ),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off,
                      size: 60, color: Color(0xFF9094A7)),
                  const SizedBox(height: 16),
                  Text(
                    'No results found for "${widget.search}"',
                    style: GoogleFonts.mulish(
                      fontSize: isLargeScreen ? 20 : 18,
                      color: const Color(0xFF9094A7),
                    ),
                  ),
                ],
              ),
            );
          }

          final listings = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
            itemCount: listings.length,
            itemBuilder: (context, index) {
              final listing = listings[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Skillinfo(id: listing['id']),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listing['name'] ?? 'No Name',
                            style: GoogleFonts.mulish(
                              fontSize: isLargeScreen ? 22 : 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            listing['description'] ?? 'No Description',
                            style: GoogleFonts.mulish(
                              fontSize: isLargeScreen ? 16 : 14,
                              color: const Color(0xFF9094A7),
                              height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6296FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '£${(listing['cost'] ?? 0).toStringAsFixed(2)}',
                              style: GoogleFonts.mulish(
                                fontSize: isLargeScreen ? 16 : 14,
                                color: const Color(0xFF6296FF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder<DatabaseResponse>(
                            future: DatabaseHelper.fetchUserFromId(
                                listing['user_id']),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF6296FF)),
                                  ),
                                );
                              } else if (userSnapshot.hasError ||
                                  !userSnapshot.hasData) {
                                return Text(
                                  'Unknown User',
                                  style: GoogleFonts.mulish(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                );
                              }

                              final user = userSnapshot.data!.data;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF6296FF).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.person_outline,
                                      size: 18,
                                      color: Color(0xFF6296FF),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      user['username'] ?? 'Unknown User',
                                      style: GoogleFonts.mulish(
                                        fontSize: isLargeScreen ? 16 : 14,
                                        color: const Color(0xFF6296FF),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
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
}
