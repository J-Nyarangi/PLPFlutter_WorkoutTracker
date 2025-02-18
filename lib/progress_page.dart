import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WorkoutStats {
  final int workoutsCompleted;
  final int totalMinutes;
  final double avgIntensity;

  const WorkoutStats({
    required this.workoutsCompleted,
    required this.totalMinutes,
    required this.avgIntensity,
  });

  @override
  String toString() =>
      'Workouts: $workoutsCompleted, Minutes: $totalMinutes, Intensity: $avgIntensity';
}

class RecentWorkout {
  final String date;
  final String type;
  final int duration;
  final double intensity;

  const RecentWorkout({
    required this.date,
    required this.type,
    required this.duration,
    required this.intensity,
  });

  @override
  String toString() =>
      'Date: $date, Type: $type, Duration: $duration, Intensity: $intensity';
}

class ProgressPage extends StatelessWidget {
  final WorkoutStats stats = const WorkoutStats(
    workoutsCompleted: 24,
    totalMinutes: 720,
    avgIntensity: 7.5,
  );

  final List<RecentWorkout> recentWorkouts = const [
    RecentWorkout(
      date: '2023-02-18',
      type: 'Strength Training',
      duration: 45,
      intensity: 8.0,
    ),
    RecentWorkout(
      date: '2023-02-16',
      type: 'Cardio',
      duration: 30,
      intensity: 7.0,
    ),
    RecentWorkout(
      date: '2023-02-15',
      type: 'HIIT',
      duration: 25,
      intensity: 9.0,
    ),
  ];

  final List<FlSpot> progressData = const [
    FlSpot(0, 3),
    FlSpot(1, 4),
    FlSpot(2, 3.5),
    FlSpot(3, 5),
    FlSpot(4, 4.5),
    FlSpot(5, 6),
    FlSpot(6, 5.5),
  ];

  String _formatDate(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return date;
    const monthNames = {
      '01': 'Jan', '02': 'Feb', '03': 'Mar', '04': 'Apr',
      '05': 'May', '06': 'Jun', '07': 'Jul', '08': 'Aug',
      '09': 'Sep', '10': 'Oct', '11': 'Nov', '12': 'Dec'
    };
    return '${monthNames[parts[1]]} ${parts[2]}, ${parts[0]}';
  }

  IconData _getWorkoutIcon(String type) {
    switch (type) {
      case 'Cardio':
        return Icons.directions_run;
      case 'HIIT':
        return Icons.directions_run;
      case 'Strength Training':
      default:
        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Tracker'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsCards(context),
              const SizedBox(height: 24),
              _buildProgressChart(context),
              const SizedBox(height: 24),
              _buildRecentWorkouts(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16.0,
      childAspectRatio: 0.8,
      children: [
        _buildStatCard(context, 'Workouts', stats.workoutsCompleted.toString(), Icons.fitness_center),
        _buildStatCard(context, 'Minutes', stats.totalMinutes.toString(), Icons.timer),
        _buildStatCard(context, 'Avg Intensity', stats.avgIntensity.toStringAsFixed(1), Icons.show_chart),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 4,
      color: colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              value,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Weekly Progress',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40, 
                  getTitlesWidget: (value, meta) {
                    final text = 'Day ${value.toInt() + 1}';
                    return Transform.rotate(
                      angle: -0.5, 
                      child: Text(
                        text,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) => Text(
                    value.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: progressData,
                isCurved: true,
                color: colorScheme.primary,
                barWidth: 3,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: colorScheme.primary.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}


  Widget _buildRecentWorkouts(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Workouts',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentWorkouts.length,
          itemBuilder: (context, index) {
            final workout = recentWorkouts[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(
                  _getWorkoutIcon(workout.type),
                  color: colorScheme.primary,
                ),
                title: Text(workout.type),
                subtitle: Text(
                  '${_formatDate(workout.date)} • ${workout.duration} mins',
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Intensity',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      workout.intensity.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}