import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/custom_search_field.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class TaskItem {
  final String title;
  final String time;
  final Color dateBackgroundColor;
  bool isChecked;

  TaskItem({
    required this.title,
    required this.time,
    required this.dateBackgroundColor,
    this.isChecked = false,
  });
}

class _TaskState extends State<Task> {
  bool isChecked = false;
  bool isExpanded = true;

  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Today',
      'image': 'assets/images/today.png',
    },
    {
      'title': 'Scheduled',
      'image': 'assets/images/schedule.png',
    },
    {
      'title': 'Assigned to me',
      'image': 'assets/images/assign.png',
    },
  ];

  final List<TaskItem> taskItems = [
    TaskItem(
      title: 'Mobile App Design',
      time: 'Oct 12 1:00 PM',
      dateBackgroundColor: const Color(0xFFFEF2CD),
    ),
    TaskItem(
      title: 'Calendar Integration',
      time: 'Oct 15 2:30 PM',
      dateBackgroundColor: const Color(0xFFFEF2CD),
    ),
    TaskItem(
      title: 'Cloud-based backend for task data and messages',
      time: 'Oct 20 4:00 PM',
      dateBackgroundColor: const Color(0xFFFBD9D7),
    ),
  ];

  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _memberController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _dueTimeController = TextEditingController();

  void _addNewTask() {
    if (_taskNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task name'),
          backgroundColor: Color(0xFF4525A2),
        ),
      );
      return;
    }

    setState(() {
      taskItems.insert(
        0, // Add at the beginning of the list
        TaskItem(
          title: _taskNameController.text,
          time: '${_dueDateController.text} ${_dueTimeController.text}',
          dateBackgroundColor: const Color(0xFFFEF2CD),
        ),
      );
    });

    // Clear all controllers
    _taskNameController.clear();
    _memberController.clear();
    _dueDateController.clear();
    _dueTimeController.clear();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task added successfully'),
        backgroundColor: Color(0xFF4525A2),
        duration: Duration(seconds: 2),
      ),
    );

    // Close bottom sheet
    Navigator.pop(context);
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            // Clear controllers when dismissing the sheet
            _taskNameController.clear();
            _memberController.clear();
            _dueDateController.clear();
            _dueTimeController.clear();
            return true;
          },
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3E3E3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Task',
                        style: GoogleFonts.workSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2B2B2C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomSearchField(
                        hintText: 'Insert Task Name',
                        controller: _taskNameController,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF7C7C7D),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Assign Member (Optional)',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2B2B2C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      CustomSearchField(
                        hintText: 'Select Member',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF7C7C7D),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Due Date',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2B2B2C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFD6D6D7),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Insert Due Date',
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF7C7C7D),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Icon(
                                Icons.calendar_today_outlined,
                                color: const Color(0xFF7C7C7D),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Due Time',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2B2B2C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFD6D6D7),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Insert Due Time',
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF7C7C7D),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Icon(
                                Icons.access_time,
                                color: const Color(0xFF7C7C7D),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _addNewTask,
                        child: Container(
                          width: double.infinity,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4525A2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Create Task',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE3E3E3),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/bell.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    'DH',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color.fromRGBO(214, 211, 211, 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/Vector.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const CustomSearchField(
              hintText: 'Search',
              showSearchIcon: true,
            ),
            const SizedBox(height: 20),
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
                          Image.asset(
                            tasks[index]['image'],
                            width: 20,
                            height: 20,
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
                  InkWell(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
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
                  ),
                  if (!isExpanded) ...[
                    const SizedBox(height: 16),
                    const Divider(
                      color: Color(0xFFE3E3E3),
                      height: 1,
                      thickness: 1,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (isExpanded) ...[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: taskItems.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Color(0xFFE3E3E3),
                        height: 32,
                        thickness: 1,
                      ),
                      itemBuilder: (context, index) {
                        final task = taskItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      value: task.isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          task.isChecked = value ?? false;
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
                                      task.title,
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
                                      color: index == taskItems.length - 1
                                          ? const Color(
                                              0xFFEA4335) // Red color for last item
                                          : const Color(
                                              0xFF7C7C7D), // Original color for others
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
                                      color: task.dateBackgroundColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          size: 12,
                                          color: Color(0xFF2B2B2C),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          task.time,
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
                                        index == 0
                                            ? 'assets/images/Prof.png'
                                            : index == 1
                                                ? 'assets/images/Prof2.png'
                                                : 'assets/images/Prof3.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFFF2F2F2),
                                    ),
                                    child: Icon(
                                      Icons.more_horiz,
                                      size: 24,
                                      color: const Color(0xFF7C7C7D),
                                    ),
                                    padding: const EdgeInsets.all(4),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: 318,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF4525A2),
                          width: 1.5,
                        ),
                      ),
                      child: InkWell(
                        onTap: _showAddTaskBottomSheet,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 24,
                              color: const Color(0xFF4525A2),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Add Task',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4525A2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
