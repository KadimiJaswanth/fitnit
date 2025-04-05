import 'package:flutter/material.dart';

class AthleteProfile extends StatefulWidget {
  final Map<String, dynamic> profile;

  const AthleteProfile({required this.profile});

  @override
  _AthleteProfileState createState() => _AthleteProfileState();
}

class _AthleteProfileState extends State<AthleteProfile> with SingleTickerProviderStateMixin {
  late Map<String, dynamic> profile;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _themeAnimationController;
  String selectedImage = 'assets/profile_picture.jpg'; // Default image
  final List<String> profileImages = [
    'assets/profile_picture.jpg',
    'assets/profile_picture2.jpg', // Ensure these are added in pubspec.yaml
    'assets/profile_picture3.jpg',
  ];
  final List<Map<String, dynamic>> healthMetrics = [
    {'metric': 'Heart Rate', 'value': '70 bpm'},
    {'metric': 'Sleep Hours', 'value': '7 hrs'},
  ];
  final List<Map<String, dynamic>> profileHistory = [
    {'field': 'Name', 'oldValue': 'John Smith', 'newValue': 'John Doe', 'date': DateTime.now().subtract(const Duration(days: 30))},
  ];
  final List<Map<String, dynamic>> financialDetails = [
    {'type': 'Purchase', 'amount': '\$49.99', 'status': 'Completed', 'date': DateTime.now().subtract(const Duration(days: 15))},
  ];
  bool isVerified = false;
  bool isDarkMode = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    profile = Map<String, dynamic>.from(widget.profile);
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() => setState(() {}));
    _themeAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _themeAnimationController.dispose();
    super.dispose();
  }

  bool _isValidInput(String value, String field) {
    if (field == 'Age' || field == 'Weight') {
      final number = double.tryParse(value);
      return number != null && number > 0;
    }
    if (field == 'Phone') {
      return value.isNotEmpty && value.length >= 10 && RegExp(r'^\+?1?\d{9,15}$').hasMatch(value);
    }
    return value.isNotEmpty;
  }

  void _toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
    _themeAnimationController.forward(from: 0);
  }

  String _formatDate(DateTime date) => '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';

  TextStyle? _getTextStyle({Color? color, double? fontSize, FontWeight? fontWeight}) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium ?? const TextStyle(fontFamily: 'Roboto');
    return baseStyle.copyWith(
      color: color ?? (isDarkMode ? Colors.white70 : Colors.black87),
      fontSize: fontSize ?? 16,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }

  String _safeString(dynamic value, [String defaultValue = '']) {
    if (value is String) return value;
    if (value != null) return value.toString();
    return defaultValue;
  }

  void _logProfileChange(String field, String oldValue, String newValue) {
    if (oldValue != newValue && newValue.isNotEmpty) {
      setState(() {
        profileHistory.add({
          'field': field,
          'oldValue': oldValue,
          'newValue': newValue,
          'date': DateTime.now(),
        });
      });
    }
  }

  bool _validateProfile() {
    return _isValidInput(_safeString(profile['name'], ''), 'Name') &&
        _isValidInput(_safeString(profile['age'], '25'), 'Age') &&
        _isValidInput(_safeString(profile['sport'], ''), 'Sport') &&
        _isValidInput(_safeString(profile['phone'], ''), 'Phone');
  }

  Widget _buildProfileField(String label, String value, Function(String) onChanged, {bool isRequired = false}) {
    final controller = TextEditingController(text: value);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? ' *' : ''}',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
          fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.red)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          errorText: isRequired && !_isValidInput(value, label) ? 'Required and valid input needed' : null,
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
        ),
        onChanged: (text) {
          onChanged(text);
          _logProfileChange(label, value, text);
        },
        keyboardType: label == 'Age' || label == 'Weight'
            ? TextInputType.number
            : label == 'Phone'
            ? TextInputType.phone
            : TextInputType.text,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title, style: _getTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  void _showImagePickerDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        children: profileImages.map((image) {
          return GestureDetector(
            onTap: () {
              setState(() => selectedImage = image);
              Navigator.pop(context);
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(image, fit: BoxFit.cover),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showEditHealthMetricDialog(BuildContext context, Map<String, dynamic> metric, int index) {
    final valueController = TextEditingController(text: _safeString(metric['value']));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${_safeString(metric['metric'])}', style: _getTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).cardColor,
        content: TextField(
          controller: valueController,
          decoration: InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
            fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: _getTextStyle()),
          ),
          TextButton(
            onPressed: () {
              setState(() => healthMetrics[index]['value'] = valueController.text);
              Navigator.pop(context);
            },
            child: Text('Save', style: _getTextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    );
  }

  void _showAddHealthMetricDialog(BuildContext context) {
    final metricController = TextEditingController();
    final valueController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Health Metric', style: _getTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).cardColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: metricController,
              decoration: InputDecoration(
                labelText: 'Metric Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: valueController,
              decoration: InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: _getTextStyle()),
          ),
          TextButton(
            onPressed: () {
              final metric = metricController.text;
              final value = valueController.text;
              if (metric.isNotEmpty && value.isNotEmpty) {
                setState(() => healthMetrics.add({'metric': metric, 'value': value}));
              }
              Navigator.pop(context);
            },
            child: Text('Save', style: _getTextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    );
  }

  void _showEditFinancialDialog(BuildContext context, Map<String, dynamic> finance, int index) {
    final amountController = TextEditingController(text: _safeString(finance['amount']).replaceAll(r'$', ''));
    final statusController = TextEditingController(text: _safeString(finance['status']));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${_safeString(finance['type'])}', style: _getTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).cardColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: statusController,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: _getTextStyle()),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                financialDetails[index]['amount'] = '\$${amountController.text}';
                financialDetails[index]['status'] = statusController.text;
              });
              Navigator.pop(context);
            },
            child: Text('Save', style: _getTextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    );
  }

  void _showAddFinancialDialog(BuildContext context) {
    final typeController = TextEditingController();
    final amountController = TextEditingController();
    final statusController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Financial Transaction', style: _getTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).cardColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: typeController,
              decoration: InputDecoration(
                labelText: 'Transaction Type',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: statusController,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: _getTextStyle()),
          ),
          TextButton(
            onPressed: () {
              final type = typeController.text;
              final amount = amountController.text;
              final status = statusController.text;
              if (type.isNotEmpty && amount.isNotEmpty && status.isNotEmpty) {
                setState(() {
                  financialDetails.add({
                    'type': type,
                    'amount': '\$${amount}',
                    'status': status,
                    'date': DateTime.now(),
                  });
                });
              }
              Navigator.pop(context);
            },
            child: Text('Save', style: _getTextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    );
  }

  void _showProfileShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Share Profile', style: _getTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).cardColor,
        content: Text(
          'Name: ${_safeString(profile['name'])}\n'
              'Age: ${_safeString(profile['age'], '25')} yrs\n'
              'Sport: ${_safeString(profile['sport'])}\n'
              'Height: ${_safeString(profile['height'])}\n'
              'Weight: ${_safeString(profile['weight'])}\n'
              'Phone: ${_safeString(profile['phone'], 'N/A')}\n'
              'Email: ${_safeString(profile['email'], 'N/A')}\n'
              'Location: ${_safeString(profile['location'], 'N/A')}',
          style: _getTextStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile shared (simulated)!', style: TextStyle(color: Colors.white))),
              );
            },
            child: Text('Share', style: _getTextStyle(color: Theme.of(context).primaryColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: _getTextStyle()),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profile Help & Tips', style: _getTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).cardColor,
        content: Text(
          'Welcome to Athlete Profile!\n\n'
              '1. Fill in all required fields (marked with *) to update your profile.\n'
              '2. Tap your profile picture to change it from available options.\n'
              '3. Add or edit health metrics and financial details to track your fitness and subscriptions.\n'
              '4. View your profile history, purchase history, or share your details.\n'
              '5. Verify your profile for enhanced features.\n'
              '6. Switch between light and dark modes for better visibility.\n'
              '7. Save changes to update your profile in the dashboard.',
          style: _getTextStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: _getTextStyle()),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Settings', style: _getTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).cardColor,
        content: Text(
          'Control who can see your profile, health metrics, and financial details. Current setting: Public.',
          style: _getTextStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: _getTextStyle()),
          ),
        ],
      ),
    );
  }

  void _showPurchaseHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase History', style: _getTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).cardColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: financialDetails.map((finance) {
            return ListTile(
              title: Text(_safeString(finance['type']), style: _getTextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                'Amount: ${_safeString(finance['amount'])} | Status: ${_safeString(finance['status'])} | Date: ${_formatDate(finance['date'] as DateTime)}',
                style: _getTextStyle(color: Colors.grey),
              ),
              tileColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: _getTextStyle()),
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Settings', style: _getTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).cardColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Dark Mode', style: _getTextStyle()),
              value: isDarkMode,
              onChanged: (value) => _toggleTheme(),
              activeColor: Theme.of(context).primaryColor,
              tileColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: _getTextStyle()),
          ),
        ],
      ),
    );
  }

  void _showInviteFriendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invite a Friend', style: _getTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).cardColor,
        content: Text(
          'Share your referral link to invite friends and earn rewards!',
          style: _getTextStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invitation link copied to clipboard!', style: TextStyle(color: Colors.white))),
              );
            },
            child: Text('Copy Link', style: _getTextStyle(color: Theme.of(context).primaryColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: _getTextStyle()),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout', style: _getTextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).cardColor,
        content: Text(
          'Are you sure you want to logout?',
          style: _getTextStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: _getTextStyle()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Logout and return to previous screen
            },
            child: Text('Logout', style: _getTextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: isDarkMode ? Colors.blueGrey : Colors.blue,
        scaffoldBackgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        cardColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: isDarkMode ? Colors.blueGrey : Colors.blue,
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ).copyWith(
          secondary: isDarkMode ? Colors.blueGrey[300] : Colors.blueAccent,
        ),
        textTheme: TextTheme(
          bodyMedium: _getTextStyle(),
          titleLarge: _getTextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          titleMedium: _getTextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.blueGrey[700] : Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Athlete Profile', style: _getTextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline, size: 24),
              onPressed: () => _showHelpDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.share, size: 24),
              onPressed: () => _showProfileShareDialog(context),
            ),
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, size: 24),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animation.value,
                          child: Card(
                            elevation: 12,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => _showImagePickerDialog(context),
                                    child: CircleAvatar(
                                      radius: 70,
                                      backgroundImage: AssetImage(selectedImage),
                                      backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                                      onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 70, color: Colors.white),
                                      child: const Icon(Icons.person, size: 70, color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    _safeString(profile['name'], 'Nicolas Adams'),
                                    style: _getTextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _safeString(profile['email'], 'nicolasadams@gmail.com'),
                                    style: _getTextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Personal Information'),
                  _buildProfileField('Name', _safeString(profile['name'], ''), (value) {
                    if (_isValidInput(value, 'Name')) setState(() => profile['name'] = value);
                  }, isRequired: true),
                  _buildProfileField('Age', _safeString(profile['age'], '25'), (value) {
                    if (_isValidInput(value, 'Age')) setState(() => profile['age'] = int.tryParse(value) ?? 25);
                  }, isRequired: true),
                  _buildProfileField('Sport', _safeString(profile['sport'], ''), (value) {
                    if (_isValidInput(value, 'Sport')) setState(() => profile['sport'] = value);
                  }, isRequired: true),
                  _buildProfileField('Height', _safeString(profile['height'], ''), (value) {
                    if (_isValidInput(value, 'Height')) setState(() => profile['height'] = value);
                  }),
                  _buildProfileField('Weight', _safeString(profile['weight'], ''), (value) {
                    if (_isValidInput(value, 'Weight')) setState(() => profile['weight'] = value);
                  }),
                  _buildProfileField('Phone', _safeString(profile['phone'], ''), (value) {
                    setState(() => profile['phone'] = value);
                  }),
                  _buildProfileField('Location', _safeString(profile['location'], ''), (value) {
                    setState(() => profile['location'] = value);
                  }),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Health Metrics'),
                  Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < healthMetrics.length; i++)
                            ListTile(
                              title: Text(_safeString(healthMetrics[i]['metric']), style: _getTextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(_safeString(healthMetrics[i]['value']), style: _getTextStyle(color: Colors.grey)),
                              trailing: IconButton(
                                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor, size: 24),
                                onPressed: () => _showEditHealthMetricDialog(context, healthMetrics[i], i),
                              ),
                              tileColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _showAddHealthMetricDialog(context),
                            child: Text('Add Metric', style: _getTextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Financial Details'),
                  Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < financialDetails.length; i++)
                            ListTile(
                              title: Text(_safeString(financialDetails[i]['type']), style: _getTextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                'Amount: ${_safeString(financialDetails[i]['amount'])} | Status: ${_safeString(financialDetails[i]['status'])} | Date: ${_formatDate(financialDetails[i]['date'] as DateTime)}',
                                style: _getTextStyle(color: Colors.grey),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor, size: 24),
                                onPressed: () => _showEditFinancialDialog(context, financialDetails[i], i),
                              ),
                              tileColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _showAddFinancialDialog(context),
                            child: Text('Add Transaction', style: _getTextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Profile History'),
                  Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < profileHistory.length; i++)
                            ListTile(
                              title: Text('${_safeString(profileHistory[i]['field'])} Changed', style: _getTextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                'From: ${_safeString(profileHistory[i]['oldValue'])} to ${_safeString(profileHistory[i]['newValue'])} on ${_formatDate(profileHistory[i]['date'] as DateTime)}',
                                style: _getTextStyle(color: Colors.grey),
                              ),
                              tileColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SwitchListTile(
                    title: Text('Verified Profile', style: _getTextStyle(fontWeight: FontWeight.bold)),
                    value: isVerified,
                    onChanged: (value) {
                      setState(() {
                        isVerified = value;
                        if (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile Verified!', style: TextStyle(color: Colors.white))),
                          );
                        }
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                    tileColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                      setState(() => isLoading = true);
                      if (_validateProfile()) {
                        await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile updated successfully!', style: TextStyle(color: Colors.white))),
                        );
                        Navigator.pop(context, profile);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill required fields correctly.', style: TextStyle(color: Colors.white))),
                        );
                      }
                      setState(() => isLoading = false);
                    },
                    child: isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                        : Text('Save Changes', style: _getTextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 24),
                  ...[
                    {'icon': Icons.lock, 'title': 'Privacy'},
                    {'icon': Icons.history, 'title': 'Purchase History'},
                    {'icon': Icons.support_agent, 'title': 'Help & Support'},
                    {'icon': Icons.settings, 'title': 'Settings'},
                    {'icon': Icons.person_add, 'title': 'Invite a Friend'},
                    {'icon': Icons.logout, 'title': 'Logout'},
                  ].map((item) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Icon(item['icon'] as IconData, color: Theme.of(context).primaryColor, size: 24),
                          title: Text(_safeString(item['title']), style: _getTextStyle()),
                          onTap: () {
                            switch (_safeString(item['title'])) {
                              case 'Privacy':
                                _showPrivacySettings(context);
                                break;
                              case 'Purchase History':
                                _showPurchaseHistory(context);
                                break;
                              case 'Help & Support':
                                _showHelpDialog(context);
                                break;
                              case 'Settings':
                                _showSettings(context);
                                break;
                              case 'Invite a Friend':
                                _showInviteFriendDialog(context);
                                break;
                              case 'Logout':
                                _showLogoutDialog(context);
                                break;
                            }
                          },
                          tileColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black54,
                child: const Center(child: CircularProgressIndicator(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}