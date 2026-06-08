// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewUser _$NewUserFromJson(Map<String, dynamic> json) => NewUser(
  name: json['name'] as String,
  email: json['email'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$NewUserToJson(NewUser instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'runtimeType': instance.$type,
};

LoadedUser _$LoadedUserFromJson(Map<String, dynamic> json) => LoadedUser(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$LoadedUserToJson(LoadedUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'runtimeType': instance.$type,
    };

NotLoggedUser _$NotLoggedUserFromJson(Map<String, dynamic> json) =>
    NotLoggedUser($type: json['runtimeType'] as String?);

Map<String, dynamic> _$NotLoggedUserToJson(NotLoggedUser instance) =>
    <String, dynamic>{'runtimeType': instance.$type};

LoggedUser _$LoggedUserFromJson(Map<String, dynamic> json) => LoggedUser(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  token: json['token'] as String,
  refreshToken: json['refreshToken'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$LoggedUserToJson(LoggedUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'runtimeType': instance.$type,
    };
