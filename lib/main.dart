import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // This removes the debug banner
      title: 'Department Schedule App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

// Home Screen: Department Selection Screen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String department = '';

  @override
  void initState() {
    super.initState();
    _loadDepartment(); // Load saved department
  }

  // Load saved department from SharedPreferences
  _loadDepartment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      department = prefs.getString('selectedDepartment') ?? '';
      if (department.isNotEmpty) {
        // Navigate to ScheduleScreen if a department is already saved
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScheduleScreen(department: department),
          ),
        );
      }
    });
  }

  // Save selected department to SharedPreferences
  _saveDepartment(String dept) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedDepartment', dept);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Department')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Select Department', style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: department == 'Software' ? Colors.blue : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      department = 'Software';
                      _saveDepartment(department); // Save department when selected
                    });
                  },
                  child: Text('Software', style: Theme.of(context).textTheme.bodyLarge),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: department == 'Network' ? Colors.blue : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      department = 'Network';
                      _saveDepartment(department); // Save department when selected
                    });
                  },
                  child: Text('Network', style: Theme.of(context).textTheme.bodyLarge),
                ),
              ],
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: department.isNotEmpty
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScheduleScreen(department: department),
                        ),
                      );
                    }
                  : null, // Disable button if no department is selected
              child: Text('Show Schedule', style: Theme.of(context).textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}

// Schedule Screen: Display Schedule
class ScheduleScreen extends StatefulWidget {
  final String department;

