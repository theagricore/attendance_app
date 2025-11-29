class AttendanceRecord {
  final String recordId;
  final String shopId;
  final String shopName;
  final DateTime punchInTime;
  final DateTime? punchOutTime;
  final String punchInSelfieUrl;
  final String? punchOutSelfieUrl;
  final double punchInLatitude;
  final double punchInLongitude;
  final double? punchOutLatitude;
  final double? punchOutLongitude;

  AttendanceRecord({
    required this.recordId,
    required this.shopId,
    required this.shopName,
    required this.punchInTime,
    this.punchOutTime,
    required this.punchInSelfieUrl,
    this.punchOutSelfieUrl,
    required this.punchInLatitude,
    required this.punchInLongitude,
    this.punchOutLatitude,
    this.punchOutLongitude,
  });

  Duration get workingDuration {
    if (punchOutTime == null) return Duration.zero;
    return punchOutTime!.difference(punchInTime);
  }

  String get formattedWorkingHours {
    final duration = workingDuration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  Map<String, dynamic> toMap() {
    return {
      'recordId': recordId,
      'shopId': shopId,
      'shopName': shopName,
      'punchInTime': punchInTime.millisecondsSinceEpoch,
      'punchOutTime': punchOutTime?.millisecondsSinceEpoch,
      'punchInSelfieUrl': punchInSelfieUrl,
      'punchOutSelfieUrl': punchOutSelfieUrl,
      'punchInLatitude': punchInLatitude,
      'punchInLongitude': punchInLongitude,
      'punchOutLatitude': punchOutLatitude,
      'punchOutLongitude': punchOutLongitude,
    };
  }

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      recordId: map['recordId'] ?? '',
      shopId: map['shopId'] ?? '',
      shopName: map['shopName'] ?? '',
      punchInTime: DateTime.fromMillisecondsSinceEpoch(map['punchInTime'] ?? 0),
      punchOutTime: map['punchOutTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['punchOutTime'])
          : null,
      punchInSelfieUrl: map['punchInSelfieUrl'] ?? '',
      punchOutSelfieUrl: map['punchOutSelfieUrl'],
      punchInLatitude: map['punchInLatitude']?.toDouble() ?? 0.0,
      punchInLongitude: map['punchInLongitude']?.toDouble() ?? 0.0,
      punchOutLatitude: map['punchOutLatitude']?.toDouble(),
      punchOutLongitude: map['punchOutLongitude']?.toDouble(),
    );
  }
}