import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class _TaskState extends State<Task> {
  bool isChecked = false;

  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Today',
      'icon': Icons.today_outlined,
    },
    {
      'title': 'Scheduled',
      'icon': Icons.calendar_month_outlined,
    },
    {
      'title': 'Assigned to me',
      'icon': Icons.assignment_ind_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color.fromRGBO(214, 211, 211, 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.notifications_none,
                        size: 26,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    'DH',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color.fromRGBO(214, 211, 211, 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.notifications_none,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 25),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color.fromARGB(255, 216, 216, 216),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 24,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 61,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index != tasks.length - 1 ? 25 : 0,
                    ),
                    child: Container(
                      width: 106,
                      height: 61,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(239, 236, 248, 1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color.fromRGBO(206, 197, 231, 1),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            tasks[index]['icon'],
                            size: 22,
                            color: const Color(0xFF515152),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            tasks[index]['title'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF515152),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: 359,
              height: 408,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFEFECF8),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            size: 24,
                            color: const Color(0xFF7C7C7D),
                          ),
                        ),
                        Text(
                          'Development Team',
                          style: GoogleFonts.workSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4525A2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.more_vert,
                            size: 24,
                            color: const Color(0xFF7C7C7D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                side: const BorderSide(
                                  color: Color(0xFFCEC5E7),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Mobile App Design',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF515152),
                                ),
                              ),
                            ),
                            Text(
                              '0%',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF7C7C7D),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 132,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2CD),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 12,
                                    color: Color(0xFF2B2B2C),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Oct 12 1:00 PM',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                      color: const Color(0xFF2B2B2C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                height: 24,
                                width: 80,
                                child: Image.asset(
                                  'assets/images/Prof.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.more_horiz,
                              size: 24,
                              color: const Color(0xFF7C7C7D),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
