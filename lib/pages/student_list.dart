import 'dart:developer';

import 'package:att_blue/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.logout),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Maths")
            .where("Email", isEqualTo: "abcd@student.tce.edu")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Text("No Data Found");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (snapshot != null && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var email = snapshot.data!.docs[index]['Email'];
                var regno = snapshot.data!.docs[index]['Reg_No'];
                log(email);
                return const Card(
                  child: ListTile(title: Text("email")
                      // subtitle: Text(regno),
                      ),
                );
              },
            );
          }

          return Container(
              // child: Text("${user?.uid}"),
              );
        },
      ),
    );
  }
}
