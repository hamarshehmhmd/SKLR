import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklr/service-categories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200.0),
          child: AppBar(
            backgroundColor: Color(0xFF6296FF),
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Hello, User! ',
                    style: GoogleFonts.lexend(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Let's find the best talent for you",
                    style: GoogleFonts.lexend(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 360.0,
                    height: 52,
                    child: TextField(
                      onChanged: (value) {
                        //search term
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon:
                            Icon(Icons.search, color: Color(0xFF6296FF)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Search service',
                        hintStyle: GoogleFonts.lexend(
                          textStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Service Category',
                    style: GoogleFonts.lexend(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 150),
                  Builder(
                    builder: (context) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceCategoryPage(),
                            ),
                          );
                        },
                        child: Text(
                          'See All',
                          style: GoogleFonts.lexend(
                            textStyle: TextStyle(
                              color: Color(0xFF6296FF),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      //naviagte to page for graphic design
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 74,
                          height: 74,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/images/paintbrush.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          'Graphic \n Design',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexend(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 18),
                  InkWell(
                    onTap: () {
                      //naviagte to page for digital marketing
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 74,
                          height: 74,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/images/marketing.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          'Digital \n Marketing',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexend(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 18),
                  InkWell(
                    onTap: () {
                      //naviagte to page for video and animation
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 74,
                          height: 74,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/images/video.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          'Video & \n Animation',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexend(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 18),
                  InkWell(
                    onTap: () {
                      //naviagte to page for program and tech
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 74,
                          height: 74,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/images/tech.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          'Program & \nTech',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexend(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      //naviagte to page for music and audio
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 74,
                          height: 74,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/images/music.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          'Music & \n Audio',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexend(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      // Navigate to page for product photography
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 74,
                          height: 74,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/images/photography.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          'Product \n Photography ',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexend(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      // Navigate to page for UI/UX design
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 74,
                          height: 74,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/images/design.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          'UI/UX \n Design ',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexend(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 18),
                  InkWell(
                    onTap: () {
                      // Navigate to page for build ai services
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 74,
                          height: 74,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/images/ai.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          'Build AI \n Services',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexend(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Text(
                    'Popular Services',
                    style: GoogleFonts.lexend(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 150),
                  Builder(
                    builder: (context) {
                      return InkWell(
                        onTap: () {
                          //go to popular service page
                        },
                        child: Text(
                          'See All',
                          style: GoogleFonts.lexend(
                            textStyle: TextStyle(
                              color: Color(0xFF6296FF),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey.shade300,
                width: 2.0,
              ),
            ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  color: Color(0xFF6296FF),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                label: 'My Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              // Go to different pages based on which you choose
            },
            selectedItemColor: Color(0xFF6296FF),
            unselectedItemColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}