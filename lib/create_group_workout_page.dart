import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../workout_provider.dart';
import '../model/workout_plan.dart';
import '../firestore_service.dart';
import 'join_team_workout_page.dart';

class CreateGroupWorkoutPage extends StatefulWidget {
  @override
  _CreateGroupWorkoutPageState createState() => _CreateGroupWorkoutPageState();
}

class _CreateGroupWorkoutPageState extends State<CreateGroupWorkoutPage> {
  WorkoutPlan? selectedWorkoutPlan;
  String selectedType = "collaborative";
  bool _loading = false;
  final FirestoreService _firestoreService = FirestoreService();

  void _createWorkout() async {
    if (selectedWorkoutPlan == null) return;

    setState(() => _loading = true);

    await selectedWorkoutPlan!.exercises.load();

    String inviteCode = await _firestoreService.createGroupWorkout(
      selectedWorkoutPlan!.name,
      selectedType,
      selectedWorkoutPlan!.exercises.toList(),
    );

    setState(() => _loading = false);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JoinTeamWorkoutPage(inviteCode: inviteCode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Create Group Workout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<WorkoutPlan>(
              value: selectedWorkoutPlan,
              hint: Text("Select Workout Plan"),
              items: workoutProvider.workoutPlans.map((plan) {
                return DropdownMenuItem(
                  value: plan,
                  child: Text(plan.name),
                );
              }).toList(),
              onChanged: (plan) {
                setState(() => selectedWorkoutPlan = plan);
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: ["collaborative", "competitive"].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toUpperCase()),
                );
              }).toList(),
              onChanged: (type) {
                setState(() => selectedType = type!);
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _createWorkout,
              child: _loading
                  ? CircularProgressIndicator()
                  : Text("Create Workout", style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
