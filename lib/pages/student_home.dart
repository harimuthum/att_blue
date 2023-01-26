import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student HomePage"),
      ),
    );
  }

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

  // Future<bool> moveFile(String uri, String fileName) async {
  // String parentDir = (await getExternalStorageDirectory())!.absolute.path;
  // final b =
  //     await Nearby().copyFileAndDeleteOriginal(uri, '$parentDir/$fileName');

  // showSnackbar("Moved file:" + b.toString());
  // return b;
  // }

  /// Called upon Connection request (on both devices)
  /// Both need to accept connection to start sending/receiving
  // void onConnectionInit(String id, ConnectionInfo info) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (builder) {
  //       return Center(
  //         child: Column(
  //           children: <Widget>[
  //             Text("id: $id"),
  //             Text("Token: ${info.authenticationToken}"),
  //             Text("Name: ${info.endpointName}"),
  //             Text("Incoming: " + info.isIncomingConnection.toString()),
  //             ElevatedButton(
  //               child: Text("Accept Connection"),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 setState(() {
  //                   endpointMap[id] = info;
  //                 });
  //                 Nearby().acceptConnection(
  //                   id,
  //                   onPayLoadRecieved: (endid, payload) async {
  //                   //   if (payload.type == PayloadType.BYTES) {
  //                   //     String str = String.fromCharCodes(payload.bytes!);
  //                   //     showSnackbar(endid + ": " + str);

  //                   //     if (str.contains(':')) {
  //                   //       // used for file payload as file payload is mapped as
  //                   //       // payloadId:filename
  //                   //       int payloadId = int.parse(str.split(':')[0]);
  //                   //       String fileName = (str.split(':')[1]);

  //                   //       if (map.containsKey(payloadId)) {
  //                   //         if (tempFileUri != null) {
  //                   //           moveFile(tempFileUri!, fileName);
  //                   //         } else {
  //                   //           showSnackbar("File doesn't exist");
  //                   //         }
  //                   //       } else {
  //                   //         //add to map if not already
  //                   //         map[payloadId] = fileName;
  //                   //       }
  //                   //     }
  //                   //   } else if (payload.type == PayloadType.FILE) {
  //                   //     showSnackbar(endid + ": File transfer started");
  //                   //     tempFileUri = payload.uri;
  //                   //   }
  //                   },
  //                   onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
  //                     // if (payloadTransferUpdate.status ==
  //                     //     PayloadStatus.IN_PROGRESS) {
  //                     //   print(payloadTransferUpdate.bytesTransferred);
  //                     // } else if (payloadTransferUpdate.status ==
  //                     //     PayloadStatus.FAILURE) {
  //                     //   print("failed");
  //                     //   showSnackbar(endid + ": FAILED to transfer file");
  //                     // } else if (payloadTransferUpdate.status ==
  //                     //     PayloadStatus.SUCCESS) {
  //                     //   showSnackbar(
  //                     //       "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");

  //                     //   if (map.containsKey(payloadTransferUpdate.id)) {
  //                     //     //rename the file now
  //                     //     String name = map[payloadTransferUpdate.id]!;
  //                     //     moveFile(tempFileUri!, name);
  //                     //   } else {
  //                     //     //bytes not received till yet
  //                     //     map[payloadTransferUpdate.id] = "";
  //                     //   }
  //                     // }
  //                   },
  //                 );
  //               },
  //             ),
  //             ElevatedButton(
  //               child: Text("Reject Connection"),
  //               onPressed: () async {
  //                 Navigator.pop(context);
  //                 try {
  //                   await Nearby().rejectConnection(id);
  //                 } catch (e) {
  //                   showSnackbar(e);
  //                 }
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

}
