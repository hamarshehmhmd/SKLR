import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'categoryListings.dart';

class ServiceCategoryPage extends StatelessWidget {
  const ServiceCategoryPage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'icon': "assets/images/paintbrush.png",
      'title': 'Graphic Design',
      'subtitle': 'Logo & brand identity',
    },
    {
      'icon': "assets/images/marketing.png", 
      'title': 'Digital Marketing',
      'subtitle': 'Social media marketing, SEO',
    },
    {
      'icon': "assets/images/video.png",
      'title': 'Video & Animation',
      'subtitle': 'Video editing & Video Ads',
    },
    {
      'icon': "assets/images/music.png",
      'title': 'Music & Audio',
      'subtitle': 'Producers & Composers',
    },
    {
      'icon': "assets/images/tech.png",
      'title': 'Program & Tech',
      'subtitle': 'Website & App development',
    },
    {
      'icon': "assets/images/photography.png",
      'title': 'Product Photography',
      'subtitle': 'Product photographers',
    },
    {
      'icon': "assets/images/ai.png",
      'title': 'Build AI Service',
      'subtitle': 'Build your AI app',
    },
    {
      'icon': "assets/images/data.png",
      'title': 'Data',
      'subtitle': 'Data science & AI',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service Category',
          style: GoogleFonts.mulish(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFF6296FF),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryListingsPage(
                      categoryName: category['title'],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6296FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            category['icon'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category['title'],
                              style: GoogleFonts.mulish(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF2D3142),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category['subtitle'],
                              style: GoogleFonts.mulish(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFF2D3142).withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: const Color(0xFF2D3142).withOpacity(0.5),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      backgroundColor: const Color(0xFFF5F7FA),
    );
  }
}