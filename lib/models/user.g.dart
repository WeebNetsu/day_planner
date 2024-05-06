// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      loginToken: json['loginToken'] as String?,
      id: objectIdToString(json['_id'] as ObjectId?),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      '_id': stringToObjectId(instance.id),
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'createdAt': instance.createdAt.toIso8601String(),
      'loginToken': instance.loginToken,
    };

MiniUserModel _$MiniUserModelFromJson(Map<String, dynamic> json) =>
    MiniUserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      id: objectIdToString(json['_id'] as ObjectId?),
    )..loginToken = json['loginToken'] as String?;

Map<String, dynamic> _$MiniUserModelToJson(MiniUserModel instance) =>
    <String, dynamic>{
      '_id': stringToObjectId(instance.id),
      'name': instance.name,
      'email': instance.email,
      'loginToken': instance.loginToken,
    };
