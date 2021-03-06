import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class User extends Equatable {
  const User({
    @required this.email,
    @required this.id,
    @required this.photo,
    @required this.name,
  })  : assert(email != null),
        assert(id != null);

  final String email;
  final String id;
  final String name;
  final String photo;

  static const empty = User(email: "empty", id: "", name: null, photo: null);

  @override
  List<Object> get props => [email, id, name, photo];
}
