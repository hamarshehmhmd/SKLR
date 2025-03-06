import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklr/database/database.dart';
import 'package:sklr/database/userIdStorage.dart';

class AddSkillPage extends StatefulWidget {
  const AddSkillPage({super.key});
  @override
  AddSkillPageState createState() => AddSkillPageState();
}

class AddSkillPageState extends State<AddSkillPage> {
  String skillname = '';
  String skilldescription = '';
  double? skillcost;
  int? loggedInUserId;
  String? chosenCategory;
  String? errorMessage;
  List<String> _choices = [
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
    _loadUserId();
    _loadCategories();
  }

  Future<void> _loadUserId() async {
    final userId = await UserIdStorage.getLoggedInUserId();
    setState(() {
      loggedInUserId = userId;
    });
  }

  Future<void> _loadCategories() async {
    try {
      final result = await DatabaseHelper.fetchCategories();
      if (result.isNotEmpty) {
        setState(() {
          _choices = result.map((category) => category['name'] as String).toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Create New Skill",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: isLargeScreen ? 24 : 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF6296FF),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20)
          )
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF8F9FF),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? 32.0 : 16.0,
              vertical: 24.0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2A2D3E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        maxLength: 40,
                        maxLines: 1,
                        onChanged: (value) {
                          setState(() {
                            skillname = value;
                          });
                        },
                        style: GoogleFonts.poppins(),
                        decoration: InputDecoration(
                          hintText: "Enter title for your skill",
                          fillColor: const Color(0xFFF5F7FF),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.title, color: Color(0xFF6296FF)),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        "Description",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2A2D3E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            skilldescription = value;
                          });
                        },
                        maxLines: 4,
                        maxLength: 150,
                        style: GoogleFonts.poppins(),
                        decoration: InputDecoration(
                          hintText: "Describe your skill in detail",
                          fillColor: const Color(0xFFF5F7FF),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.description, color: Color(0xFF6296FF)),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        "Cost",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2A2D3E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              skillcost = double.tryParse(value);
                            } else {
                              skillcost = null;
                            }
                          });
                        },
                        style: GoogleFonts.poppins(),
                        decoration: InputDecoration(
                          hintText: "Enter cost in pounds (£)",
                          fillColor: const Color(0xFFF5F7FF),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF6296FF)),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        "Category",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2A2D3E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: chosenCategory,
                            hint: Text(
                              'Select a category',
                              style: GoogleFonts.poppins(),
                            ),
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6296FF)),
                            items: _choices.map((String choice) {
                              return DropdownMenuItem<String>(
                                value: choice,
                                child: Text(
                                  choice,
                                  style: GoogleFonts.poppins(),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                chosenCategory = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                
                if (errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      errorMessage!,
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      errorMessage = null;
                    });
                    
                    if (skillname.isEmpty || 
                        skilldescription.isEmpty || 
                        skillcost == null ||
                        chosenCategory == null) {
                      setState(() {
                        errorMessage = 'Please fill in all fields';
                      });
                      return;
                    }
                    
                    if (loggedInUserId == null) {
                      setState(() {
                        errorMessage = 'User ID not found. Please log in again.';
                      });
                      return;
                    }
                    
                    try {
                      // Check if skill name already exists for this user
                      bool skillExists = await DatabaseHelper.checkSkillName(
                        skillname, 
                        loggedInUserId
                      );
                      
                      if (skillExists) {
                        setState(() {
                          errorMessage = 'You already have a skill with this name';
                        });
                        return;
                      }
                      
                      // Insert the skill with proper parameters
                      final response = await DatabaseHelper.insertSkill(
                        loggedInUserId!,
                        skillname,
                        skilldescription,
                        chosenCategory!,
                        skillcost!
                      );
                      
                      if (response.success) {
                        Navigator.pop(context, true); // Pass true to indicate success
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Skill added successfully',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      } else {
                        setState(() {
                          errorMessage = 'Failed to add skill: ${response.message}';
                        });
                      }
                    } catch (e) {
                      setState(() {
                        errorMessage = 'Error: ${e.toString()}';
                      });
                      debugPrint('Error adding skill: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6296FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    "Create Skill",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
