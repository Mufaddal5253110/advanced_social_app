import 'package:hive/hive.dart';
part 'usermodal.g.dart';

@HiveType(typeId: 1)
class UserModal {
  @HiveField(0)
  final String? firstname;
  @HiveField(1)
  final String? lastname;
  @HiveField(2)
  final String? fullname;
  @HiveField(3)
  final String? profileImage;
  @HiveField(4)
  final String? username;
  @HiveField(5)
  final String? fbId;
  @HiveField(6)
  final bool? admin;
  @HiveField(7)
  final String? id;
  @HiveField(8)
  final int? dbID;
  @HiveField(9)
  final String? website;
  @HiveField(10)
  final String? bio;
  @HiveField(11)
  final List<String>? followers;
  @HiveField(12)
  final List<String>? followings;

  UserModal({
    this.firstname,
    this.lastname,
    this.fullname,
    this.profileImage,
    this.username,
    this.fbId,
    this.admin,
    this.id,
    this.dbID,
    this.website,
    this.bio,
    this.followers,
    this.followings,
  });

  factory UserModal.fromJson(Map<dynamic, dynamic> json) => UserModal(
        firstname: json['firstname'],
        lastname: json['lastname'],
        fullname: json['fullname'],
        profileImage: json['profileImage'],
        username: json['username'],
        fbId: json['fbId'],
        admin: json['admin'],
        id: json['_id'],
        dbID: json['id'],
        website: json['website'],
        bio: json['bio'],
        followers: List<String>.from(json["followers"].map((x) => x)),
        followings: List<String>.from(json["followings"].map((x) => x)),
      );
  factory UserModal.fromJson2(Map<dynamic, dynamic> json) => UserModal(
        firstname: json['firstname'],
        lastname: json['lastname'],
        fullname: json['fullname'],
        profileImage: json['profileImage'],
        username: json['username'],
        fbId: json['fbId'],
        admin: json['admin'],
        id: json['_id'],
        dbID: json['id'],
        website: json['website'],
        bio: json['bio'],
        followers: json["followers"].split(','),
        followings: json["followings"].split(','),
      );

  Map<String, dynamic> toJson() => {
        'firstname': firstname ?? '',
        'lastname': lastname ?? '',
        'fullname': fullname ?? '',
        'username': username ?? '',
        'profileImage': profileImage ?? '',
        'fbId': fbId ?? '',
        '_id': id,
        'website': website ?? '',
        'bio': bio ?? '',
        'followers': followers?.join(','),
        'followings': followings?.join(','),
      };
  Map<String, dynamic> toUpdateProfileJson() => {
        'firstname': firstname ?? '',
        'lastname': lastname ?? '',
        'fullname': fullname ?? '',
        'username': username ?? '',
        'profileImage': profileImage ?? '',
        'website': website ?? '',
        'bio': bio ?? '',
      };
  Map<String, dynamic> toUpdateFollower() => {
        'followers': followers?.join(','),
      };
  Map<String, dynamic> toUpdateFollowing() => {
        'followings': followings?.join(','),
      };
}
