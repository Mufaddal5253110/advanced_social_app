// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usermodal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModalAdapter extends TypeAdapter<UserModal> {
  @override
  final int typeId = 1;

  @override
  UserModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModal(
      firstname: fields[0] as String?,
      lastname: fields[1] as String?,
      fullname: fields[2] as String?,
      profileImage: fields[3] as String?,
      username: fields[4] as String?,
      fbId: fields[5] as String?,
      admin: fields[6] as bool?,
      id: fields[7] as String?,
      dbID: fields[8] as int?,
      website: fields[9] as String?,
      bio: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModal obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.firstname)
      ..writeByte(1)
      ..write(obj.lastname)
      ..writeByte(2)
      ..write(obj.fullname)
      ..writeByte(3)
      ..write(obj.profileImage)
      ..writeByte(4)
      ..write(obj.username)
      ..writeByte(5)
      ..write(obj.fbId)
      ..writeByte(6)
      ..write(obj.admin)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.dbID)
      ..writeByte(9)
      ..write(obj.website)
      ..writeByte(10)
      ..write(obj.bio);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
