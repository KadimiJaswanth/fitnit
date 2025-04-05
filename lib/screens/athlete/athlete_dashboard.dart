import 'package:flutter/material.dart';
import 'athlete_profile.dart'; // Import the AthleteProfile widget

class AthleteDashboard extends StatefulWidget {
  @override
  _AthleteDashboardState createState() => _AthleteDashboardState();
}

class _AthleteDashboardState extends State<AthleteDashboard> with SingleTickerProviderStateMixin {
  final Map<String, dynamic> profile = {
    'name': 'John Doe',
    'age': 25,
    'sport': 'Runner',
    'height': '175 cm',
    'weight': '70 kg',
  };
  final List<Map<String, dynamic>> performanceData = [
    {'month': 'Jan', 'value': 10.5, 'target': 12.0},
    {'month': 'Feb', 'value': 11.0, 'target': 12.5},
    {'month': 'Mar', 'value': 12.0, 'target': 13.0},
    {'month': 'Apr', 'value': 11.8, 'target': 13.5},
  ];
  final List<Map<String, dynamic>> workouts = [
    {'name': 'Bench Press', 'details': '3x10 @ 100lbs', 'date': DateTime.now(), 'intensity': 8},
    {'name': 'Track Run', 'details': '5 miles @ 8 min/mile', 'date': DateTime.now().subtract(Duration(days: 2)), 'intensity': 7},
    {'name': 'Squats', 'details': '4x12 @ 120lbs', 'date': DateTime.now().subtract(Duration(days: 5)), 'intensity': 6},
  ];
  final Map<String, double> goals = {'5K Time': 0.7, 'Strength Goal': 0.4, 'Endurance Goal': 0.9}; // Expanded with an additional goal
  bool isDarkTheme = false; // Toggle for dark/light mode
  List<String> achievements = ['Completed 3 Workouts', 'Reached 70% Goal Progress'];
  bool showReminders = true;
  List<Map<String, dynamic>> trainingEvents = [
    {'date': DateTime.now(), 'description': 'Track Run - 9 AM'},
    {'date': DateTime.now().add(Duration(days: 1)), 'description': 'Strength Training - 10 AM'},
  ];

  late AnimationController _animationController;
  late Animation<double> _animation;

