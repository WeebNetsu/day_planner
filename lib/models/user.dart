import 'package:day_planner/connections/connections.dart';
import 'package:day_planner/models/models.dart';
import 'package:day_planner/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'user.g.dart';

/// This is the user account model
@JsonSerializable()
class UserModel {
  /// Name of the collection in MongoDB
  static const collectionName = "users";

  @JsonKey(
    name: '_id',
    fromJson: objectIdToString,
    toJson: stringToObjectId,
  )
  final String? id;

  /// The user display name
  final String name;
  final String email;
  final String password;
  final DateTime createdAt;

  /// if user is logged in, they will have a login token to prove it
  String? loginToken;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
    this.loginToken,
    this.id,
  });

  /// Constructs an [UserModel] object from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  /// Constructs an [UserModel] object from a JSON map.
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// get the current logged in user (based on user login token)
  ///
  /// null if no user is logged in
  static Future<UserModel?> getLoggedInUser() async {
    final EncryptedLocallyStoredDataModel storedData = EncryptedLocallyStoredDataModel();

    final storedDataSuccess = await storedData.loadFromStorage();

    if (!storedDataSuccess) {
      return null;
    }

    if (storedData.loginToken == null) {
      return null;
    }

    final conn = MongoDB.db?.collection(UserModel.collectionName);

    // todo check if user is already logged in
    final existingUsers = await conn
        ?.find(
          where.eq("loginToken", storedData.loginToken).limit(2),
        )
        .toList();

    if (existingUsers == null) {
      return null;
    }

    if (existingUsers.length != 1) {
      return null;
    }

    final firstUser = existingUsers.firstOrNull;

    if (firstUser == null) {
      return null;
    }

    final user = UserModel.fromJson(firstUser);

    return user;
  }
}

/// Much smaller version of the user model with only basic user information
@JsonSerializable()
class MiniUserModel extends UserModel {
  MiniUserModel({
    required super.name,
    required super.email,
    super.id,
  }) : super(
          password: '', // default values for required arguments
          createdAt: DateTime.now(),
        );

  static const fields = ["_id", "name", "email"];

  /// Constructs an [MiniUserModel] object from a JSON map.
  factory MiniUserModel.fromJson(Map<String, dynamic> json) => _$MiniUserModelFromJson(json);

  /// Constructs an [MiniUserModel] object from a JSON map.
  @override
  Map<String, dynamic> toJson() => _$MiniUserModelToJson(this);
}
