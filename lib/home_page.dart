import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'log_workout_page.dart';
import 'progress_page.dart';
import 'goals_page.dart';

class WorkoutSummary {
  final String type;
  final DateTime date;
  final int duration;
  final int calories;

  WorkoutSummary({
    required this.type,
    required this.date,
    required this.duration,
    required this.calories,
  });
}

class Achievement {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final double progress;

  Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    required this.progress,
  });
}

class WorkoutReminder {
  final String title;
  final TimeOfDay time;
  final List<bool> weekdays; // Index 0 is Monday
  final bool isEnabled;

  WorkoutReminder({
    required this.title,
    required this.time,
    required this.weekdays,
    required this.isEnabled,
  });
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<WorkoutSummary> recentWorkouts = [
    WorkoutSummary(
      type: 'Strength Training',
      date: DateTime.now().subtract(Duration(days: 1)),
      duration: 45,
      calories: 300,
    ),
    WorkoutSummary(
      type: 'Cardio',
      date: DateTime.now().subtract(Duration(days: 2)),
      duration: 30,
      calories: 250,
    ),
    WorkoutSummary(
      type: 'HIIT',
      date: DateTime.now().subtract(Duration(days: 3)),
      duration: 25,
      calories: 280,
    ),
  ];

  final List<Achievement> achievements = [
    Achievement(
      title: 'Early Bird',
      description: 'Complete 5 morning workouts',
      icon: Icons.wb_sunny,
      color: Colors.orange,
      isUnlocked: true,
      progress: 1.0,
    ),
    Achievement(
      title: 'Strength Master',
      description: 'Complete 10 strength training sessions',
      icon: Icons.fitness_center,
      color: Colors.blue,
      isUnlocked: false,
      progress: 0.7,
    ),
    Achievement(
      title: 'Consistency King',
      description: 'Work out 5 days in a row',
      icon: Icons.calendar_today,
      color: Colors.green,
      isUnlocked: true,
      progress: 1.0,
    ),
    Achievement(
      title: 'Calorie Crusher',
      description: 'Burn 5000 total calories',
      icon: Icons.local_fire_department,
      color: Colors.red,
      isUnlocked: false,
      progress: 0.4,
    ),
  ];

  final List<WorkoutReminder> reminders = [
    WorkoutReminder(
      title: 'Morning Workout',
      time: TimeOfDay(hour: 6, minute: 30),
      weekdays: [true, true, true, true, true, false, false],
      isEnabled: true,
    ),
    WorkoutReminder(
      title: 'Evening Yoga',
      time: TimeOfDay(hour: 18, minute: 0),
      weekdays: [true, false, true, false, true, false, false],
      isEnabled: true,
    ),
  ];

  void _showRemindersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Workout Reminders',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addNewReminder,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(reminder.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${reminder.time.format(context)}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              for (int i = 0; i < 7; i++)
                                Container(
                                  margin: EdgeInsets.only(right: 4),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: reminder.weekdays[i]
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[300],
                                  ),
                                  child: Center(
                                    child: Text(
                                      ['M', 'T', 'W', 'T', 'F', 'S', 'S'][i],
                                      style: TextStyle(
                                        color: reminder.weekdays[i]
                                            ? Colors.white
                                            : Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Switch(
                        value: reminder.isEnabled,
                        onChanged: (value) {
                          setState(() {
                            reminders[index] = WorkoutReminder(
                              title: reminder.title,
                              time: reminder.time,
                              weekdays: reminder.weekdays,
                              isEnabled: value,
                            );
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAchievementsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Achievements',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                controller: scrollController,
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: achievement.color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              achievement.icon,
                              color: achievement.color,
                              size: 32,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            achievement.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            achievement.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          if (!achievement.isUnlocked)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: achievement.progress,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation(
                                  achievement.color,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          if (achievement.isUnlocked)
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addNewReminder() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        reminders.add(WorkoutReminder(
          title: 'New Workout',
          time: selectedTime,
          weekdays: List.generate(7, (index) => false),
          isEnabled: true,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fitness Tracker'),
            Text(
              DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.emoji_events_outlined),
            onPressed: _showAchievementsBottomSheet,
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: _showRemindersBottomSheet,
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              // Show settings
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(context),
                SizedBox(height: 24),
                _buildLatestAchievements(),
                SizedBox(height: 24),
                _buildWeeklyProgress(),
                SizedBox(height: 24),
                _buildQuickActions(context),
                SizedBox(height: 24),
                _buildNextWorkoutReminder(),
                SizedBox(height: 24),
                _buildRecentActivity(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLatestAchievements() {
    final unlockedAchievements = achievements.where((a) => a.isUnlocked).toList();
    if (unlockedAchievements.isEmpty) return SizedBox.shrink();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Achievements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _showAchievementsBottomSheet,
                  child: Text('View All'),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(  
              height: 120,
              child: ListView.builder(  
                scrollDirection: Axis.horizontal,
                itemCount: unlockedAchievements.length,
                itemBuilder: (context, index) {
                  final achievement = unlockedAchievements[index];
                  return Container(
                    width: 120,
                    margin: EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,  
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: achievement.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            achievement.icon,
                            color: achievement.color,
                            size: 24,  
                          ),
                        ),
                        SizedBox(height: 8),
                        Flexible(  
                          child: Text(
                            achievement.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,  
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,  
                            overflow: TextOverflow.ellipsis,  
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextWorkoutReminder() {
    final nextReminder = reminders.firstWhere(
      (r) => r.isEnabled,
      orElse: () => reminders.first,
    );

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Next Workout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _showRemindersBottomSheet,
                  child: Text('View Schedule'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.alarm,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nextReminder.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${nextReminder.time.format(context)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: nextReminder.isEnabled,
                  onChanged: (value) {
                    setState(() {
                      final index = reminders.indexOf(nextReminder);
                      reminders[index] = WorkoutReminder(
                        title: nextReminder.title,
                        time: nextReminder.time,
                        weekdays: nextReminder.weekdays,
                        isEnabled: value,
                      );
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Keep up the great work on your fitness journey!',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProgressPage()),
                    );
                  },
                  child: Text('View Details'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProgressStat('Workouts', '4/5', 0.8),
                _buildProgressStat('Minutes', '120/150', 0.8),
                _buildProgressStat('Calories', '850/1000', 0.85),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, double progress) {
    return Column(
      children: [
        SizedBox(
          height: 64,
          width: 64,
          child: Stack(
            children: [
              CircularProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                strokeWidth: 8,
              ),
              Center(
                child: Text(
                  value.split('/')[0],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.add_circle_outline,
                  label: 'Log Workout',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogWorkoutPage()),
                    );
                  },
                ),
                _buildActionButton(
                  icon: Icons.flag_outlined,
                  label: 'Set Goals',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GoalsPage()),
                    );
                  },
                ),
                _buildActionButton(
                  icon: Icons.insights_outlined,
                  label: 'Progress',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProgressPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: recentWorkouts.length,
              itemBuilder: (context, index) {
                final workout = recentWorkouts[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: Text(workout.type),
                  subtitle: Text(
                    DateFormat('MMM d, y').format(workout.date),
                  ),
                  trailing: Text(
                    '${workout.duration} min',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  }

