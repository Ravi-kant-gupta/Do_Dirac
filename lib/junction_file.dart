import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import './exit_app.dart';
import 'purchaseApp/home_page.dart';
import 'sales/sale_home_page.dart';

class SelectViewPage extends StatefulWidget {
  @override
  State<SelectViewPage> createState() => _SelectViewPageState();
}

class _SelectViewPageState extends State<SelectViewPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => ExitAppAlert(context),
        child: Scaffold(
          backgroundColor: Color(0xffe6f7fd),
          // appBar: AppBar(
          //   title: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: <Widget>[
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             const Text(
          //               "",
          //               style: TextStyle(color: Colors.white),
          //             ),
          //           ],
          //         ),
          //       ]),
          //   backgroundColor: const Color(0xFF3498CC),
          // ),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Image(
                        image: AssetImage('assets/logo.png'),
                        height: 70,
                        width: 70,
                      ),
                      Text(
                        "DoDirac",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFF3498CC)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                "assets/purchase-icon-png-21.png",
                                scale: 17,
                                color: Colors.white,
                              ),
                              Text(
                                "Purchase Type",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SaleHomeScreen()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                              color: Color(0xFF3498CC),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                "assets/sales-icon.png",
                                scale: 17,
                                color: Colors.white,
                              ),
                              Text(
                                "Sale Order",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ]),
          ),
        ));
  }
}
