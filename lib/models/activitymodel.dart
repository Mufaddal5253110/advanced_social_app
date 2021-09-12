import 'package:myapp/models/postmodel.dart';
import 'package:myapp/models/usermodal.dart';

class Activitymodel {
  final UserModal? from;
  final UserModal? to;
  final PostModel? post;
  final String? type;
  final String? likedcomment;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? id;


  Activitymodel({
    this.from,
    this.to,
    this.post,
    this.type,
    this.likedcomment,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  factory Activitymodel.fromJson(Map<dynamic, dynamic> json) => Activitymodel(
        to: UserModal.fromJson(json['to']),
        from: UserModal.fromJson(json['from']),
        post: PostModel.fromJson2(json['post']),
        type: json['type'],
        id: json['_id'],
        likedcomment: json['likedcomment'] ,
        comment: json['comment'],
        createdAt: DateTime.parse(json['createdAt']).toLocal(),
        updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      );

  //  Map<String, dynamic> toJson() => {
  //       'to': imageurl ?? '',
  //       'user': user?.id ?? '',
  //       'caption': caption ?? '',
  //       'location': location ?? '',
  //     };
}
