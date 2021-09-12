// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostModelAdapter extends TypeAdapter<PostModel> {
  @override
  final int typeId = 0;

  @override
  PostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostModel(
      imageurl: fields[0] as String?,
      user: fields[1] as UserModal?,
      caption: fields[2] as String?,
      location: fields[3] as String?,
      id: fields[4] as String?,
      dbID: fields[5] as int?,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
      likes: (fields[8] as List?)?.cast<String>(),
      comments: (fields[9] as List?)
          ?.map((dynamic e) => (e as Map).cast<dynamic, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, PostModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.imageurl)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.caption)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.dbID)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.likes)
      ..writeByte(9)
      ..write(obj.comments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
