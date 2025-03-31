import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List users = [];

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    log('Signed Out');
  }

  Future<void> fetchData() async {
    try {
      final response = await Supabase.instance.client.from('users').select();
      if (response == null) {
        print('something wrong');
      } else {
        setState(() {
          users.addAll(response);
        });
      }
    } catch (e) {
      log('error is -> $e');
    }
  }

  deleteUser({required String userId}) async {
    final List<Map<String, dynamic>> response = await Supabase.instance.client
        .from('users')
        .delete()
        .match({'uid': userId}).select();
    users = response;
    setState(() {
      
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.person),
      ),
      appBar: AppBar(
        title: Text('Home View'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                signOut();
                Navigator.pop(context);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      // body: Center(
      //     child: Column(
      //   children: [
      //     Text('user_id : users'),
      //     Text('email : moazosama@gmail.com'),
      //     Text('password : sdasd12f'),
      //     Text('name: moaz osama'),
      //   ],
      // )),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/profile",
                        arguments: users[index]);
                  },
                  onDoubleTap: () async {
                    deleteUser(userId: users[index]['uid']);
                    setState(() {});
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('${users[index]['name']}'),
                      subtitle: Text('${users[index]['email']}'),
                      trailing: Text('${users[index]['password']}'),
                      // leading: Text('${users[index]['uid']}'),
                    ),
                  ),
                )),
      ),
    );
  }
}