  // Custom isSameDay function
  bool isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600), // Slightly longer for a fresh feel
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut, // Smoother curve for a fresh animation
    ))..addListener(() {
      setState(() {});
    });
    _animationController.forward();
    _simulateReminders();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _simulateReminders() {
    if (showReminders) {
      Future.delayed(Duration(seconds: 5), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Reminder: Training at 9 AM tomorrow!'),
              backgroundColor: isDarkTheme ? Colors.lightBlue.shade400 : Colors.lightBlue.shade300,
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    }
  }

  int _calculateWorkoutFrequency() {
    final now = DateTime.now();
    return workouts.where((w) => w['date'].year == now.year && w['date'].month == now.month).length;
  }

  double _calculateAverageIntensity() {
    if (workouts.isEmpty) return 0.0;
    return workouts.map((w) => w['intensity'] as num).reduce((a, b) => a + b) / workouts.length;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final appBarTheme = Theme.of(context).appBarTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDarkTheme ? Colors.grey[900] : Colors.lightBlue[50],
        cardTheme: CardTheme(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: isDarkTheme ? Colors.grey[800] : Colors.white,
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.lightBlue[200] : Colors.lightBlue[900], letterSpacing: 1.2),
          titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.lightBlue[100] : Colors.lightBlue[700]),
          bodyMedium: TextStyle(fontSize: 16, color: isDarkTheme ? Colors.white70 : Colors.black87, letterSpacing: 0.5),
          bodySmall: TextStyle(fontSize: 14, color: isDarkTheme ? Colors.grey[400] : Colors.grey[600]),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.lightBlue,
          textTheme: ButtonTextTheme.primary,
        ),
        iconTheme: IconThemeData(color: isDarkTheme ? Colors.lightBlue[200] : Colors.lightBlue[700]),
        appBarTheme: AppBarTheme(
          backgroundColor: isDarkTheme ? Colors.grey[850] : Colors.lightBlue[500],
          elevation: 0,
          titleTextStyle: TextStyle(color: isDarkTheme ? Colors.lightBlue[200] : Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: isDarkTheme ? Colors.lightBlue[200] : Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Athlete Dashboard',
            style: textTheme.headlineMedium?.copyWith(
              color: appBarTheme.titleTextStyle?.color ?? (isDarkTheme ? Colors.lightBlue[200] : Colors.white),
            ) ?? TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkTheme ? Colors.lightBlue[200] : Colors.white,
            ),
          ),
          backgroundColor: appBarTheme.backgroundColor ?? (isDarkTheme ? Colors.grey[850] : Colors.lightBlue[500]),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: Theme.of(context).iconTheme.color),
              onPressed: () => _showSettingsDialog(context),
            ),
            IconButton(
              icon: Icon(Icons.help, color: Theme.of(context).iconTheme.color),
              onPressed: () => _showHelpDialog(context),
            ),
            IconButton(
              icon: Icon(Icons.feedback, color: Theme.of(context).iconTheme.color),
              onPressed: () => _showFeedbackDialog(context),
            ),
          ],
        ),
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0), // Reduced padding to prevent overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0), // Reduced padding
                      child: InkWell(
                        onTap: () async {
                          final updatedProfile = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AthleteProfile(profile: profile)),
                          );
                          if (updatedProfile != null) {
                            setState(() {
                              profile.clear();
                              profile.addAll(updatedProfile);
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30, // Slightly smaller for better fit
                              backgroundImage: AssetImage('assets/profile_picture.jpg'),
                              child: Icon(Icons.person, size: 30, color: Colors.white),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile['name'],
                                    style: textTheme.headlineMedium ?? TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.lightBlue[200] : Colors.lightBlue[900]),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${profile['sport']} | ${profile['age']} yrs',
                                    style: textTheme.bodySmall ?? TextStyle(fontSize: 14, color: isDarkTheme ? Colors.grey[400] : Colors.grey[600]),
                                  ),
                                  Text(
                                    'Height: ${profile['height']}, Weight: ${profile['weight']}',
                                    style: textTheme.bodySmall ?? TextStyle(fontSize: 14, color: isDarkTheme ? Colors.grey[400] : Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16), // Reduced spacing

                  // Training Calendar
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0), // Reduced padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Training Calendar',
                            style: textTheme.titleMedium ?? TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.lightBlue[100] : Colors.lightBlue[700]),
                          ),
                          SizedBox(height: 12), // Reduced spacing
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 4.0, // Reduced spacing
                              mainAxisSpacing: 4.0, // Reduced spacing
                            ),
                            itemCount: 35, // Simulating a 5-week month
                            itemBuilder: (context, index) {
                              final day = DateTime.now().subtract(Duration(days: 34 - index));
                              final hasEvent = trainingEvents.any((event) => isSameDay(event['date'], day));
                              return GestureDetector(
                                onTap: () => _showTrainingEventDialog(context, day),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: hasEvent ? Colors.lightBlue.shade100 : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8), // Slightly smaller radius
                                    border: Border.all(color: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300, width: 0.5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      day.day.toString(),
                                      style: TextStyle(
                                        fontSize: 12, // Slightly smaller for better fit
                                        color: hasEvent ? Colors.lightBlue.shade700 : (isDarkTheme ? Colors.white70 : Colors.black87),
                                        fontWeight: hasEvent ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 12), // Reduced spacing
                          ElevatedButton(
                            onPressed: () => _showAddTrainingDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue.shade500,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Slightly smaller radius
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Reduced padding
                            ),
                            child: Text('Add Training', style: TextStyle(color: Colors.white, fontSize: 14)), // Smaller text
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16), // Reduced spacing

                  // Performance Metrics
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0), // Reduced padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Performance Metrics',
                            style: textTheme.titleMedium ?? TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.lightBlue[100] : Colors.lightBlue[700]),
                          ),
                          SizedBox(height: 12), // Reduced spacing
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildMetric('Speed', '12 km/h'),
                              _buildMetric('Endurance', '85%'),
                            ],
                          ),
                          SizedBox(height: 16), // Reduced spacing
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: performanceData.length,
                            itemBuilder: (context, index) {
                              final data = performanceData[index];
                              return ListTile(
                                title: Text(data['month'], style: textTheme.bodyMedium ?? TextStyle(fontSize: 16, color: isDarkTheme ? Colors.white70 : Colors.black87)),
                                subtitle: Text(
                                  'Value: ${data['value'].toStringAsFixed(1)} | Target: ${data['target'].toStringAsFixed(1)}',
                                  style: textTheme.bodySmall ?? TextStyle(fontSize: 14, color: isDarkTheme ? Colors.grey[400] : Colors.grey[600]),
                                ),
                                trailing: Icon(
                                  data['value'] >= data['target'] ? Icons.check_circle : Icons.warning,
                                  color: data['value'] >= data['target'] ? Colors.green : Colors.orange,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 12), // Reduced spacing
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => _showUpdatePerformanceDialog(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue.shade500,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Slightly smaller radius
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Reduced padding
                                ),
                                child: Text('Update', style: TextStyle(color: Colors.white, fontSize: 14)), // Smaller text
                              ),
                              ElevatedButton(
                                onPressed: () => _showSetPerformanceGoalDialog(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue.shade500,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Slightly smaller radius
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Reduced padding
                                ),
                                child: Text('Set Goal', style: TextStyle(color: Colors.white, fontSize: 14)), // Smaller text
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16), // Reduced spacing

                  // Workout History
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0), // Reduced padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Workout History',
                            style: textTheme.titleMedium ?? TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.lightBlue[100] : Colors.lightBlue[700]),
                          ),
                          SizedBox(height: 12), // Reduced spacing
                          Text(
                            'Total: ${workouts.length} | Avg. Intensity: ${_calculateAverageIntensity().toStringAsFixed(1)}/10 | Frequency: ${_calculateWorkoutFrequency()} this month',
                            style: textTheme.bodySmall ?? TextStyle(fontSize: 14, color: isDarkTheme ? Colors.grey[400] : Colors.grey[600]),
                          ),
                          SizedBox(height: 12), // Reduced spacing
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: workouts.length,
                            itemBuilder: (context, index) {
                              final workout = workouts[index];
                              return ExpansionTile(
                                title: Text(
                                  '${workout['name']} - ${workout['date'].toLocal().toString().split(' ')[0]}',
                                  style: textTheme.bodyMedium ?? TextStyle(fontSize: 16, color: isDarkTheme ? Colors.white70 : Colors.black87),
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Reduced padding
                                    child: Text(
                                      workout['details'],
                                      style: textTheme.bodySmall ?? TextStyle(fontSize: 14, color: isDarkTheme ? Colors.grey[400] : Colors.grey[600]),
                                    ),
                                  ),
                                ],
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700),
                                      onPressed: () => _showEditWorkoutDialog(context, workout, index),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          workouts.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                tilePadding: EdgeInsets.symmetric(vertical: 8.0),
                              );
                            },
                          ),
                          SizedBox(height: 12), // Reduced spacing
                          ElevatedButton(
                            onPressed: () => _showAddWorkoutDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue.shade500,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Slightly smaller radius
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Reduced padding
                            ),
                            child: Text('Add Workout', style: TextStyle(color: Colors.white, fontSize: 14)), // Smaller text
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16), // Reduced spacing

                  // Enhanced Goals Section
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0), // Reduced padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Goals',
                            style: textTheme.titleMedium ?? TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.lightBlue[100] : Colors.lightBlue[700]),
                          ),
                          SizedBox(height: 12), // Reduced spacing
                          ...goals.entries.map((entry) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0), // Reduced spacing
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _animation.value,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            entry.key,
                                            style: (textTheme.bodyMedium ?? TextStyle(fontSize: 16, color: isDarkTheme ? Colors.white70 : Colors.black87)).copyWith(
                                              fontSize: 18, // Slightly larger for emphasis
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        SizedBox(
                                          width: 100, // Slightly smaller to prevent overflow
                                          height: 100, // Slightly smaller to prevent overflow
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                value: entry.value,
                                                backgroundColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300,
                                                color: Colors.lightBlue.shade500,
                                                strokeWidth: 10, // Slightly thinner for better fit
                                              ),
                                              Text(
                                                '${(entry.value * 100).toStringAsFixed(0)}%',
                                                style: TextStyle(
                                                  fontSize: 18, // Slightly smaller for better fit
                                                  color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade900,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      color: isDarkTheme ? Colors.black26 : Colors.grey.shade400,
                                                      offset: Offset(1, 1),
                                                      blurRadius: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit, color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700),
                                              onPressed: () => _showUpdateGoalDialog(context, entry.key, entry.value),
                                            ),
                                            if (entry.value >= 1.0) // Show trophy for achieved goals
                                              Padding(
                                                padding: EdgeInsets.only(left: 8.0),
                                                child: Icon(Icons.emoji_events, color: Colors.yellow, size: 20), // Slightly smaller icon
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                          SizedBox(height: 12), // Reduced spacing
                          ElevatedButton(
                            onPressed: () => _showAddGoalDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue.shade500,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Slightly smaller radius
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Reduced padding
                            ),
                            child: Text('Add Goal', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), // Smaller text
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16), // Reduced spacing

                  // Achievements
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0), // Reduced padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Achievements',
                            style: textTheme.titleMedium ?? TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkTheme ? Colors.lightBlue[100] : Colors.lightBlue[700]),
                          ),
                          SizedBox(height: 12), // Reduced spacing
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: achievements.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(Icons.star, color: Colors.yellow),
                                title: Text(
                                  achievements[index],
                                  style: textTheme.bodyMedium ?? TextStyle(fontSize: 16, color: isDarkTheme ? Colors.white70 : Colors.black87),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      achievements.removeAt(index);
                                    });
                                  },
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                                dense: true,
                              );
                            },
                          ),
                          SizedBox(height: 12), // Reduced spacing
                          ElevatedButton(
                            onPressed: () => _showAddAchievementDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue.shade500,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Slightly smaller radius
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Reduced padding
                            ),
                            child: Text('Add Achievement', style: TextStyle(color: Colors.white, fontSize: 14)), // Smaller text
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddWorkoutDialog(context),
          backgroundColor: Colors.lightBlue.shade500,
          child: Icon(Icons.add, color: Colors.white),
          shape: CircleBorder(),
          elevation: 6,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: (textTheme.bodyMedium ?? TextStyle(fontSize: 16, color: isDarkTheme ? Colors.white70 : Colors.black87)).copyWith(
            fontSize: 18, // Slightly smaller for better fit
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall ?? TextStyle(fontSize: 12, color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600), // Smaller text
        ),
      ],
    );
  }

  void _showAddWorkoutDialog(BuildContext context) {
    final nameController = TextEditingController();
    final detailsController = TextEditingController();
    final dateController = TextEditingController(text: DateTime.now().toLocal().toString().split(' ')[0]);
    final intensityController = TextEditingController(text: '7'); // Default intensity (1-10)

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Workout', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 18, fontWeight: FontWeight.bold)), // Smaller title
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Workout Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
                ),
              ),
              SizedBox(height: 10), // Reduced spacing
              TextField(
                controller: detailsController,
                decoration: InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
                ),
              ),
              SizedBox(height: 10), // Reduced spacing
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
                        colorScheme: ColorScheme.fromSwatch(
                          primarySwatch: Colors.lightBlue,
                          brightness: isDarkTheme ? Brightness.dark : Brightness.light,
                        ),
                        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    dateController.text = picked.toLocal().toString().split(' ')[0];
                  }
                },
              ),
              SizedBox(height: 10), // Reduced spacing
              TextField(
                controller: intensityController,
                decoration: InputDecoration(
                  labelText: 'Intensity (1-10)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14)), // Smaller text
          ),
          TextButton(
            onPressed: () {
              final intensity = int.tryParse(intensityController.text) ?? 7;
              if (intensity < 1 || intensity > 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Intensity must be between 1 and 10'),
                    backgroundColor: Colors.red.shade300,
                    duration: Duration(seconds: 3),
                  ),
                );
                return;
              }
              setState(() {
                workouts.add({
                  'name': nameController.text,
                  'details': detailsController.text,
                  'date': DateTime.parse(dateController.text),
                  'intensity': intensity,
                });
                if (workouts.length >= 50) {
                  achievements.add('Completed 50 Workouts');
                }
              });
              Navigator.pop(context);
            },
            child: Text('Save', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 14, fontWeight: FontWeight.bold)), // Smaller text
          ),
        ],
        backgroundColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
      ),
    );
  }

  void _showEditWorkoutDialog(BuildContext context, Map<String, dynamic> workout, int index) {
    final nameController = TextEditingController(text: workout['name']);
    final detailsController = TextEditingController(text: workout['details']);
    final dateController = TextEditingController(text: workout['date'].toLocal().toString().split(' ')[0]);
    final intensityController = TextEditingController(text: workout['intensity'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Workout', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 18, fontWeight: FontWeight.bold)), // Smaller title
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Workout Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
                ),
              ),
              SizedBox(height: 10), // Reduced spacing
              TextField(
                controller: detailsController,
                decoration: InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
                ),
              ),
              SizedBox(height: 10), // Reduced spacing
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: workout['date'],
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
                        colorScheme: ColorScheme.fromSwatch(
                          primarySwatch: Colors.lightBlue,
                          brightness: isDarkTheme ? Brightness.dark : Brightness.light,
                        ),
                        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    dateController.text = picked.toLocal().toString().split(' ')[0];
                  }
                },
              ),
              SizedBox(height: 10), // Reduced spacing
              TextField(
                controller: intensityController,
                decoration: InputDecoration(
                  labelText: 'Intensity (1-10)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14)), // Smaller text
          ),
          TextButton(
            onPressed: () {
              final intensity = int.tryParse(intensityController.text) ?? 7;
              if (intensity < 1 || intensity > 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Intensity must be between 1 and 10'),
                    backgroundColor: Colors.red.shade300,
                    duration: Duration(seconds: 3),
                  ),
                );
                return;
              }
              setState(() {
                workouts[index] = {
                  'name': nameController.text,
                  'details': detailsController.text,
                  'date': DateTime.parse(dateController.text),
                  'intensity': intensity,
                };
              });
              Navigator.pop(context);
            },
            child: Text('Save', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 14, fontWeight: FontWeight.bold)), // Smaller text
          ),
        ],
        backgroundColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
      ),
    );
  }

  void _showAddTrainingDialog(BuildContext context) {
    final eventController = TextEditingController();
    final dateController = TextEditingController(text: DateTime.now().toLocal().toString().split(' ')[0]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Training', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 18, fontWeight: FontWeight.bold)), // Smaller title
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: eventController,
              decoration: InputDecoration(
                labelText: 'Training Description',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
              ),
            ),
            SizedBox(height: 10), // Reduced spacing
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
                      colorScheme: ColorScheme.fromSwatch(
                        primarySwatch: Colors.lightBlue,
                        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
                      ),
                      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) {
                  dateController.text = picked.toLocal().toString().split(' ')[0];
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14)), // Smaller text
          ),
          TextButton(
            onPressed: () {
              setState(() {
                trainingEvents.add({
                  'date': DateTime.parse(dateController.text),
                  'description': eventController.text,
                });
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Training added! Reminder set for tomorrow.'),
                  backgroundColor: isDarkTheme ? Colors.lightBlue.shade400 : Colors.lightBlue.shade300,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: Text('Save', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 14, fontWeight: FontWeight.bold)), // Smaller text
          ),
        ],
        backgroundColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
      ),
    );
  }

  void _showTrainingEventDialog(BuildContext context, DateTime day) {
    final events = trainingEvents.where((event) => isSameDay(event['date'], day)).toList();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Training Events for ${day.toLocal().toString().split(' ')[0]}', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 18, fontWeight: FontWeight.bold)), // Smaller title
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (events.isEmpty)
              Text('No events for this day.', style: Theme.of(context).textTheme.bodyMedium),
            for (var event in events)
              ListTile(
                title: Text(event['description'], style: Theme.of(context).textTheme.bodyMedium),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      trainingEvents.remove(event);
                    });
                    Navigator.pop(context);
                  },
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                dense: true,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14)), // Smaller text
          ),
          TextButton(
            onPressed: () {
              _showAddTrainingDialog(context);
              Navigator.pop(context);
            },
            child: Text('Add Event', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 14, fontWeight: FontWeight.bold)), // Smaller text
          ),
        ],
        backgroundColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
      ),
    );
  }

  void _showUpdatePerformanceDialog(BuildContext context) {
    final monthController = TextEditingController();
    final valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Update Performance', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 18, fontWeight: FontWeight.bold)), // Smaller title
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: monthController,
              decoration: InputDecoration(
                labelText: 'Month (e.g., Jan)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
              ),
            ),
            SizedBox(height: 10), // Reduced spacing
            TextField(
              controller: valueController,
              decoration: InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14)), // Smaller text
          ),
          TextButton(
            onPressed: () {
              final month = monthController.text;
              final value = double.tryParse(valueController.text) ?? 0.0;
              if (month.isNotEmpty) {
                setState(() {
                  final existingIndex = performanceData.indexWhere((data) => data['month'] == month);
                  if (existingIndex != -1) {
                    performanceData[existingIndex]['value'] = value;
                  } else {
                    performanceData.add({'month': month, 'value': value, 'target': 0.0});
                  }
                });
              }
              Navigator.pop(context);
            },
            child: Text('Save', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 14, fontWeight: FontWeight.bold)), // Smaller text
          ),
        ],
        backgroundColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
      ),
    );
  }

  void _showSetPerformanceGoalDialog(BuildContext context) {
    final monthController = TextEditingController();
    final targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Set Performance Goal', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 18, fontWeight: FontWeight.bold)), // Smaller title
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: monthController,
              decoration: InputDecoration(
                labelText: 'Month (e.g., Jan)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
              ),
            ),
            SizedBox(height: 10), // Reduced spacing
            TextField(
              controller: targetController,
              decoration: InputDecoration(
                labelText: 'Target Value',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14)), // Smaller text
          ),
          TextButton(
            onPressed: () {
              final month = monthController.text;
              final target = double.tryParse(targetController.text) ?? 0.0;
              if (month.isNotEmpty) {
                setState(() {
                  final existingIndex = performanceData.indexWhere((data) => data['month'] == month);
                  if (existingIndex != -1) {
                    performanceData[existingIndex]['target'] = target;
                  } else {
                    performanceData.add({'month': month, 'value': 0.0, 'target': target});
                  }
                });
              }
              Navigator.pop(context);
            },
            child: Text('Save', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 14, fontWeight: FontWeight.bold)), // Smaller text
          ),
        ],
        backgroundColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
      ),
    );
  }

  void _showUpdateGoalDialog(BuildContext context, String goal, double currentProgress) {
    final progressController = TextEditingController(text: (currentProgress * 100).toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Update Goal Progress', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 18, fontWeight: FontWeight.bold)), // Smaller title
        content: TextField(
          controller: progressController,
          decoration: InputDecoration(
            labelText: 'Progress (%)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14)), // Smaller text
          ),
          TextButton(
            onPressed: () {
              final progress = double.tryParse(progressController.text) ?? 0.0;
              setState(() {
                goals[goal] = progress / 100;
                if (progress >= 100) {
                  achievements.add('Reached 100% on $goal');
                }
              });
              Navigator.pop(context);
            },
            child: Text('Save', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 14, fontWeight: FontWeight.bold)), // Smaller text
          ),
        ],
        backgroundColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final goalController = TextEditingController();
    final progressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Goal', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 18, fontWeight: FontWeight.bold)), // Smaller title
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: goalController,
              decoration: InputDecoration(
                labelText: 'Goal Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
              ),
            ),
            SizedBox(height: 10), // Reduced spacing
            TextField(
              controller: progressController,
              decoration: InputDecoration(
                labelText: 'Progress (%)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14)), // Smaller text
          ),
          TextButton(
            onPressed: () {
              final goal = goalController.text;
              final progress = double.tryParse(progressController.text) ?? 0.0;
              if (goal.isNotEmpty) {
                setState(() {
                  goals[goal] = progress / 100;
                });
              }
              Navigator.pop(context);
            },
            child: Text('Save', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 14, fontWeight: FontWeight.bold)), // Smaller text
          ),
        ],
        backgroundColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Settings', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 18, fontWeight: FontWeight.bold)), // Smaller title
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Dark Theme', style: textTheme.bodyMedium ?? TextStyle(fontSize: 16, color: isDarkTheme ? Colors.white70 : Colors.black87)),
              value: isDarkTheme,
              onChanged: (value) {
                setState(() {
                  isDarkTheme = value;
                });
                Navigator.pop(context);
              },
              activeColor: Colors.lightBlue.shade500,
              tileColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
              activeTrackColor: Colors.lightBlue.shade300,
            ),
            SwitchListTile(
              title: Text('Show Reminders', style: textTheme.bodyMedium ?? TextStyle(fontSize: 16, color: isDarkTheme ? Colors.white70 : Colors.black87)),
              value: showReminders,
              onChanged: (value) {
                setState(() {
                  showReminders = value;
                  if (value) _simulateReminders();
                });
                Navigator.pop(context);
              },
              activeColor: Colors.lightBlue.shade500,
              tileColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
              activeTrackColor: Colors.lightBlue.shade300,
            ),
            ListTile(
              title: Text('Reset Data', style: textTheme.bodyMedium ?? TextStyle(fontSize: 16, color: isDarkTheme ? Colors.white70 : Colors.black87)),
              trailing: Icon(Icons.delete, color: Colors.red),
              onTap: () {
                setState(() {
                  performanceData.clear();
                  performanceData.addAll([
                    {'month': 'Jan', 'value': 10.5, 'target': 12.0},
                    {'month': 'Feb', 'value': 11.0, 'target': 12.5},
                    {'month': 'Mar', 'value': 12.0, 'target': 13.0},
                    {'month': 'Apr', 'value': 11.8, 'target': 13.5},
                  ]);
                  workouts.clear();
                  workouts.addAll([
                    {'name': 'Bench Press', 'details': '3x10 @ 100lbs', 'date': DateTime.now(), 'intensity': 8},
                    {'name': 'Track Run', 'details': '5 miles @ 8 min/mile', 'date': DateTime.now().subtract(Duration(days: 2)), 'intensity': 7},
                    {'name': 'Squats', 'details': '4x12 @ 120lbs', 'date': DateTime.now().subtract(Duration(days: 5)), 'intensity': 6},
                  ]);
                  goals.clear();
                  goals.addAll({'5K Time': 0.7, 'Strength Goal': 0.4, 'Endurance Goal': 0.9});
                  achievements.clear();
                  achievements.addAll(['Completed 3 Workouts', 'Reached 70% Goal Progress']);
                  trainingEvents.clear();
                  trainingEvents.addAll([
                    {'date': DateTime.now(), 'description': 'Track Run - 9 AM'},
                    {'date': DateTime.now().add(Duration(days: 1)), 'description': 'Strength Training - 10 AM'},
                  ]);
                });
                Navigator.pop(context);
              },
              tileColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 14, fontWeight: FontWeight.bold)), // Smaller text
          ),
        ],
        backgroundColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Help & Tips', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 18, fontWeight: FontWeight.bold)), // Smaller title
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome to Athlete Dashboard!\n\n'
                    '1. Tap your profile to edit details.\n'
                    '2. Use the calendar to manage training events.\n'
                    '3. Update performance metrics and set goals.\n'
                    '4. Track workouts and add achievements.\n'
                    '5. Toggle dark theme or reminders in settings.\n'
                    '6. Reset data to start fresh.',
                style: textTheme.bodyMedium ?? TextStyle(fontSize: 16, color: isDarkTheme ? Colors.white70 : Colors.black87),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 14, fontWeight: FontWeight.bold)), // Smaller text
          ),
        ],
        backgroundColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Submit Feedback', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 18, fontWeight: FontWeight.bold)), // Smaller title
        content: TextField(
          controller: feedbackController,
          decoration: InputDecoration(
            labelText: 'Your Feedback',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14)), // Smaller text
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final feedbackList = List<String>.from([]);
                feedbackList.add(feedbackController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Feedback submitted: ${feedbackController.text}'),
                    backgroundColor: isDarkTheme ? Colors.lightBlue.shade400 : Colors.lightBlue.shade300,
                    duration: Duration(seconds: 3),
                  ),
                );
              });
              Navigator.pop(context);
            },
            child: Text('Submit', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 14, fontWeight: FontWeight.bold)), // Smaller text
          ),
        ],
        backgroundColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
      ),
    );
  }

  void _showAddAchievementDialog(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final achievementController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Achievement', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 18, fontWeight: FontWeight.bold)), // Smaller title
        content: TextField(
          controller: achievementController,
          decoration: InputDecoration(
            labelText: 'Achievement Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade100,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14)), // Smaller text
          ),
          TextButton(
            onPressed: () {
              if (achievementController.text.isNotEmpty) {
                setState(() {
                  achievements.add(achievementController.text);
                });
              }
              Navigator.pop(context);
            },
            child: Text('Save', style: TextStyle(color: isDarkTheme ? Colors.lightBlue.shade200 : Colors.lightBlue.shade700, fontSize: 14, fontWeight: FontWeight.bold)), // Smaller text
          ),
        ],
        backgroundColor: isDarkTheme ? Colors.grey.shade800 : Colors.white,
      ),
    );
  }
}