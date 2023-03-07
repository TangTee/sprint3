class Message {
  Message({
    required this.image,
    required this.message,
    required this.profile,
    required this.sender,
    required this.time,
  });

  late final bool image;
  late final String message;
  late final String profile;
  late final String sender;
  late final String time;

  Message.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    message = json['message'].toString();
    profile = json['profile'].toString();
    sender = json['sender'].toString();
    time = json['time'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['message'] = message;
    data['profile'] = profile;
    data['sender'] = sender;
    data['time'] = time;
    return data;
  }
}
