import 'package:flutter/material.dart';
import 'package:trajectory_data/src/api_services/trajectory/trajectory_api_service.dart';

class TrajectoryApiStatusWidget extends StatelessWidget {
  final trajectoryApiServiceController = TrajectoryApiServiceController.getTrajectoryApiService();

  TrajectoryApiStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(trajectoryApiServiceController.getFeedbackMessage());
  }
}