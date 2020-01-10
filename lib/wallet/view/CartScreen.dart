import 'package:apogee_main/shared/UIMessageListener.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/controller/CartController.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/CartItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> implements UIMessageListener{
  @override
  Widget build(BuildContext context) {
    return Screen(
      selectedTabIndex: -1,
      title: "Cart",
      child: ChangeNotifierProvider<CartController>(
        create: (BuildContext context) => CartController(),
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Consumer<CartController>(
                  builder: (context, controller, child) {
                    return FutureBuilder<List<CartItem>>(
                      future: controller.getCartItems(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator(),);
                        else if(snapshot.connectionState == ConnectionState.done) {
                          if(snapshot.data is List<CartItem>) {
                            List<CartItem> items = snapshot.data as List<CartItem>;
                            if(items.isEmpty) {
                              return Center(
                                child: Container(
                                  child: Text("There are no items in the cart"),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: Center(child: Text(items[index].itemName),),
                                  );
                                },
                              );
                            }
                          } else {
                            onAlertMessageRecived(message: "Something went abslutely wrong. Restart your app");
                            return Container();
                          }
                        }
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  @override
  void onAlertMessageRecived({String message, String title = "Alert", List<Widget> actions}) {
    // TODO: implement onAlertMessageRecived
  }

  @override
  void onAuthenticationExpiered() {
    // TODO: implement onAuthenticationExpiered
  }

  @override
  void onSnackbarMessageRecived({String message}) {
    // TODO: implement onSnackbarMessageRecived
  }

  @override
  void onToastMessageRecived({String message}) {
    // TODO: implement onToastMessageRecived
  }
  
}