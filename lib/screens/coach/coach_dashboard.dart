import 'package:flutter/material.dart';
import 'coach_profile.dart'; // Ensure this file exists with the CoachProfile widget

class CoachDashboard extends StatefulWidget {
  const CoachDashboard({super.key});

  @override
  State<CoachDashboard> createState() => _CoachDashboardState();
}

class _CoachDashboardState extends State<CoachDashboard> with SingleTickerProviderStateMixin {
  Map<String, dynamic> coachProfile = {
    'name': 'Coach Jane Smith',
    'experience': '10 years',
    'specialty': 'Running',
  };

  List<Map<String, dynamic>> athletes = [
    {
      'name': 'John Doe',
      'sport': 'Runner',
      'goals': {'5K Time': 0.7},
      'performance': {'Jan': 10.5, 'Feb': 11.0},
      'workouts': [
        {'name': 'Track Run', 'details': '5 miles', 'date': DateTime.now(), 'intensity': 7},
      ],
    },
    {
      'name': 'Alice Brown',
      'sport': 'Swimmer',
      'goals': {'100m Freestyle': 0.8},
      'performance': {'Jan': 58.0, 'Feb': 57.5},
      'workouts': [
        {'name': 'Pool Swim', 'details': '1000m', 'date': DateTime.now(), 'intensity': 6},
      ],
    },
  ];

  List<Map<String, dynamic>> trainingEvents = [
    {'date': DateTime.now(), 'description': 'Team Track Session - 9 AM', 'athlete': 'John Doe'},
    {'date': DateTime.now().add(const Duration(days: 1)), 'description': 'Pool Drills - 10 AM', 'athlete': 'Alice Brown'},
  ];

  bool isDarkTheme = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _workoutNameController = TextEditingController();
  final TextEditingController _workoutDetailsController = TextEditingController();
  String? selectedAthlete;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _workoutNameController.dispose();
    _workoutDetailsController.dispose();
    super.dispose();
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.lightBlue,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDarkTheme ? Colors.grey[900] : Colors.lightBlue[50],
      cardTheme: CardTheme(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.lightBlue[200] : Colors.lightBlue[900]),
        titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.lightBlue[100] : Colors.lightBlue[700]),
        bodyMedium: TextStyle(fontSize: 16, color: isDarkTheme ? Colors.white70 : Colors.black87),
        bodySmall: TextStyle(fontSize: 14, color: isDarkTheme ? Colors.grey[400] : Colors.grey[600]),
      ),
      iconTheme: IconThemeData(color: isDarkTheme ? Colors.lightBlue[200] : Colors.lightBlue[700]),
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme ? Colors.grey[850] : Colors.lightBlue[500],
        elevation: 0,
        titleTextStyle: TextStyle(color: isDarkTheme ? Colors.lightBlue[200] : Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: Scaffold(
        appBar: _buildAppBar(),
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCoachInfo(),
                  _buildSectionTitle("Athletes"),
                  _buildAthleteList(),
                  _buildSectionTitle("Training Calendar"),
                  _buildTrainingCalendar(),
                  _buildSectionTitle("Performance Overview"),
                  _buildPerformanceOverview(),
                ],
              ),
            );
          },
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Coach Dashboard'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _showSettingsDialog(context),
        ),
      ],
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showAssignWorkoutDialog(context),
      backgroundColor: Colors.lightBlue.shade500,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _buildCoachInfo() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoachProfile(profile: coachProfile),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coachProfile['name'], style: Theme.of(context).textTheme.headlineMedium),
                    Text('Specialty: ${coachProfile['specialty']}', style: Theme.of(context).textTheme.bodySmall),
                    Text('Experience: ${coachProfile['experience']}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _buildAthleteList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: athletes.length,
              itemBuilder: (context, index) {
                final athlete = athletes[index];
                return ListTile(
                  title: Text(athlete['name']),
                  subtitle: Text('Sport: ${athlete['sport']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () => _showAthleteDetailsDialog(context, athlete),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingCalendar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: 35,
          itemBuilder: (context, index) {
            final day = DateTime.now().subtract(Duration(days: 34 - index));
            final hasEvent = trainingEvents.any((e) => _isSameDay(e['date'], day));
            return GestureDetector(
              onTap: () => _showTrainingEventDialog(context, day),
              child: Container(
                decoration: BoxDecoration(
                  color: hasEvent ? Colors.lightBlue.shade100 : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDarkTheme ? Colors.white : Colors.black12),
                ),
                child: Center(child: Text('${day.day}', style: Theme.of(context).textTheme.bodySmall)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPerformanceOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Athletes' Performance Overview", style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: athletes.length,
              itemBuilder: (context, index) {
                final athlete = athletes[index];
                final performance = athlete['performance'];
                return ListTile(
                  title: Text(athlete['name']),
                  subtitle: Text('Performance: Jan - ${performance['Jan']}s, Feb - ${performance['Feb']}s'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  void _showAthleteDetailsDialog(BuildContext context, Map<String, dynamic> athlete) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(athlete['name']),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sport: ${athlete['sport']}'),
            Text('Goals: ${athlete['goals']}'),
            const SizedBox(height: 8),
            Text('Workouts:'),
            ...athlete['workouts'].map<Widget>((workout) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('- ${workout['name']} - ${workout['details']}'),
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showAssignWorkoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Assign Workout"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedAthlete,
                hint: const Text("Select Athlete"),
                items: athletes.map((athlete) {
                  return DropdownMenuItem<String>(
                    value: athlete['name'],
                    child: Text(athlete['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedAthlete = value);
                },
              ),
              TextField(
                controller: _workoutNameController,
                decoration: const InputDecoration(labelText: "Workout Name"),
              ),
              TextField(
                controller: _workoutDetailsController,
                decoration: const InputDecoration(labelText: "Workout Details"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (selectedAthlete != null) {
                  setState(() {
                    final athlete = athletes.firstWhere((a) => a['name'] == selectedAthlete);
                    athlete['workouts'].add({
                      'name': _workoutNameController.text,
                      'details': _workoutDetailsController.text,
                      'date': DateTime.now(),
                      'intensity': 5,
                    });
                  });
                  _workoutNameController.clear();
                  _workoutDetailsController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text("Assign"),
            ),
          ],
        );
      },
    );
  }

  void _showTrainingEventDialog(BuildContext context, DateTime day) {
    final events = trainingEvents.where((e) => _isSameDay(e['date'], day)).toList();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Events on ${day.toLocal().toString().split(' ')[0]}'),
        content: events.isEmpty
            ? const Text("No events")
            : Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: events.map((e) => Text("- ${e['description']}")).toList(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Row(
          children: [
            const Text('Dark Mode'),
            Switch(
              value: isDarkTheme,
              onChanged: (value) {
                setState(() => isDarkTheme = value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}