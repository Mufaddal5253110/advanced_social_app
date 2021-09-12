import 'package:myapp/models/usermodal.dart';

class CommentModel {
  final UserModal? user;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? id;


  CommentModel({
    this.user,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  factory CommentModel.fromJson(Map<dynamic, dynamic> json) => CommentModel(
        user: UserModal.fromJson(json['user']),
        id: json['_id'],
        comment: json['comment'],
        createdAt: DateTime.parse(json['createdAt']).toLocal(),
        updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      );
}
