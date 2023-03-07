
class Post {
  final String activityName;
  final String place;
  final String location;
  final DateTime date;
  final String time;
  final String detail;
  final String peopleLimit;
  final String uid;
  final String timeStamp;
  final String postId;
  final String tag;

  Post({
    required this.activityName,
    required this.place,
    required this.location,
    required this.date,
    required this.time,
    required this.detail,
    required this.peopleLimit,
    required this.uid,
    required this.timeStamp,
    required this.postId,
    required this.tag,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      activityName: map['activityName'] ?? '',
      place: map['place'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      detail: map['detail'] ?? '',
      peopleLimit: map['peopleLimit'] ?? '',
      uid: map['uid'] ?? '',
      tag: map['tag'] ?? '',
      timeStamp: map['timeStamp'] ?? '',
      postId: map['postId'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "activityName": activityName,
      "place": place,
      "location": location,
      "date": date,
      "time": time,
      "detail": detail,
      "peopleLimit": peopleLimit,
      "uid": uid,
      "tag": tag,
      "timeStamp": timeStamp,
      "postId": postId,
    };
  }
}
