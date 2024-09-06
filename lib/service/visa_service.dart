import 'package:cey_go/ui/Visa%20Process%20Screen/visa_screen.dart';
import 'package:cey_go/ui/Visa%20Status%20Screens/visa_approved_screen.dart';
import 'package:cey_go/ui/Visa%20Status%20Screens/visa_canceled_screen.dart';
import 'package:cey_go/ui/Visa%20Status%20Screens/visa_pending_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VisaService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> handleVisaStatusAndNavigate(BuildContext context) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      // If no user is logged in, return or show some error
      return;
    }

    final userId = firebaseUser.uid;
    final visaApplicationsRef =
        _firestore.collection('visaApplications').doc(userId);
    final visaApplicantsRef =
        _firestore.collection('visa_applicants').doc(userId);
    final visaApprovalsRef = _firestore.collection('visaApprovals').doc(userId);

    try {
      // Check if user documents exist in visaApplications or visa_applicants collections
      final visaApplicationsSnapshot = await visaApplicationsRef.get();
      final visaApplicantsSnapshot = await visaApplicantsRef.get();

      if (!visaApplicationsSnapshot.exists && !visaApplicantsSnapshot.exists) {
        // If no documents exist, create a new visaApproval document with status 0
        await visaApprovalsRef.set({'status': 0});

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VisaScreen()),
        );
      } else {
        // Check visa status from visaApprovals
        final visaApprovalSnapshot = await visaApprovalsRef.get();
        if (visaApprovalSnapshot.exists) {
          final visaStatus = visaApprovalSnapshot.data()?['status'] ?? 0;

          // Update visa status if it's 0 and documents exist
          if (visaStatus == 0) {
            await visaApprovalsRef.update({'status': 1});
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VisaPendingScreen()),
            );
          } else if (visaStatus == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VisaPendingScreen()),
            );
          } else if (visaStatus == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ApprovedVisaScreen()),
            );
          } else if (visaStatus == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VisaNotApprovedScreen()),
            );
          }
        } else {
          // Handle case if there is no visaApproval document
          await visaApprovalsRef.set({'status': 0});
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VisaScreen()),
          );
        }
      }
    } catch (e) {
      // Handle exceptions appropriately
      print('Error handling visa status: $e');
    }
  }
}
