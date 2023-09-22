import 'package:bloc_user_app/views/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 1;
  bool firstLoadRunning = false;
  bool hasNextPage = false; // Initially, there is no next page
  ScrollController _controller = ScrollController();

  Future _loadMore() async {
    if (_controller.position.extentAfter < 300 && hasNextPage) {
      setState(() {
        page++;
      });

      if (page > 2) {
        setState(() {
          hasNextPage = false;
        });
      }

      await getAllUsers();
    }
  }

  Future _firstLoad() async {
    setState(() {
      firstLoadRunning = true;
    });

    await getAllUsers();

    setState(() {
      firstLoadRunning = false;
      hasNextPage = true;
    });
  }

  Future getAllUsers() async {
    context.read<UserBloc>().add(LoadAllUserEvent(page));
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Screen")),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UsersLoadingState && (firstLoadRunning || hasNextPage)) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoadedState) {
            final users = state.users;
            if (users.isEmpty) {
              return const Center(child: Text("No users available"));
            }
            return ListView.builder(
              controller: _controller,
              itemCount: users.length + (hasNextPage ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < users.length) {
                  final user = users[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 35),
                      child: ListTile(
                        title: Text("UserId: ${user.id.toString()}",   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                        subtitle: Text(
                          "Name: ${user.firstName} ${user.lastName}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            context
                                .read<UserBloc>()
                                .add(LoadUserEvent(user.id!, users));
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const UserDetails(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: const Text("Get More Details"),
                        ),
                      ),
                    ),
                  );
                } else {
                  if (hasNextPage) {
                    // Show a loading indicator when there are more pages to load
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    // Show a SizedBox when there are no more pages to load
                    return const SizedBox.shrink();
                  }
                }
              },
            );
          } else if (state is UsersErrorState) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
