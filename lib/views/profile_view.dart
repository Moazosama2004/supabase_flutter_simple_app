import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile View'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                image: NetworkImage('${user['avatar_url']}'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('${user['name']}'),
              subtitle: Text('${user['email']}'),
              trailing: Text('${user['password']}'),
              // leading: Text('${users[index]['uid']}'),
            ),
          )
        ],
      ),
    );
  }
}
