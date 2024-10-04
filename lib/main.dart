import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
      home: Step1Screen(),
    );
  }
}

// Step 1: Department Selection Screen
class Step1Screen extends StatefulWidget {
  @override
  _Step1ScreenState createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  String department = 'Software';

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
              onPressed: () {
                if (department == 'Network') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Step3Screen(department: department, section: '3'),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Step2Screen(department: department),
                    ),
                  );
                }
              },
              child: Text('Next', style: Theme.of(context).textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}
// Step 2: Section Selection Screen
class Step2Screen extends StatefulWidget {
  final String department;

  Step2Screen({required this.department});

  @override
  _Step2ScreenState createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  String? section;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Section')),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Added padding for consistency
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Select Section',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge), // Updated text style
            SizedBox(height: 20),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text('Select Section',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium), // Updated hint style
              value: section,
              items: [
                DropdownMenuItem(value: '1', child: Text('1')),
                DropdownMenuItem(value: '2', child: Text('2')),
                if (widget.department == 'Network')
                  DropdownMenuItem(value: '3', child: Text('3')),
              ],
              onChanged: (value) {
                setState(() {
                  section = value;
                });
              },
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Consistent button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: section != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Step3Screen(
                                department: widget.department,
                                section: section!,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Text('Show Schedule',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge), // Updated button text style
                ),
              ],
            ),
          ],
        ),
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
        'section': ["1", "2", "3"],
        'department': ["Software", "Network"],
      },
      {
        'from': "11:40 AM",
        'to': "01:50 PM",
        'type': "Lecture",
        'instructor': "Dr Mohamed Hassan",
        'subject': "CCNA R&S",
        'location': "B 201",
        'section': ["1", "2"],
        'department': ["Software"],
      },
      {
        'from': "11:40 AM",
        'to': "01:50 PM",
        'type': "Lecture",
        'instructor': "Dr Rehab",
        'subject': "Server Administration",
        'location': "A 302",
        'section': ["3"],
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
        'section': ["3"],
        'department': ["Network"],
      },
      {
        'from': "10:50 AM",
        'to': "12:30 PM",
        'type': "Section",
        'instructor': "Eng. Eman Osama",
        'subject': "Encryption Algorithm",
        'location': "A 208",
        'section': ["3"],
        'department': ["Network"],
      },
      {
        'from': "01:00 AM",
        'to': "02:40 AM",
        'type': "Section",
        'instructor': "Eng. Hager",
        'subject': "CCNA Cybersecurity Operations",
        'location': "A 201",
        'section': ["3"],
        'department': ["Network"],
      },
      {
        'from': "02:50 AM",
        'to': "04:30 AM",
        'type': "Section",
        'instructor': "Eng. Moamen",
        'subject': "IoT Architecture & Protocols/IoT Programming",
        'location': "A 202",
        'section': ["3"],
        'department': ["Network"],
      },
    ],
    'Monday': [
      {
        'from': "09:00 AM",
        'to': "10:40 AM",
        'type': "Follow-up",
        'subject': "Signal Processing",
        'instructor': "Eng. moamen",
        'location': "B 202",
        'section': ["1", "2"],
        'department': ["Software"],
      },
      {
        'from': "10:50 AM",
        'to': "12:30 PM",
        'type': "Section",
        'subject': "Windows Programming 1",
        'instructor': "Eng. Eman Ahmed",
        'location': "A 202",
        'section': ["1"],
        'department': ["Software"],
      },
      {
        'from': "10:50 AM",
        'to': "12:30 PM",
        'type': "Section",
        'subject': "CCNA R&S II",
        'instructor': "Eng. Esraa",
        'location': "A 201",
        'section': ["2"],
        'department': ["Software"],
      },
      {
        'from': "01:50 PM",
        'to': "02:40 PM",
        'type': "Section",
        'subject': "Windows Programming 1",
        'instructor': "Eng. Eman Ahmed",
        'location': "A 202",
        'section': ["2"],
        'department': ["Software"],
      },
      {
        'from': "02:50 PM",
        'to': "03:40 PM",
        'type': "Lecture",
        'subject': "Mobile Programming 2",
        'instructor': "Dr. Rasha",
        'location': "A 307",
        'section': ["1", "2"],
        'department': ["Software"],
      },
      {
        'from': "03:40 PM",
        'to': "04:30 PM",
        'type': "Lecture",
        'subject': "Windows Programming 1",
        'instructor': "Dr. Eman Monire",
        'location': "A 104",
        'section': ["1", "2"],
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
        'section': ["1", "2"],
        'department': ["Software"],
      },
      {
        'from': "10:50 AM",
        'to': "12:30 PM",
        'type': "Lecture",
        'subject': "CCNA Cybersecurity Operations",
        'instructor': "Dr. Osama",
        'location': "A 302",
        'section': ["3"],
        'department': ["Network"],
      },
      {
        'from': "01:00 PM",
        'to': "02:40 PM",
        'type': "Section",
        'subject': "CCNA R&S II",
        'instructor': "Eng. Esraa",
        'location': "A 201",
        'section': ["1"],
        'department': ["Software"],
      },
      {
        'from': "03:40 PM",
        'to': "05:20 PM",
        'type': "Lecture",
        'subject': "Artificial Intelligence",
        'instructor': "Dr. Rasha",
        'location': "A 101",
        'section': ["1", "2", "3"],
        'department': ["Software", "Network"],
      },
    ],
    'Wednesday': [
      {
        'from': "09:00 AM",
        'to': "10:40 AM",
        'type': "Section",
        'subject': "Mobile Programming II",
        'instructor': "Eng. Mohamed Hisham",
        'location': "A 208",
        'section': ["1"],
        'department': ["Software"],
      },
      {
        'from': "09:00 AM",
        'to': "10:40 AM",
        'type': "Section",
        'subject': "IoT Architecture & Protocols/IoT Programming",
        'instructor': "Eng. Moamen",
        'location': "A 301",
        'section': ["2"],
        'department': ["Software"],
      },
      {
        'from': "09:00 AM",
        'to': "10:40 AM",
        'type': "Section",
        'subject': "CCNA R&S IV",
        'instructor': "Eng. Esraa",
        'location': "A 201",
        'section': ["3"],
        'department': ["Network"],
      },
      {
        'from': "10:50 AM",
        'to': "12:30 PM",
        'type': "Section",
        'subject': "IoT Architecture & Protocols/IoT Programming",
        'instructor': "Eng. Moamen",
        'location': "A 301",
        'section': ["1"],
        'department': ["Software"],
      },
      {
        'from': "10:50 AM",
        'to': "12:30 PM",
        'type': "Section",
        'subject': "Mobile Programming II",
        'instructor': "Eng. Mohamed Hisham",
        'location': "A 208",
        'section': ["2"],
        'department': ["Software"],
      },
      {
        'from': "10:50 AM",
        'to': "12:30 PM",
        'type': "Lecture",
        'subject': "Encryption Algorithm",
        'instructor': "Dr. Ramy",
        'location': "A 302",
        'section': ["3"],
        'department': ["Network"],
      },
      {
        'from': "01:00 PM",
        'to': "02:40 PM",
        'type': "Follow-up",
        'subject': "Artificial Intelligence",
        'instructor': "Eng. Gehad",
        'location': "A 101",
        'section': ["1", "2", "3"],
        'department': ["Software", "Network"],
      },
      {
        'from': "02:50 PM",
        'to': "04:30 PM",
        'type': "Section",
        'subject': "CCNA R&S IV",
        'instructor': "Dr.mohamed hassan",
        'location': "A 101",
        'section': ["3"],
        'department': ["Network"],
      },
    ],
    'Thursday': [],
    'Friday': [],
  }
];

// Step 3: Schedule Display Screen
class Step3Screen extends StatefulWidget {
  final String department;
  final String section;

  Step3Screen({required this.department, required this.section});

  @override
  _Step3ScreenState createState() => _Step3ScreenState();
}

class _Step3ScreenState extends State<Step3Screen> {
  String selectedDay = 'Saturday';

  // Function to get the schedule for the selected day, department, and section
  List<Map<String, dynamic>> getScheduleForDay(String day) {
    // Check if there's any data for the selected day and avoid errors
    if (tableData.isNotEmpty && tableData.first.containsKey(day)) {
      var daySchedule = tableData.first[day] as List<dynamic>;
      if (daySchedule != null) {
        // Filter based on department and section
        return daySchedule
            .where((item) {
          return item['department'] != null &&
              item['section'] != null &&
              item['department'].contains(widget.department) &&
              item['section'].contains(widget.section);
        })
            .cast<Map<String, dynamic>>()
            .toList();
      }
    }
    // Return an empty list if there's no data for the selected day
    return [];
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> scheduleForSelectedDay =
    getScheduleForDay(selectedDay).map((item) {
      return item.map((key, value) => MapEntry(key, value.toString()));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Schedule')),
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