class CallInteraction {
  final String id;
  final String customerName;
  final String customerImage;
  final DateTime startTime;
  final String status;
  final String agentName;
  final int duration;
  final String topic;
  final double satisfaction;

  CallInteraction({
    required this.id,
    required this.customerName,
    required this.customerImage,
    required this.startTime,
    required this.status,
    required this.agentName,
    required this.duration,
    required this.topic,
    required this.satisfaction,
  });

  factory CallInteraction.fromJson(Map<String, dynamic> json) {
    return CallInteraction(
      id: json['id'],
      customerName: json['customerName'],
      customerImage: json['customerImage'],
      startTime: DateTime.parse(json['startTime']),
      status: json['status'],
      agentName: json['agentName'],
      duration: json['duration'],
      topic: json['topic'],
      satisfaction: json['satisfaction'].toDouble(),
    );
  }
}