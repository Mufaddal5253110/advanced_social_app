import 'package:myapp/models/usermodal.dart';
// flutter pub run build_runner build
import 'package:hive/hive.dart';
part 'postmodel.g.dart';
@HiveType(typeId: 0)
class PostModel {
  @HiveField(0)
  final String? imageurl;
  @HiveField(1)
  final UserModal? user;
  @HiveField(2)
  final String? caption;
  @HiveField(3)
  final String? location;
  @HiveField(4)
  final String? id;
  @HiveField(5)
  final int? dbID;
  @HiveField(6)
  final DateTime? createdAt;
  @HiveField(7)
  final DateTime? updatedAt;
  @HiveField(8)
  final List<String>? likes;
  @HiveField(9)
  final List<Map<dynamic,dynamic>>? comments;

  PostModel({
    this.imageurl,
    this.user,
    this.caption,
    this.location,
    this.id,
    this.dbID,
    this.createdAt,
    this.updatedAt,
    this.likes,
    this.comments,
  });

  factory PostModel.fromJson(Map<dynamic, dynamic> json) => PostModel(
        imageurl: json['imageurl'],
        user: UserModal.fromJson(json['user']),
        caption: json['caption'],
        location: json['location'],
        id: json['_id'],
        // dbID: json['id'] ?? '',
        likes: List<String>.from(
            json['likes'].map((user) => user)),
        comments:
            List<Map<dynamic,dynamic>>.from(json['comments'].map((x) => x)),
        createdAt: DateTime.parse(json['createdAt']).toLocal(),
        updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      );
  factory PostModel.fromJson2(Map<dynamic, dynamic> json) => PostModel(
        imageurl: json['imageurl'],
        // user: UserModal.fromJson(json['user']),
        caption: json['caption'],
        location: json['location'],
        id: json['_id'],
        // dbID: json['id'] ?? '',
        // likes: List<String>.from(
        //     json['likes'].map((user) => user)),
        comments:
            List<Map<dynamic,dynamic>>.from(json['comments'].map((x) => x)),
        createdAt: DateTime.parse(json['createdAt']).toLocal(),
        updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      );

  Map<String, dynamic> toJsonForPost() => {
        'imageurl': imageurl ?? '',
        'user': user?.id ?? '',
        'caption': caption ?? '',
        'location': location ?? '',
      };

  // Map<String, dynamic> toUpdateProfileJson() => {
  //       'imageurl': imageurl ?? '',
  //       'user': user ?? '',
  //       'caption': caption ?? '',
  //       'location': location ?? '',
  //       'createdAt': createdAt!.toIso8601String(),
  //       'updatedAt': updatedAt!.toIso8601String()
  //     };
}
