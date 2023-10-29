import 'dart:convert';

class TrajectoryData {
  final String _datetime = DateTime.now().toString();
  String? _userId;
  List<List<double>>? _trajectory;

  TrajectoryData(String userId, List<List<double>> trajectory) {
    _userId = userId;
    _trajectory = trajectory;
  }

  Map<String, dynamic> mapToJson () {
    return {
      'user': _userId,
      'datetime': _datetime,
      'trajectory': jsonEncode(_trajectory),
    };
  }
}