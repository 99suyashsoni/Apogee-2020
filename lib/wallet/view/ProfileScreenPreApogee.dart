import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/controller/ProfileController_PreApogee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileScreenPreApogee extends StatefulWidget {
  @override
  _ProfileScreenPreApogeeState createState() => _ProfileScreenPreApogeeState();
  FlutterSecureStorage secureStorage;
  ProfileScreenPreApogee(this.secureStorage);
}

class _ProfileScreenPreApogeeState extends State<ProfileScreenPreApogee> {
  String id = "";

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  Future<Null> getUserId() async {
    var x = await widget.secureStorage.read(key: "ID");
    setState(() {
      id = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return id.isEmpty
        ? Screen(
            child: Center(child: CircularProgressIndicator()),
            selectedTabIndex: -1,
            title: "Profile",
          )
        : StreamBuilder<DocumentSnapshot>(
            stream:
                Firestore.instance.collection('users').document(id).snapshots(),
            builder: (context, snapshot) {
              return Screen(
                  selectedTabIndex: -1,
                  title: "Profile",
                  child: Container(
                    decoration: new BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/BG3x.png'),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Consumer<ProfileScreenPreApogeeController>(
                            builder:
                                (context, profilePreApogeeController, child) {
                              if (profilePreApogeeController.state == 2) {
                                Fluttertoast.showToast(
                                    msg: profilePreApogeeController.message);
                                profilePreApogeeController.state = 0;
                              }
                              return profilePreApogeeController.isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Image.asset(
                                                          'assets/apogee_logo@2x.png',
                                                          scale: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 8.0, top: 16.0),
                                                    child: Center(
                                                      child: Text(
                                                        profilePreApogeeController
                                                                .name.isEmpty
                                                            ? "???"
                                                            : profilePreApogeeController
                                                                .name,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Google-Sans',
                                                            fontSize: 28),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Center(
                                                      child: Text(
                                                        profilePreApogeeController
                                                                .college.isEmpty
                                                            ? "BITS PILANI"
                                                            : profilePreApogeeController
                                                                .college,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Google-Sans',
                                                            fontSize: 20),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: Text(""),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          'KindStore Points: ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Google-Sans',
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                            snapshot == null
                                                                ? "???"
                                                                : snapshot
                                                                        .hasData
                                                                    ? (snapshot.data["tokens"] ??
                                                                            "???")
                                                                        .toString()
                                                                    : "???",
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Google-Sans',
                                                                fontSize: 18),
                                                            textAlign: TextAlign
                                                                .center),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              margin: EdgeInsets.all(0),
                                              color: Colors.transparent,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 238, 238, 238),
                                                      borderRadius: new BorderRadius
                                                              .only(
                                                          topLeft: const Radius
                                                              .circular(40.0),
                                                          topRight: const Radius
                                                              .circular(40.0))),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                16, 24, 16, 16),
                                                        child: GestureDetector(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                'Go to main website',
                                                                maxLines: 1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Google-Sans',
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              Icon(
                                                                  Icons.launch),
                                                            ],
                                                          ),
                                                          onTap: () {
                                                            profilePreApogeeController
                                                                .launchUrl();
                                                          },
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Container(
                                                          constraints:
                                                              BoxConstraints(
                                                                  maxHeight:
                                                                      240,
                                                                  maxWidth: 240,
                                                                  minHeight:
                                                                      160,
                                                                  minWidth:
                                                                      160),
                                                          child: profilePreApogeeController
                                                                  .qrcode
                                                                  .isEmpty
                                                              ? Center(
                                                                  child:
                                                                      CircularProgressIndicator())
                                                              : QrImage(
                                                                  data: profilePreApogeeController
                                                                      .qrcode,
                                                                  version:
                                                                      QrVersions
                                                                          .auto,
                                                                  constrainErrorBounds:
                                                                      true,
                                                                  errorStateBuilder:
                                                                      (cxt,
                                                                          err) {
                                                                    return Container(
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "OOPs!!! Try again after sometime.",
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                  ));
            });
  }
}