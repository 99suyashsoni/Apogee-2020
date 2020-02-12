import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreenPreApogeeController with ChangeNotifier{

  bool isLoading=false;
  bool validInput=true;
  int state=0;
  int tokens=0;
  String id="";
  String message ="";
  String qrcode="";
  String name="";
  String college="";
  FlutterSecureStorage _secureStorage; 
  
  ProfileScreenPreApogeeController({
    
    FlutterSecureStorage secureStorage,
  }):this._secureStorage=secureStorage{
       getUserData();  
  }
  
  Future<Null> launchUrl() async {
    isLoading=true;
    notifyListeners();
    const url = 'https://bits-apogee.org/';
    if (await canLaunch(url)) {
     await launch(url);
      isLoading=false;
      notifyListeners();
    } 
  else {
    state=2;
    message="OOPs: Can't load now";
   }
  }
 
     

  Future<Null> getUserData() async{
    qrcode=await _secureStorage.read(key: 'QR');
    name=await _secureStorage.read(key: 'NAME');
    //collegename
    isLoading=false;
    notifyListeners();
  } 
}