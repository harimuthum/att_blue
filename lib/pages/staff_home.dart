// ignore_for_file: use_build_context_synchronously, unnecessary_new, avoid_print, depend_on_referenced_packages, unused_import, unnecessary_const

// import 'dart:math';
// import 'package:att_blue/pages/student_list.dart';
// import 'package:att_blue/models/sub.dart';
import 'package:att_blue/components/student_list_component.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'student_list.dart';

class StaffHomePage extends StatefulWidget {
  const StaffHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StaffHomePage createState() => _StaffHomePage();
}

class _StaffHomePage extends State<StaffHomePage> {
  String semesterChoosen = "Select a Option";
  String subjectChoosen = "Select a Option";
  TextEditingController dateController = TextEditingController();

  String userName = "";
  final Strategy strategy = Strategy.P2P_STAR; //1 to N
  Map<String, ConnectionInfo> endpointMap = {}; //connection details

  String? tempFileUri; //reference to the file currently being transferred
  Map<int, String> map = {}; //store filename mapped to corresponding payloadId

  @override
  void initState() {
    super.initState();
    dateController.text = "";
  }

  var semester = [
    "Select a Option",
    "Semester 1",
    "Semester 2",
    "Semester 3",
    "Semester 4",
  ];

  var subject = [
    "Select a Option",
    "Subject 1",
    "Subject 2",
    "Subject 3",
    "Subject 4",
  ];

  bool isAdvertising = false;

  Widget _takeAttendanceButton() {
    return !isAdvertising
        ? ElevatedButton(
            child: const Text('Take Attendance'),
            onPressed: () async {
              if (!await Nearby().askLocationPermission()) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Location permissions not granted :(")));
              }

              if (!await Nearby().enableLocationServices()) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Enabling Location Service Failed :(")));
              }

              if (!await Nearby().checkBluetoothPermission()) {
                Nearby().askBluetoothPermission();
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //     content: Text("Bluetooth permissions not granted :(")));
              }

              if (semesterChoosen != "Select a Option" &&
                  subjectChoosen != "Select a Option") {
                try {
                  userName = "TCE_Faculty $semesterChoosen $subjectChoosen";
                  bool a = await Nearby().startAdvertising(
                    userName,
                    strategy,
                    onConnectionInitiated: onConnectionInit,
                    onConnectionResult: (id, status) {
                      showSnackbar(status);
                    },
                    onDisconnected: (id) {
                      showSnackbar(
                          "Disconnected: ${endpointMap[id]!.endpointName}, id $id");
                      setState(() {
                        endpointMap.remove(id);
                      });
                    },
                  );
                  showSnackbar("ADVERTISING: $a");

                  setState(() {
                    isAdvertising = true;
                  });
                } catch (exception) {
                  showSnackbar(exception);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please Select All Fields")));
              }
            })
        : ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await Nearby().stopAdvertising();
                showSnackbar("Stopped Advertising");

                setState(() {
                  isAdvertising = false;
                });
              } catch (exception) {
                showSnackbar(exception);
              }
            },
            child: const Text('Stop Attendance'));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("TCE Faculty"),
          actions: [
            GestureDetector(
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20.0,
                  child: Icon(Icons.logout_sharp),
                ),
                onTap: () async {
                  await Nearby().stopAdvertising();
                  await FirebaseAuth.instance.signOut();
                  Get.toNamed('/login');
                }),
          ],
          bottom: const TabBar(tabs: [
            Tab(text: "Take Attendance"),
            Tab(text: "View Attendance"),
          ]),
        ),
        body: TabBarView(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * 0.05),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Select Semester
                Container(
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                  child: Row(
                    children: [
                      const Text("Choose Semester ",
                          style: TextStyle(fontSize: 13)),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: DropdownButton(
                          value: semesterChoosen,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: semester.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              semesterChoosen = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                //Select Subject
                Container(
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                  child: Row(
                    children: [
                      const Text('Choose Subject     ',
                          style: TextStyle(fontSize: 13)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(3.0)),
                          child: DropdownButton(
                            value: subjectChoosen, // Initial Value
                            icon: const Icon(
                                Icons.keyboard_arrow_down), // Down Arrow Icon
                            items: subject.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                subjectChoosen = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Select Date
                Container(
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          labelText: "Enter Date"),
                      readOnly: true,
                      onTap: (() async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat("dd-MM-yyyy").format(pickedDate);
                          setState(() {
                            dateController.text = formattedDate.toString();
                          });
                        } else {
                          const Text("Not Selected Date!!!");
                        }
                      }),
                    ),
                  ),
                ),
                //Take Attendance Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _takeAttendanceButton(),
                ),
                //Student List Button
                ElevatedButton(
                    onPressed: () {
                      // print("$semesterChoosen $subjectChoosen ${dateController.text}");
                      if (semesterChoosen == "Select a Option" ||
                          subjectChoosen == "Select a Option" ||
                          dateController.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please Select All Fields")));
                        return;
                      }
                      Get.toNamed('/studentList', arguments: {
                        "semester": semesterChoosen,
                        "subject": subjectChoosen,
                        "date": dateController.text
                      });
                    },
                    child: const Text("Student List")),
              ],
            ),
          ),
          StudentListComponent(
            date: semesterChoosen,
            subject: subjectChoosen,
            semester: dateController.text,
          ),
        ]),
      ),
    );
  }

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

  //  Called upon Connection request (on both devices)
  // Both need to accept connection to start sending/receiving
  void onConnectionInit(String id, ConnectionInfo info) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Center(
          child: Column(
            children: <Widget>[
              Text("id: $id"),
              Text("Token: ${info.authenticationToken}"),
              Text("Name: ${info.endpointName}"),
              Text("Incoming: ${info.isIncomingConnection}"),
              ElevatedButton(
                child: const Text("Accept Connection"),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    endpointMap[id] = info;
                  });
                  Nearby().acceptConnection(
                    id,
                    onPayLoadRecieved: (endid, payload) async {},
                    onPayloadTransferUpdate: (endid, payloadTransferUpdate) {},
                  );
                },
              ),
              ElevatedButton(
                child: const Text("Reject Connection"),
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await Nearby().rejectConnection(id);
                  } catch (e) {
                    showSnackbar(e);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
