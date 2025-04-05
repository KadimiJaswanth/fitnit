import 'package:flutter/material.dart';

class CoachProfile extends StatefulWidget {
  final Map<String, dynamic> profile;

  const CoachProfile({Key? key, required this.profile}) : super(key: key);

  @override
  _CoachProfileState createState() => _CoachProfileState();
}

class _CoachProfileState extends State<CoachProfile> with SingleTickerProviderStateMixin {
  late Map<String, dynamic> profile;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    profile = Map<String, dynamic>.from(widget.profile);

    _nameController.text = profile['name'] ?? '';
    _specialtyController.text = profile['specialty'] ?? '';
    _experienceController.text = profile['experience'] ?? '';

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
    _nameController.dispose();
    _specialtyController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        profile['name'] = _nameController.text;
        profile['specialty'] = _specialtyController.text;
        profile['experience'] = _experienceController.text;
      }
      _isEditing = !_isEditing;
    });
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required TextStyle labelStyle,
    required TextStyle valueStyle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        _isEditing
            ? TextField(
          controller: controller,
          style: valueStyle,
        )
            : Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 12),
          child: Text(controller.text, style: valueStyle),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEdit,
          )
        ],
      ),
      body: FadeTransition(
        opacity: _animation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: profile['imageUrl'] != null
                        ? CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(profile['imageUrl']),
                    )
                        : const CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 40),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Name',
                    controller: _nameController,
                    labelStyle: Theme.of(context).textTheme.titleMedium!,
                    valueStyle: Theme.of(context).textTheme.bodyMedium!,
                  ),
                  _buildTextField(
                    label: 'Specialty',
                    controller: _specialtyController,
                    labelStyle: Theme.of(context).textTheme.titleMedium!,
                    valueStyle: Theme.of(context).textTheme.bodyMedium!,
                  ),
                  _buildTextField(
                    label: 'Experience',
                    controller: _experienceController,
                    labelStyle: Theme.of(context).textTheme.titleMedium!,
                    valueStyle: Theme.of(context).textTheme.bodyMedium!,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
