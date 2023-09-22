import 'package:bloc_user_app/bloc/user_event.dart';
import 'package:bloc_user_app/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/user_model.dart';
import '../service/api_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UsersLoadingState()) {
    ApiService apiService = ApiService();

    on<LoadAllUserEvent>((event, emit) async {
      if (state is UsersLoadedState) {
        final currentState = state as UsersLoadedState;
        if (currentState.users.isEmpty) {
          emit(UsersLoadingState());
        }
      }

      try {
        final users = await apiService.getAllUsersApi(event.page);
        emit(UsersLoadedState(
          event.page == 1
              ? users
              : [...(state as UsersLoadedState).users, ...users],
          User(firstName: "", lastName: "", email: "", avatar: ""),
        ));
      } catch (e) {
        emit(UsersErrorState(e.toString()));
      }
    });

    on<LoadUserEvent>((event, emit) async {
      emit(UsersLoadingState());
      try {
        final user = await apiService.getUserDetails(event.userId);
        emit(UsersLoadedState(event.users, user!));
      } catch (e) {
        emit(UsersErrorState(e.toString()));
      }
    });
  }
}
