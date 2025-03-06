import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/team_workout_details.dart';
import '../model/workout.dart';
import '../workout_provider.dart';
import 'model/exercise.dart';
import 'workout_details.dart';
import 'WorkoutTypeSelectionPage.dart';
import 'join_team_workout_page.dart';

class WorkoutHistoryPage extends StatefulWidget {
  @override
  _WorkoutHistoryPageState createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  List<Workout> soloWorkouts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loading = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshSoloWorkouts();
  }

  Future<void> _refreshSoloWorkouts() async {
    setState(() => _loading = true);
    await context.read<WorkoutProvider>().refreshData();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Workout History")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Consumer<WorkoutProvider>(
              builder: (context, workoutProvider, child) {
                final soloWorkouts = workoutProvider.workouts;
                return RefreshIndicator(
                  onRefresh: _refreshSoloWorkouts,
                  child: ListView(
                    children: [
                      _buildSectionTitle("Solo Workouts"),
                      if (soloWorkouts.isEmpty)
                        Center(child: Text("No solo workouts found")),
                      ...soloWorkouts
                          .map((workout) => _buildSoloWorkoutCard(workout)),
                      SizedBox(height: 20),
                      _buildSectionTitle("Group Workouts"),
                      _buildGroupWorkoutStream(),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => JoinTeamWorkoutPage()),
              );
            },
            label: Text("Join"),
            icon: Icon(Icons.group),
            backgroundColor: Colors.black12,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => WorkoutTypeSelectionPage()),
              );
            },
            child: const Icon(Icons.add),
            backgroundColor: Colors.black12,
          ),
        ],
      ),
    );
  }

  // Section title widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSoloWorkoutCard(Workout workout) {
    final workoutProvider = context.read<WorkoutProvider>();

    int successfulCount = workout.results.where((result) {
      final exercise = workoutProvider.exercises.firstWhere(
        (e) => e.id == result.exerciseId,
        orElse: () => Exercise(name: "Unknown", target: 0, unit: ""),
      );
      return exercise.name != "Unknown" && result.output >= exercise.target;
    }).length;

    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.black12,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title:
            Text("Solo Workout on ${workout.date.month}/${workout.date.day}"),
        subtitle: Text(
            "${workout.results.length} exercises, $successfulCount successful"),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WorkoutDetails(workout: workout),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroupWorkoutStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("group_workouts")
          .snapshots(), // Listen for updates
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No group workouts found"));
        }

        List<Map<String, dynamic>> groupWorkouts =
            snapshot.data!.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return {
            "id": doc.id,
            "name": data["workoutName"],
            "type": data["type"],
            "participants": (data["participants"] as List).length,
          };
        }).toList();

        return Column(
          children: groupWorkouts
              .map((workout) => _buildGroupWorkoutCard(workout))
              .toList(),
        );
      },
    );
  }

  Widget _buildGroupWorkoutCard(Map<String, dynamic> workout) {
    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.black26,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text("${workout["name"]}"),
        subtitle: Text(
            "${workout["type"].toUpperCase()} workout with ${workout["participants"]} participants"),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TeamWorkoutDetails(
                workoutId: workout["id"],
                workoutType: workout["type"],
              ),
            ),
          );
        },
      ),
    );
  }
}
