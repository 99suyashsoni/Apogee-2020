import 'dart:convert';
import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallDataItem.dart';
import 'package:apogee_main/wallet/view/MenuScreen.dart';
import 'package:apogee_main/wallet/view/StallItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../shared/network/errorState.dart';

class StallScreen extends StatefulWidget {
  @override
  _StallScreenState createState() => _StallScreenState();
}

class _StallScreenState extends State<StallScreen> {
  // MyStallModel _myStallModel;


  @override
  Widget build(BuildContext context) {
   // Provider.of<MyStallModel>(context, listen: false).fetchStallData();
    return Screen(
      selectedTabIndex: 0,
      title: "Stall",
      endColor: topLevelScreensGradientEndColor,
      screenBackground: orderScreenBackground,
      startColor: topLevelScreensGradientStartColor,
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Consumer<MyStallModel>(
                builder: (context, mystallmodel, child) {
                  // _myStallModel = mystallmodel;
                  if(mystallmodel.state ==2) {
                      Fluttertoast.showToast(msg: mystallmodel.message);
                      mystallmodel.state=0;
                     }
                  return mystallmodel.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : mystallmodel.stallItems.isEmpty
                          ? Center(child: Text("No Stalls are available"))
                          : Container(
                            margin: EdgeInsets.fromLTRB(16.0,0,16.0,0.0),
                              child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio: 2.0/2.5,
                              children: List.generate(mystallmodel.stallItems.length, (index) {
                                return GestureDetector(
                                  child: StallItemWidget(
                                    stallDataItem: mystallmodel.stallItems[index]),
                                  onTap: () {
                                        Navigator.of(context).push(
                                         MaterialPageRoute(
                                            builder: (context) =>
                                              MenuScreen(mystallmodel
                                                .stallItems[index]
                                                .stallId,mystallmodel
                                                .stallItems[index]
                                                .stallName,mystallmodel._networkClient,mystallmodel._walletDao),
                                              settings: RouteSettings(name:"/menuItems$index")
                                              ));
                                  },
                                );
                              }),
                              ),
   
                           );
                
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//            Navigator.of(context).pushNamedAndRemoveUntil('/stalls', ModalRoute.withName('/events'));
class MyStallModel with ChangeNotifier {
  bool isLoading = false;
  int state;
  String message="";

  //List<StallDataItem> stallItems;

  WalletDao _walletDao;
  CustomHttpNetworkClient _networkClient;
  List<StallDataItem> stallItems = [];

  MyStallModel({WalletDao walletDao, CustomHttpNetworkClient networkClient})
      : this._walletDao = walletDao,
        this._networkClient = networkClient {
    isLoading = true;
    displayStallDataItems();
    fetchStallData();
  }

  Future<Null> displayStallDataItems() async {
     print("try: inside displayStallItems");
    stallItems = await _walletDao.getAllStalls();
    isLoading = false;
    notifyListeners();
    print("try: sucessfully displayed stakllitems = $stallItems");
  }

  Future<Null> fetchStallData() async {
    print("try: inside fetchstalldata");
    isLoading = true;
    notifyListeners();
   ErrorState errorState= await _networkClient.get(
      "wallet/vendors/",
      (response) async {
        await _walletDao.insertAllStalls((json.decode(response)));
        isLoading = false;
        displayStallDataItems();
        notifyListeners();
      },
    );
     if(errorState.state==2){
      state=2;
      message=errorState.message;
      isLoading=false;
      notifyListeners();
    }
  }
}
