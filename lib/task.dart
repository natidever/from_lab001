import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/custom_search_field.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/task_model.dart';
import 'widgets/task_options_dialog.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class TeamTasks {
  final String title;
  List<TaskModel> tasks;

  TeamTasks({
    required this.title,
    required this.tasks,
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

  List<TeamTasks> teamsList = [
    TeamTasks(
      title: 'Development Team',
      tasks: [], // Will be populated from SharedPreferences
    ),
    TeamTasks(
      title: 'AIG Study Team',
      tasks: [], // Will be populated from SharedPreferences
    ),
  ];

  static const String TASKS_KEY = 'tasks';
  late SharedPreferences prefs;

  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _memberController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _dueTimeController = TextEditingController();

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      prefs = await SharedPreferences.getInstance();

      for (int i = 0; i < teamsList.length; i++) {
        final tasksJson =
            prefs.getStringList('tasks_${i}_${teamsList[i].title}');

        if (tasksJson == null || tasksJson.isEmpty) {
          if (i == 0) {
            // Development Team default tasks
            teamsList[i].tasks = [
              TaskModel(
                title: 'Calendar Integration',
                time: 'Nov 20 2:00 PM',
                dateBackgroundColor: const Color(0xFFFEF2CD).value,
              ),
              TaskModel(
                title: 'Survey Review and Analysis',
                time: 'Nov 20 2:00 PM',
                dateBackgroundColor: const Color(0xFFFEF2CD).value,
              ),
              TaskModel(
                title: 'Mobile App Design',
                time: 'Oct 12 1:00 PM',
                dateBackgroundColor: const Color(0xFFFEF2CD).value,
              ),
              TaskModel(
                title: 'Calendar Integration',
                time: 'Oct 15 2:30 PM',
                dateBackgroundColor: const Color(0xFFFEF2CD).value,
              ),
              TaskModel(
                title: 'Cloud-based backend for task data and messages',
                time: 'Oct 20 4:00 PM',
                dateBackgroundColor: const Color(0xFFFBD9D7).value,
              ),
            ];
          }
          _saveTeamTasks(i);
        } else {
          teamsList[i].tasks = tasksJson
              .map((json) => TaskModel.fromJson(jsonDecode(json)))
              .toList();
        }
      }
      setState(() {});
    } catch (e) {
      print('Error loading tasks: $e');
      setState(() {
        for (var team in teamsList) {
          team.tasks = [];
        }
      });
    }
  }

  Future<void> _saveTeamTasks(int teamIndex) async {
    try {
      final tasksJson = teamsList[teamIndex]
          .tasks
          .map((task) => jsonEncode(task.toJson()))
          .toList();
      await prefs.setStringList(
          'tasks_${teamIndex}_${teamsList[teamIndex].title}', tasksJson);
    } catch (e) {
      print('Error saving tasks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving tasks'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addNewTask(int teamIndex) {
    if (_taskNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task name'),
          backgroundColor: Color(0xFF4525A2),
        ),
      );
      return;
    }

    final dateTimeString =
        '${_dueDateController.text} ${_dueTimeController.text}';

    setState(() {
      teamsList[teamIndex].tasks.insert(
            0,
            TaskModel(
              title: _taskNameController.text,
              time: dateTimeString,
              dateBackgroundColor: const Color(0xFFFEF2CD).value,
            ),
          );
    });

    _saveTeamTasks(teamIndex); // Save tasks for the correct team

    _clearControllers();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task added successfully'),
        backgroundColor: Color(0xFF4525A2),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  void _showAddTaskBottomSheet(int teamIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            _clearControllers();
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
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _showCalendar(context),
                            borderRadius: BorderRadius.circular(15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: _dueDateController,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintText: 'Insert Due Date',
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15),
                                        hintStyle: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF7C7C7D),
                                        ),
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
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _showTimePicker,
                            borderRadius: BorderRadius.circular(15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: _dueTimeController,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintText: 'Insert Due Time',
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15),
                                        hintStyle: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF7C7C7D),
                                        ),
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
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => _addNewTask(teamIndex),
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

  void _showCalendar(BuildContext context) {
    DateTime firstDay = DateTime.now();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width * 0.85,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.65,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(
                        children: [
                          Text(
                            'Select Date',
                            style: GoogleFonts.workSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2B2B2C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFEFECF8)),
                    // Calendar with optimized size
                    Flexible(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TableCalendar(
                            firstDay: firstDay,
                            lastDay: DateTime(2025),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            calendarFormat: CalendarFormat.month,
                            rowHeight: 40,
                            daysOfWeekHeight: 20,
                            headerStyle: HeaderStyle(
                              titleCentered: true,
                              formatButtonVisible: false,
                              leftChevronIcon: const Icon(
                                Icons.chevron_left,
                                color: Color(0xFF4525A2),
                                size: 24,
                              ),
                              rightChevronIcon: const Icon(
                                Icons.chevron_right,
                                color: Color(0xFF4525A2),
                                size: 24,
                              ),
                              titleTextStyle: GoogleFonts.workSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2B2B2C),
                              ),
                            ),
                            calendarStyle: CalendarStyle(
                              selectedDecoration: const BoxDecoration(
                                color: Color(0xFF4525A2),
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: const Color(0xFF4525A2).withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              weekendTextStyle: const TextStyle(
                                color: Color(0xFF515152),
                                fontSize: 14,
                              ),
                              defaultTextStyle: const TextStyle(
                                color: Color(0xFF2B2B2C),
                                fontSize: 14,
                              ),
                              outsideTextStyle: TextStyle(
                                color: const Color(0xFF2B2B2C).withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                            onDaySelected: (selectedDay, focusedDay) {
                              setDialogState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            availableCalendarFormats: const {
                              CalendarFormat.month: 'Month',
                            },
                            startingDayOfWeek: StartingDayOfWeek.sunday,
                            calendarBuilders: CalendarBuilders(
                              selectedBuilder: (context, date, _) {
                                return Container(
                                  margin: const EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4525A2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${date.day}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF7C7C7D),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              final formattedDate =
                                  DateFormat('MMM dd').format(_selectedDay);
                              setDialogState(() {
                                _dueDateController.text = formattedDate;
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4525A2),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'OK',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showTimePicker() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4525A2),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF2B2B2C),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        // Format time to 12-hour format with AM/PM
        final hour = selectedTime.hourOfPeriod;
        final minute = selectedTime.minute.toString().padLeft(2, '0');
        final period = selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
        _dueTimeController.text = '$hour:$minute $period';
      });
    }
  }

  void _showEditTaskBottomSheet(TaskModel task, int index) {
    // Pre-fill the controllers with existing task data
    _taskNameController.text = task.title;

    // Split the time string to get date and time separately
    final timeParts = task.time.split(' ');
    if (timeParts.length >= 3) {
      _dueDateController.text =
          '${timeParts[0]} ${timeParts[1]}'; // e.g., "Oct 12"
      _dueTimeController.text =
          '${timeParts[2]} ${timeParts[3]}'; // e.g., "1:00 PM"
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            _clearControllers();
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Task',
                        style: GoogleFonts.workSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4525A2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomSearchField(
                        hintText: 'Task Name',
                        controller: _taskNameController,
                      ),
                      const SizedBox(height: 16),
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
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _showCalendar(context),
                            borderRadius: BorderRadius.circular(15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: _dueDateController,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintText: 'Insert Due Date',
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15),
                                        hintStyle: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF7C7C7D),
                                        ),
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
                        ),
                      ),
                      const SizedBox(height: 16),
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
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _showTimePicker,
                            borderRadius: BorderRadius.circular(15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: _dueTimeController,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintText: 'Insert Due Time',
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15),
                                        hintStyle: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF7C7C7D),
                                        ),
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
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () => _updateTask(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4525A2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Update Task',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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

  void _updateTask(int index) {
    if (_taskNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task name'),
          backgroundColor: Color(0xFF4525A2),
        ),
      );
      return;
    }

    final dateTimeString =
        '${_dueDateController.text} ${_dueTimeController.text}';

    setState(() {
      teamsList[0].tasks[index] = TaskModel(
        title: _taskNameController.text,
        time: dateTimeString,
        dateBackgroundColor: teamsList[0].tasks[index].dateBackgroundColor,
        isChecked: teamsList[0].tasks[index].isChecked,
      );
    });

    _saveTeamTasks(0);
    _clearControllers();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task updated successfully'),
        backgroundColor: Color(0xFF4525A2),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  void _clearControllers() {
    _taskNameController.clear();
    _memberController.clear();
    _dueDateController.clear();
    _dueTimeController.clear();
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int teamIndex = 0;
                        teamIndex < teamsList.length;
                        teamIndex++) ...[
                      if (teamIndex > 0) const SizedBox(height: 20),
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
                          mainAxisSize: MainAxisSize.min,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      teamsList[teamIndex].title,
                                      style: GoogleFonts.workSans(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: teamIndex == 0
                                            ? const Color(
                                                0xFF4525A2) // Development Team color
                                            : const Color(
                                                0xFF2B2B2C), // AIG Study Team color
                                      ),
                                    ),
                                    IconButton(
                                      padding: const EdgeInsets.only(right: 16),
                                      icon: const Icon(
                                        Icons.more_vert,
                                        size: 24,
                                        color: Color(0xFF7C7C7D),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              TaskOptionsDialog(
                                            onDelete: () {
                                              setState(() {
                                                teamsList[teamIndex]
                                                    .tasks
                                                    .clear();
                                                _saveTeamTasks(teamIndex);
                                              });
                                              Navigator.pop(context);
                                            },
                                            onEdit: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      },
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
                                itemCount: teamsList[teamIndex].tasks.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  color: Color(0xFFE3E3E3),
                                  height: 32,
                                  thickness: 1,
                                ),
                                itemBuilder: (context, index) {
                                  final task =
                                      teamsList[teamIndex].tasks[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
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
                                                    task.isChecked =
                                                        value ?? false;
                                                    _saveTeamTasks(teamIndex);
                                                  });
                                                },
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
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
                                                  color:
                                                      const Color(0xFF515152),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '0%',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: index ==
                                                        teamsList[teamIndex]
                                                                .tasks
                                                                .length -
                                                            1
                                                    ? const Color(0xFFEA4335)
                                                    : const Color(0xFF7C7C7D),
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
                                                color: Color(
                                                    task.dateBackgroundColor),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.access_time,
                                                    size: 12,
                                                    color: Color(0xFF2B2B2C),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      task.time,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.2,
                                                        color: const Color(
                                                            0xFF2B2B2C),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                            IconButton(
                                              icon: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      const Color(0xFFF2F2F2),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: const Icon(
                                                  Icons.more_horiz,
                                                  size: 24,
                                                  color: Color(0xFF7C7C7D),
                                                ),
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      TaskOptionsDialog(
                                                    onDelete: () {
                                                      setState(() {
                                                        teamsList[teamIndex]
                                                            .tasks
                                                            .removeAt(index);
                                                        _saveTeamTasks(
                                                            teamIndex);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    onEdit: () {
                                                      _showEditTaskBottomSheet(
                                                          task, index);
                                                    },
                                                  ),
                                                );
                                              },
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
                                  onTap: () =>
                                      _showAddTaskBottomSheet(teamIndex),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
