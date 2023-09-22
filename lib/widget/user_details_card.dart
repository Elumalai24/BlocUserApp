import 'package:flutter/material.dart';

class UserDetailsCard extends StatelessWidget {
  final String avatar;
  final String firstName;
  final String lastName;
  final String email;

  const UserDetailsCard({
    super.key,
    required this.avatar,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: Colors.red.shade50,
        height: 300,
        width: 300,
        margin: const EdgeInsets.only(top: 60),
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              avatar,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              '$firstName $lastName',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              email,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
