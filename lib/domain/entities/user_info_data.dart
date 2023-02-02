
class UserInfoData {
  final String userName;
  final String userEmail;
  final String userId;

  UserInfoData(this.userName, this.userEmail, this.userId);

  UserInfoData.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        userId = json['userId'],
        userEmail = json['userEmail'];

  Map<String, dynamic> toJson() => {
    'name': userName,
    'userId': userId,
    'userEmail': userEmail,
  };
}