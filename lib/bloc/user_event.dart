import '../model/user_model.dart';

abstract class UserEvent {}

class LoadPostsEvent extends UserEvent {}

class LoadProductsEvent extends UserEvent {}

class LoadAllUserEvent extends UserEvent {
  final int page;
  LoadAllUserEvent(this.page);
}

class LoadUserEvent extends UserEvent {
  final int userId;
  List<User> users;
  LoadUserEvent(this.userId, this.users);
}
