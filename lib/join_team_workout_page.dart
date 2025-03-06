import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_tracker/performance.dart';
import 'package:workout_tracker/qr_scanner_page.dart';
import '../group_workout_recording_page.dart';

class JoinTeamWorkoutPage extends StatefulWidget {
  final String? inviteCode;

  const JoinTeamWorkoutPage({this.inviteCode});

  @override
  _JoinTeamWorkoutPageState createState() => _JoinTeamWorkoutPageState();
}

class _JoinTeamWorkoutPageState extends State<JoinTeamWorkoutPage> {
  final TextEditingController _codeController = TextEditingController();
  String? _errorMessage;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.inviteCode != null) {
      _codeController.text = widget.inviteCode!;
    }
  }

  Future<void> _joinWorkout() async {
    String inviteCode = _codeController.text.trim();
    if (inviteCode.isEmpty) {
      setState(() {
        _errorMessage = "Please enter an invite code.";
      });
      return;
    }

    setState(() => _loading = true);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("group_workouts")
        .where("inviteCode", isEqualTo: inviteCode)
        .get();

    if (snapshot.docs.isEmpty) {
      setState(() {
        _errorMessage = "Invalid invite code.";
        _loading = false;
      });
      return;
    }

    DocumentReference workoutRef = snapshot.docs.first.reference;
    String workoutId = workoutRef.id;
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await workoutRef.update({
      "participants": FieldValue.arrayUnion([userId])
    });

    setState(() => _loading = false);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GroupWorkoutRecordingPage(workoutId: workoutId),
      ),
    );
  }

  void _scanQRCode() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QRScannerPage(
          onScanned: (String scannedCode) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    JoinTeamWorkoutPage(inviteCode: scannedCode),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Join Group Workout")),
        body: Stack(children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: "Enter Invite Code",
                    errorText: _errorMessage,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _scanQRCode,
                      icon: Icon(Icons.qr_code_scanner, color: Colors.white),
                      label: Text(
                        "Scan QR",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    _loading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                            ),
                            onPressed: _joinWorkout,
                            child: Text("Join Workout"),
                          ),
                  ],
                ),
              ],
            ),
          ),
          Performance()
        ]));
  }
}
