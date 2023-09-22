import '../model/user_model.dart';

abstract class UserState {}

class UsersLoadingState extends UserState {}

class UsersLoadedState extends UserState {
  final List<User> users;
  final User user;

  UsersLoadedState(this.users, this.user);


}

class UsersErrorState extends UserState {
  final String error;

  UsersErrorState(this.error);
}
