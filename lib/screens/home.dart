import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/blocs/auth_bloc.dart';
import 'package:flutter_task/screens/login.dart';
import 'package:flutter_task/screens/upload_products.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<User> loginStateSubscription;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    final authBloc = Provider.of<AuthBloc>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () => authBloc.logout()),
        ],
      ),
      body:
          //  Column(
          //   children: [
          // Container(
          //   width: deviceWidth,
          //   height: deviceHeight * 0.10,
          //   color: Colors.blue,
          //   child: Column(
          //     children: [
          //       SizedBox(
          //         height: 30,
          //       ),
          //       StreamBuilder<User>(
          //           stream: authBloc.currentUser,
          //           builder: (context, snapshot) {
          //             if (!snapshot.hasData) return CircularProgressIndicator();
          //             print(snapshot.data.photoURL);
          //             return Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceAround,
          //               children: [
          //                 CircleAvatar(
          //                   backgroundImage: NetworkImage(snapshot.data.photoURL
          //                       .replaceFirst('s96', 's400')),
          //                   radius: 20.0,
          //                 ),
          //                 Text(snapshot.data.displayName,
          //                     style: TextStyle(fontSize: 22.0)),
          //                 IconButton(
          //                     icon: Icon(
          //                       Icons.power_settings_new,
          //                       size: 30,
          //                       color: Colors.red,
          //                     ),
          //                     onPressed: () => authBloc.logout())
          //               ],
          //             );
          //           }),
          //     ],
          //   ),
          // ),
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                if (snapshot.data.docs.length == 0) {
                  return Center(child: Text('No Data'));
                }

                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                snapshot.data.docs[index]['imageURL'],
                                height: 130,
                                width: 130,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data.docs[index]['title'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  snapshot.data.docs[index]['desc'],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.edit), onPressed: () {}),
                                SizedBox(
                                  height: 30,
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {}),
                              ],
                            )
                          ],
                        ),
                      );
                    });
              }),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UploadProducts()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
