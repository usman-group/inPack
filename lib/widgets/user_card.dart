import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class UserCard extends StatelessWidget {
  const UserCard(this.user, {super.key});

  final types.User user;
  static const defaultUserImageUrl =
      'https://sun9-77.userapi.com/impf/EQmeC3URKZRfeCdM_pnB7LzrZpuBEzTwWeiVdQ/78O9We5g3rg.jpg?size=1242x1176&quality=96&sign=9e78c700d9449ee925b86d5da2cb527a&type=album';
  @override
  Widget build(BuildContext context) {
    final NetworkImage userImage =
        NetworkImage(user.imageUrl ?? defaultUserImageUrl);
    final String userName = user.firstName ?? 'Нет имени';
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: const Color(0xFFD8D8D8),
        border: Border.all(color: Colors.black26),
      ),
      height: 220,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 75 / 2,
                backgroundImage: userImage,
              ),
              const SizedBox(
                width: 30,
              ),
              Text(
                userName,
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 20),
          // Cigarette logo
          user.metadata?['cigarettePack'],
          // Container(
          //   alignment: Alignment.center,
          //   height: 75,
          //   decoration: BoxDecoration(
          //       color: const Color(0xFFC55252),
          //       borderRadius: BorderRadius.circular(20)),
          //   child: const Text('MARLBORO RED',
          //       style: TextStyle(fontSize: 25, color: Colors.white)),
          // )
        ],
      ),
    );
  }
}