  ScheduleScreen({required this.department});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late String selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = DateFormat('EEEE').format(DateTime.now()); // Initialize with current day
  }

  // Function to get the schedule for the selected day and department
  List<Map<String, dynamic>> getScheduleForDay(String day) {
    if (tableData.isNotEmpty && tableData.first.containsKey(day)) {
      var daySchedule = tableData.first[day] as List<dynamic>;
      if (daySchedule != null) {
        return daySchedule
            .where((item) =>
                item['department'] != null &&
                item['department'].contains(widget.department))
            .cast<Map<String, dynamic>>()
            .toList();
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> scheduleForSelectedDay = getScheduleForDay(selectedDay).map((item) {
      return item.map((key, value) => MapEntry(key, value.toString()));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
        leading: IconButton( // Add back navigation button
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to HomeScreen
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedDay,
              items: [
                DropdownMenuItem(value: 'Saturday', child: Text('Saturday')),
                DropdownMenuItem(value: 'Sunday', child: Text('Sunday')),
                DropdownMenuItem(value: 'Monday', child: Text('Monday')),
                DropdownMenuItem(value: 'Tuesday', child: Text('Tuesday')),
                DropdownMenuItem(value: 'Wednesday', child: Text('Wednesday')),
                DropdownMenuItem(value: 'Thursday', child: Text('Thursday')),
                DropdownMenuItem(value: 'Friday', child: Text('Friday')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedDay = value!;
                });
              },
            ),
          ),
          Expanded(
            child: scheduleForSelectedDay.isEmpty
                ? Center(
                    child: Text(
                      'Happy Vacation ❤️',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: scheduleForSelectedDay.length,
                    itemBuilder: (context, index) {
                      var item = scheduleForSelectedDay[index];
                      Color tileColor;
                      if (item['type'] == 'Lecture') {
                        tileColor = Colors.blue[100]!;
                      } else if (item['type'] == 'Section') {
                        tileColor = Colors.green[100]!;
                      } else if (item['type'] == 'Follow-up') {
                        tileColor = Colors.yellow[100]!;
                      } else {
                        tileColor = index % 2 == 0 ? Colors.grey[100]! : Colors.white;
                      }
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            '${item['subject']} - ${item['type']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                'At ${item['location']} / ${item['instructor']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${item['from']} to ${item['to']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          tileColor: tileColor,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Mocked schedule data
List<Map<String, dynamic>> tableData = [
  {
    'Saturday': [
      {
        'from': "09:50 AM",
        'to': "11:40 AM",
        'type': "Lecture",
        'instructor': "Dr Rehab",
        'subject': "IoT Architecture & Protocols/IoT Programming",
        'location': "B 201",
        'department': ["Software", "Network"],
      },
      {
        'from': "11:40 AM",
        'to': "01:50 PM",
        'type': "Lecture",
        'instructor': "Dr Mohamed Hassan",
        'subject': "CCNA R&S",
        'location': "B 201",
        'department': ["Software"],
      },
      {
        'from': "11:40 AM",
        'to': "01:50 PM",
        'type': "Lecture",
        'instructor': "Dr Rehab",
        'subject': "Server Administration",
        'location': "A 302",
        'department': ["Network"],
      },
    ],
    'Sunday': [
      {
        'from': "09:00 AM",
        'to': "10:40 AM",
        'type': "Section",
        'instructor': "Eng. Moamen",
        'subject': "Server Administration",
        'location': "A 201",
        'department': ["Network"],
      },
      {
        'from': "10:50 AM",
        'to': "12:30 PM",
        'type': "Section",
        'instructor': "Eng. Esraa",
        'subject': "CCNA R&S IV",
        'location': "A 201",
        'department': ["Network"],
      },
      {
        'from': "01:00 AM",
        'to': "02:40 AM",
        'type': "Lecture",
        'instructor': "Dr. Osama",
        'subject': "CCNA Cybersecurity Operations",
        'location': "A 201",
        'department': ["Network"],
      },
      {
        'from': "02:50 AM",
        'to': "04:30 AM",
        'type': "Section",
        'instructor': "Eng. Moamen",
        'subject': "IoT Architecture & Protocols/IoT Programming",
        'location': "A 202",
        'department': ["Network"],
      },
    ],
    'Monday': [
      {
        'from': "10:50 AM",
        'to': "12:30 PM",
        'type': "Section",
        'subject': "CCNA R&S II",
        'instructor': "Eng. Esraa",
        'location': "A 201",
        'department': ["Software"],
      },
      {
        'from': "01:00 PM",
        'to': "02:40 PM",
        'type': "Section",
        'subject': "Windows Programming 1",
        'instructor': "Eng. Eman Ahmed",
        'location': "A 202",
        'department': ["Software"],
      },
      {
        'from': "02:50 PM",
        'to': "03:40 PM",
        'type': "Lecture",
        'subject': "Windows Programming 1",
        'instructor': "Dr. Eman Monire",
        'location': "A 202",
        'department': ["Software"],
      },
      {
        'from': "03:40 PM",
        'to': "04:30 PM",
        'type': "Lecture",
        'subject': "Mobile Programming 2",
        'instructor': "Dr. Rasha",
        'location': "A 104",
        'department': ["Software"],
      },
    ],
    'Tuesday': [
      {
        'from': "10:50 AM",
        'to': "12:30 PM",
        'type': "Lecture",
        'subject': "Signal Processing",
        'instructor': "Dr. Amany AbdElsamea",
        'location': "A 101",
        'department': ["Software"],
      },
      {
        'from': "09:00 AM",
        'to': "10:40 AM",
        'type': "Section",
        'subject': "CCNA Cybersecurity Operations",
        'instructor': "Eng. Hager",
        'location': "A 302",
        'department': ["Network"],
      },
      {
        'from': "02:50 PM",
        'to': "04:30 PM",
        'type': "Lecture",
        'subject': "Artificial Intelligence",
        'instructor': "Dr. Rasha",
        'location': "A 101",
        'department': ["Software", "Network"],
      },
    ],
    'Wednesday': [
      {
        'from': "09:00 AM",
        'to': "10:40 AM",
        'type': "Section",
        'subject': "IoT Architecture & Protocols/IoT Programming",
        'instructor': "Eng. Moamen",
        'location': "A 301",
        'department': ["Software"],
      },
      {
        'from': "09:00 AM",
        'to': "10:40 AM",
        'type': "Section",
        'subject': "Encryption Algorithm",
        'instructor': "Eng. Eman Osama",
        'location': "A 201",
        'department': ["Network"],
      },
      {
        'from': "10:50 AM",
        'to': "12:30 PM",
        'type': "Section",
        'subject': "Mobile Programming II",
        'instructor': "Eng. Mohamed Hisham",
        'location': "A 208",
        'department': ["Software"],
      },
      {
        'from': "10:50 AM",
        'to': "12:30 PM",
        'type': "Lecture",
        'subject': "Encryption Algorithm",
        'instructor': "Dr. Ramy",
        'location': "A 302",
        'department': ["Network"],
      },
      {
        'from': "01:00 PM",
        'to': "02:40 PM",
        'type': "Follow-up",
        'subject': "Artificial Intelligence",
        'instructor': "Eng. Gehad",
        'location': "A 101",
        'department': ["Software", "Network"],
      },
      {
        'from': "02:50 PM",
        'to': "04:30 PM",
        'type': "Follow-up",
        'subject': "Signal Processing",
        'instructor': "Eng. Moamen",
        'location': "A 101",
        'department': ["Software", "Network"],
      },
      {
        'from': "02:50 PM",
        'to': "04:30 PM",
        'type': "Lecture",
        'subject': "CCNA R&S IV",
        'instructor': "Dr.mohamed hassan",
        'location': "A 307",
        'department': ["Network"],
      },
    ],
    'Thursday': [],
    'Friday': [],
  }
];
