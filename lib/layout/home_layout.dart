import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/modules/archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int myCurrentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _taskTitleController = TextEditingController();
  final _taskTimeController = TextEditingController();
  final _taskDateController = TextEditingController();
  bool isButtonSheetOpen = false;
  IconData fabIcon = Icons.edit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isButtonSheetOpen ? _closeButtonSheet() : _openButtonSheet();
        },
        backgroundColor: Colors.blue,
        child: Icon(
          fabIcon,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'ToDo app',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 50,
        currentIndex: myCurrentIndex,
        onTap: (index) {
          setState(() {
            myCurrentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        showUnselectedLabels: false,
        items: _buildBottomNavigationBarItems(),
      ),
      body: screens[myCurrentIndex],
    );
  }

  Widget _buildButtonSheet() {
    return Container(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _taskTitleController,
              decoration: InputDecoration(
                hintText: 'Enter task title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _taskTimeController,
              onTap: () {
                _showTimePicker(context);
              },
              decoration: InputDecoration(
                hintText: 'Enter task time',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              onTap: () {
                _showDatePicker(context);
              },
              controller: _taskDateController,
              decoration: InputDecoration(
                hintText: 'Enter task date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context) {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      _taskTimeController.text = value!.format(context);
    });
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ).then((value) {
      _taskDateController.text = DateFormat.yMMMd().format(value!);
    });
  }

  void _openButtonSheet() {
    scaffoldKey.currentState!.showBottomSheet(
      elevation: 10,
      (context) => _buildButtonSheet(),
    );
    fabIcon = Icons.add;
    setState(() {
      isButtonSheetOpen = true;
    });
  }

  void _closeButtonSheet() {
    Navigator.of(context).pop();
    fabIcon = Icons.edit;
    setState(() {
      isButtonSheetOpen = false;
    });
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.menu,
        ),
        label: 'Tasks',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.check_box,
        ),
        label: 'Done',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.archive_outlined,
        ),
        label: 'Archived',
      ),
    ];
  }
}
