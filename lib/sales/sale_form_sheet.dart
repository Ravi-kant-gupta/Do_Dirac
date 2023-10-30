import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class SaleFormSheet extends StatefulWidget {
  @override
  State<SaleFormSheet> createState() => _SaleFormSheetPage();
}

class _SaleFormSheetPage extends State<SaleFormSheet> {
  String? approveSuccess;
  String? cancelReason = "";
  String? cancelSuccess;
  bool? showCarouselData = true;

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                "Reason for Cancellation",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF3498CC),
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              onChanged: (value) {
                cancelReason = value;
                setState(() {});
              },
              cursorColor: Color(0xFF3498CC),
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Color(0xFF3498CC)),
              onPressed: () async {
                if (cancelReason == "") {
                  print(cancelReason);
                  Flushbar(
                    message: "Please Enter Reason for Cancellation",
                    messageColor: Colors.white,
                    backgroundColor: Colors.black,
                    flushbarPosition: FlushbarPosition.TOP,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    borderRadius: BorderRadius.circular(5),
                    duration: const Duration(milliseconds: 3000),
                    icon: Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
                  ).show(context);
                } else {
                  print(cancelSuccess);
                  Navigator.pop(context);
                  showLoaderDialog(context);
                  // await cancelPOData();
                  if (cancelSuccess != null) {
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop("PO Cancelled");
                  }
                }
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: CircularProgressIndicator(color: Color(0xFF3498CC)),
          ),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  orderDatetime(date) {
    if (date == "") {
      return "NAN";
    } else {
      DateTime time = DateTime.parse(date);

      return "${time.day} ${DateFormat.MMM().format(time)} ${time.year}";
    }
  }

  scheduleDatetime(date) {
    if (date == "") {
      return "NAN";
    } else {
      DateTime time = DateTime.parse(date);

      return "${time.day} ${DateFormat.MMM().format(time)} ${time.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SO Details'),
            Row(children: [
              TextButton(
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.white, width: 1),
                  ),
                  onPressed: () async {
                    showLoaderDialog(context);
                    // await approvePOData();
                    if (approveSuccess != null) {
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop("Approve Success");
                    }
                  },
                  child: Text(
                    "Approve",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                child: TextButton(
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.white, width: 1),
                    ),
                    onPressed: () async {
                      await showAlertDialog(context);
                      print("Cancel");
                      // Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    )),
              )
            ])
          ],
        ),
        backgroundColor: Color(0xFF3498CC),
      ),
      body: Column(children: [
        // showCarouselData == true
        //     ? Container(
        //         decoration: BoxDecoration(
        //           color: Color.fromARGB(255, 214, 237, 245),
        //         ),
        //         child: CarouselSlider(
        //             options: CarouselOptions(
        //               height: 130,
        //               aspectRatio: 16 / 9,
        //               viewportFraction: 0.8,
        //               initialPage: 0,
        //               enableInfiniteScroll: true,
        //               reverse: false,
        //               autoPlay: true,
        //               autoPlayInterval: Duration(seconds: 3),
        //               autoPlayAnimationDuration: Duration(milliseconds: 1000),
        //               autoPlayCurve: Curves.fastOutSlowIn,
        //               enlargeCenterPage: true,
        //               enlargeFactor: 0.3,
        //               // onPageChanged: callbackFunction,
        //               scrollDirection: Axis.horizontal,
        //             ),
        //             items: <Widget>[
        //               Padding(
        //                 padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        //                 child: Column(
        //                   children: [
        //                     Padding(
        //                       padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        //                       child: Row(
        //                         mainAxisAlignment:
        //                             MainAxisAlignment.spaceAround,
        //                         children: [
        //                           Container(
        //                               decoration: BoxDecoration(
        //                                   color: Color(0xFF3498CC),
        //                                   borderRadius: BorderRadius.all(
        //                                       Radius.circular(5))),
        //                               child: Row(
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 children: [
        //                                   Icon(
        //                                     Icons.sell,
        //                                     color: Colors.white,
        //                                     size: 18,
        //                                   ),
        //                                   SizedBox(
        //                                     width: MediaQuery.of(context)
        //                                             .size
        //                                             .width *
        //                                         0.30,
        //                                     child: Column(
        //                                       crossAxisAlignment:
        //                                           CrossAxisAlignment.center,
        //                                       children: [
        //                                         Text(
        //                                           "Sales Order No.",
        //                                           style: TextStyle(
        //                                               fontWeight:
        //                                                   FontWeight.bold,
        //                                               fontSize: 13,
        //                                               color: Colors.white),
        //                                         ),
        //                                         Text(
        //                                           "aaaaaaaaaaaaaaa",
        //                                           textAlign: TextAlign.center,
        //                                           style: TextStyle(
        //                                               fontSize: 13,
        //                                               color: Colors.white),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                   ),
        //                                 ],
        //                               )),
        //                           Container(
        //                               decoration: BoxDecoration(
        //                                   color: Color(0xFF3498CC),
        //                                   borderRadius: BorderRadius.all(
        //                                       Radius.circular(5))),
        //                               child: Row(
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 children: [
        //                                   Icon(
        //                                     Icons.person,
        //                                     color: Colors.white,
        //                                     size: 18,
        //                                   ),
        //                                   SizedBox(
        //                                     width: MediaQuery.of(context)
        //                                             .size
        //                                             .width *
        //                                         0.30,
        //                                     child: Column(
        //                                       crossAxisAlignment:
        //                                           CrossAxisAlignment.center,
        //                                       children: [
        //                                         Text(
        //                                           "Customer Name",
        //                                           style: TextStyle(
        //                                               fontWeight:
        //                                                   FontWeight.bold,
        //                                               fontSize: 12,
        //                                               color: Colors.white),
        //                                         ),
        //                                         Text(
        //                                           "aaaaaaaaaaaaa",
        //                                           textAlign: TextAlign.center,
        //                                           style: TextStyle(
        //                                               fontSize: 13,
        //                                               color: Colors.white),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                   ),
        //                                 ],
        //                               )),
        //                         ],
        //                       ),
        //                     ),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                       children: [
        //                         Container(
        //                             decoration: BoxDecoration(
        //                                 color: Color(0xFF3498CC),
        //                                 borderRadius: BorderRadius.all(
        //                                     Radius.circular(5))),
        //                             child: Row(
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.start,
        //                               mainAxisAlignment:
        //                                   MainAxisAlignment.start,
        //                               children: [
        //                                 Icon(
        //                                   Icons.numbers_rounded,
        //                                   color: Colors.white,
        //                                   size: 18,
        //                                 ),
        //                                 SizedBox(
        //                                   width: MediaQuery.of(context)
        //                                           .size
        //                                           .width *
        //                                       0.30,
        //                                   child: Column(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.center,
        //                                     children: [
        //                                       Text(
        //                                         "Buyer Order No",
        //                                         style: TextStyle(
        //                                             fontWeight: FontWeight.bold,
        //                                             fontSize: 12,
        //                                             color: Colors.white),
        //                                       ),
        //                                       Text(
        //                                         "aaaaaaaaaaaa",
        //                                         textAlign: TextAlign.center,
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color: Colors.white),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ],
        //                             )),
        //                         Container(
        //                             decoration: BoxDecoration(
        //                                 color: Color(0xFF3498CC),
        //                                 borderRadius: BorderRadius.all(
        //                                     Radius.circular(5))),
        //                             child: Row(
        //                               children: [
        //                                 Icon(
        //                                   Icons.calendar_today_sharp,
        //                                   color: Colors.white,
        //                                   size: 18,
        //                                 ),
        //                                 SizedBox(
        //                                   width: MediaQuery.of(context)
        //                                           .size
        //                                           .width *
        //                                       0.30,
        //                                   child: Column(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.center,
        //                                     children: [
        //                                       Text(
        //                                         "Order Date",
        //                                         style: TextStyle(
        //                                             fontWeight: FontWeight.bold,
        //                                             fontSize: 12,
        //                                             color: Colors.white),
        //                                       ),
        //                                       Text(
        //                                         "aaaaaaaaaaaa",
        //                                         textAlign: TextAlign.center,
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color: Colors.white),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ],
        //                             )),
        //                       ],
        //                     ),

        //                     // Padding(
        //                     //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //                     //   child: Row(
        //                     //     crossAxisAlignment: CrossAxisAlignment.start,
        //                     //     children: [
        //                     //       Text(
        //                     //         "Customer Name :",
        //                     //         style: TextStyle(
        //                     //             fontWeight: FontWeight.bold,
        //                     //             fontSize: 13),
        //                     //       ),
        //                     //       Expanded(
        //                     //         child: SizedBox(
        //                     //           child: Text(
        //                     //             " ",
        //                     //             style: TextStyle(fontSize: 13),
        //                     //           ),
        //                     //         ),
        //                     //       )
        //                     //     ],
        //                     //   ),
        //                     // ),
        //                     // Padding(
        //                     //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //                     //   child: Row(
        //                     //     crossAxisAlignment: CrossAxisAlignment.start,
        //                     //     children: [
        //                     //       Text(
        //                     //         "Buyer Order No   :",
        //                     //         style: TextStyle(
        //                     //             fontWeight: FontWeight.bold,
        //                     //             fontSize: 13),
        //                     //       ),
        //                     //       Expanded(
        //                     //         child: SizedBox(
        //                     //           child: Text(
        //                     //             " ",
        //                     //             style: TextStyle(fontSize: 13),
        //                     //           ),
        //                     //         ),
        //                     //       )
        //                     //     ],
        //                     //   ),
        //                     // ),
        //                     // Padding(
        //                     //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //                     //   child: Row(
        //                     //     crossAxisAlignment: CrossAxisAlignment.start,
        //                     //     children: [
        //                     //       Text(
        //                     //         "Order Date           :",
        //                     //         style: TextStyle(
        //                     //             fontWeight: FontWeight.bold,
        //                     //             fontSize: 13),
        //                     //       ),
        //                     //       Expanded(
        //                     //         child: SizedBox(
        //                     //           child: Text(
        //                     //             " ",
        //                     //             style: TextStyle(fontSize: 13),
        //                     //           ),
        //                     //         ),
        //                     //       )
        //                     //     ],
        //                     //   ),
        //                     // ),
        //                     // Row(
        //                     //   mainAxisAlignment: MainAxisAlignment.end,
        //                     //   children: [
        //                     //     GestureDetector(
        //                     //         onTap: () {
        //                     //           setState(() {
        //                     //             showCarouselData = false;
        //                     //           });
        //                     //           print(showCarouselData);
        //                     //         },
        //                     //         child: Text(
        //                     //           "View All",
        //                     //           style: TextStyle(color: Colors.blue),
        //                     //         )),
        //                     //   ],
        //                     // )
        //                   ],
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        //                 child: Column(
        //                   children: [
        //                     Padding(
        //                       padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        //                       child: Row(
        //                         mainAxisAlignment:
        //                             MainAxisAlignment.spaceAround,
        //                         children: [
        //                           Container(
        //                               decoration: BoxDecoration(
        //                                   color: Color(0xFF3498CC),
        //                                   borderRadius: BorderRadius.all(
        //                                       Radius.circular(5))),
        //                               child: Row(
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.start,
        //                                 children: [
        //                                   Icon(
        //                                     FontAwesomeIcons.receipt,
        //                                     color: Colors.white,
        //                                     size: 17,
        //                                   ),
        //                                   SizedBox(
        //                                     width: MediaQuery.of(context)
        //                                             .size
        //                                             .width *
        //                                         0.30,
        //                                     child: Column(
        //                                       crossAxisAlignment:
        //                                           CrossAxisAlignment.center,
        //                                       children: [
        //                                         Text(
        //                                           "Ex-change Rate",
        //                                           style: TextStyle(
        //                                               fontWeight:
        //                                                   FontWeight.bold,
        //                                               fontSize: 13,
        //                                               color: Colors.white),
        //                                         ),
        //                                         Text(
        //                                           "aaaaaaaaaaaaaa",
        //                                           textAlign: TextAlign.center,
        //                                           style: TextStyle(
        //                                               fontSize: 13,
        //                                               color: Colors.white),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                   ),
        //                                 ],
        //                               )),
        //                           Container(
        //                               decoration: BoxDecoration(
        //                                   color: Color(0xFF3498CC),
        //                                   borderRadius: BorderRadius.all(
        //                                       Radius.circular(5))),
        //                               child: Row(
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.start,
        //                                 children: [
        //                                   Icon(
        //                                     FontAwesomeIcons.industry,
        //                                     color: Colors.white,
        //                                     size: 17,
        //                                   ),
        //                                   SizedBox(
        //                                     width: MediaQuery.of(context)
        //                                             .size
        //                                             .width *
        //                                         0.30,
        //                                     child: Column(
        //                                       crossAxisAlignment:
        //                                           CrossAxisAlignment.center,
        //                                       children: [
        //                                         Text(
        //                                           "Ex-Factory Date",
        //                                           style: TextStyle(
        //                                               fontWeight:
        //                                                   FontWeight.bold,
        //                                               fontSize: 12,
        //                                               color: Colors.white),
        //                                         ),
        //                                         Text(
        //                                           "aaaaaaaaaa",
        //                                           textAlign: TextAlign.center,
        //                                           style: TextStyle(
        //                                               fontSize: 13,
        //                                               color: Colors.white),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                   ),
        //                                 ],
        //                               )),
        //                         ],
        //                       ),
        //                     ),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                       children: [
        //                         Container(
        //                             decoration: BoxDecoration(
        //                                 color: Color(0xFF3498CC),
        //                                 borderRadius: BorderRadius.all(
        //                                     Radius.circular(5))),
        //                             child: Row(
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.start,
        //                               mainAxisAlignment:
        //                                   MainAxisAlignment.start,
        //                               children: [
        //                                 Icon(
        //                                   FontAwesomeIcons.calendar,
        //                                   color: Colors.white,
        //                                   size: 17,
        //                                 ),
        //                                 SizedBox(
        //                                   width: MediaQuery.of(context)
        //                                           .size
        //                                           .width *
        //                                       0.30,
        //                                   child: Column(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.center,
        //                                     children: [
        //                                       Text(
        //                                         "Ship W.Start date",
        //                                         style: TextStyle(
        //                                             fontWeight: FontWeight.bold,
        //                                             fontSize: 12,
        //                                             color: Colors.white),
        //                                       ),
        //                                       Text(
        //                                         "aaaaaaaaaa",
        //                                         textAlign: TextAlign.center,
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color: Colors.white),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ],
        //                             )),
        //                         Container(
        //                             decoration: BoxDecoration(
        //                                 color: Color(0xFF3498CC),
        //                                 borderRadius: BorderRadius.all(
        //                                     Radius.circular(5))),
        //                             child: Row(
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.start,
        //                               mainAxisAlignment:
        //                                   MainAxisAlignment.start,
        //                               children: [
        //                                 Icon(
        //                                   FontAwesomeIcons.calendar,
        //                                   color: Colors.white,
        //                                   size: 17,
        //                                 ),
        //                                 SizedBox(
        //                                   width: MediaQuery.of(context)
        //                                           .size
        //                                           .width *
        //                                       0.30,
        //                                   child: Column(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.center,
        //                                     children: [
        //                                       Text(
        //                                         "Ship W.End date",
        //                                         style: TextStyle(
        //                                             fontWeight: FontWeight.bold,
        //                                             fontSize: 12,
        //                                             color: Colors.white),
        //                                       ),
        //                                       Text(
        //                                         "aaaaaaaaaaaaa",
        //                                         textAlign: TextAlign.center,
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color: Colors.white),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ],
        //                             )),
        //                       ],
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        //                 child: Column(
        //                   children: [
        //                     Padding(
        //                       padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        //                       child: Row(
        //                         mainAxisAlignment:
        //                             MainAxisAlignment.spaceAround,
        //                         children: [
        //                           Container(
        //                               decoration: BoxDecoration(
        //                                   color: Color(0xFF3498CC),
        //                                   borderRadius: BorderRadius.all(
        //                                       Radius.circular(5))),
        //                               child: Row(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.start,
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 children: [
        //                                   Icon(
        //                                     FontAwesomeIcons.wallet,
        //                                     color: Colors.white,
        //                                     size: 17,
        //                                   ),
        //                                   SizedBox(
        //                                     width: MediaQuery.of(context)
        //                                             .size
        //                                             .width *
        //                                         0.30,
        //                                     child: Column(
        //                                       crossAxisAlignment:
        //                                           CrossAxisAlignment.center,
        //                                       children: [
        //                                         Text(
        //                                           "Currency",
        //                                           style: TextStyle(
        //                                               fontWeight:
        //                                                   FontWeight.bold,
        //                                               fontSize: 13,
        //                                               color: Colors.white),
        //                                         ),
        //                                         Text(
        //                                           "aaaaaaaaaa",
        //                                           textAlign: TextAlign.center,
        //                                           style: TextStyle(
        //                                               fontSize: 13,
        //                                               color: Colors.white),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                   ),
        //                                 ],
        //                               )),
        //                           Container(
        //                               decoration: BoxDecoration(
        //                                   color: Color(0xFF3498CC),
        //                                   borderRadius: BorderRadius.all(
        //                                       Radius.circular(5))),
        //                               child: Row(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.start,
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 children: [
        //                                   Icon(
        //                                     FontAwesomeIcons.circlePlus,
        //                                     color: Colors.white,
        //                                     size: 17,
        //                                   ),
        //                                   SizedBox(
        //                                     width: MediaQuery.of(context)
        //                                             .size
        //                                             .width *
        //                                         0.30,
        //                                     child: Column(
        //                                       crossAxisAlignment:
        //                                           CrossAxisAlignment.center,
        //                                       children: [
        //                                         Text(
        //                                           "Total Qty.",
        //                                           style: TextStyle(
        //                                               fontWeight:
        //                                                   FontWeight.bold,
        //                                               fontSize: 12,
        //                                               color: Colors.white),
        //                                         ),
        //                                         Text(
        //                                           "aaaaaaaaaaaa",
        //                                           textAlign: TextAlign.center,
        //                                           style: TextStyle(
        //                                               fontSize: 13,
        //                                               color: Colors.white),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                   ),
        //                                 ],
        //                               )),
        //                         ],
        //                       ),
        //                     ),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                       children: [
        //                         Container(
        //                             decoration: BoxDecoration(
        //                                 color: Color(0xFF3498CC),
        //                                 borderRadius: BorderRadius.all(
        //                                     Radius.circular(5))),
        //                             child: Row(
        //                               mainAxisAlignment:
        //                                   MainAxisAlignment.start,
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.start,
        //                               children: [
        //                                 Icon(
        //                                   FontAwesomeIcons.circlePlus,
        //                                   color: Colors.white,
        //                                   size: 17,
        //                                 ),
        //                                 SizedBox(
        //                                   width: MediaQuery.of(context)
        //                                           .size
        //                                           .width *
        //                                       0.30,
        //                                   child: Column(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.center,
        //                                     children: [
        //                                       Text(
        //                                         "Total SKU",
        //                                         style: TextStyle(
        //                                             fontWeight: FontWeight.bold,
        //                                             fontSize: 12,
        //                                             color: Colors.white),
        //                                       ),
        //                                       Text(
        //                                         "aaaaaaaaaa",
        //                                         textAlign: TextAlign.center,
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color: Colors.white),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ],
        //                             )),
        //                         Container(
        //                             decoration: BoxDecoration(
        //                                 color: Color(0xFF3498CC),
        //                                 borderRadius: BorderRadius.all(
        //                                     Radius.circular(5))),
        //                             child: Row(
        //                               mainAxisAlignment:
        //                                   MainAxisAlignment.start,
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.start,
        //                               children: [
        //                                 Icon(
        //                                   FontAwesomeIcons.circlePlus,
        //                                   color: Colors.white,
        //                                   size: 17,
        //                                 ),
        //                                 SizedBox(
        //                                   width: MediaQuery.of(context)
        //                                           .size
        //                                           .width *
        //                                       0.30,
        //                                   child: Column(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.center,
        //                                     children: [
        //                                       Text(
        //                                         "Total Amount",
        //                                         style: TextStyle(
        //                                             fontWeight: FontWeight.bold,
        //                                             fontSize: 12,
        //                                             color: Colors.white),
        //                                       ),
        //                                       Text(
        //                                         "aaaaaaaaaa",
        //                                         textAlign: TextAlign.center,
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color: Colors.white),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ],
        //                             )),
        //                       ],
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        //                 child: Column(
        //                   children: [
        //                     Padding(
        //                       padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        //                       child: Row(
        //                         mainAxisAlignment:
        //                             MainAxisAlignment.spaceAround,
        //                         children: [
        //                           Container(
        //                               decoration: BoxDecoration(
        //                                   color: Color(0xFF3498CC),
        //                                   borderRadius: BorderRadius.all(
        //                                       Radius.circular(5))),
        //                               child: Row(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.start,
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 children: [
        //                                   Icon(
        //                                     FontAwesomeIcons.wallet,
        //                                     color: Colors.white,
        //                                     size: 17,
        //                                   ),
        //                                   SizedBox(
        //                                     width: MediaQuery.of(context)
        //                                             .size
        //                                             .width *
        //                                         0.30,
        //                                     child: Column(
        //                                       crossAxisAlignment:
        //                                           CrossAxisAlignment.center,
        //                                       children: [
        //                                         Text(
        //                                           "Total INR",
        //                                           style: TextStyle(
        //                                               fontWeight:
        //                                                   FontWeight.bold,
        //                                               fontSize: 13,
        //                                               color: Colors.white),
        //                                         ),
        //                                         Text(
        //                                           "aaaaaaaaa",
        //                                           textAlign: TextAlign.center,
        //                                           style: TextStyle(
        //                                               fontSize: 13,
        //                                               color: Colors.white),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                   ),
        //                                 ],
        //                               )),
        //                           Container(
        //                               decoration: BoxDecoration(
        //                                   color: Color(0xFF3498CC),
        //                                   borderRadius: BorderRadius.all(
        //                                       Radius.circular(5))),
        //                               child: Row(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.start,
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 children: [
        //                                   Icon(
        //                                     FontAwesomeIcons.clipboardList,
        //                                     color: Colors.white,
        //                                     size: 17,
        //                                   ),
        //                                   SizedBox(
        //                                     width: MediaQuery.of(context)
        //                                             .size
        //                                             .width *
        //                                         0.30,
        //                                     child: Column(
        //                                       crossAxisAlignment:
        //                                           CrossAxisAlignment.center,
        //                                       children: [
        //                                         Text(
        //                                           "Type",
        //                                           style: TextStyle(
        //                                               fontWeight:
        //                                                   FontWeight.bold,
        //                                               fontSize: 12,
        //                                               color: Colors.white),
        //                                         ),
        //                                         Text(
        //                                           "aaaaaaaaaa",
        //                                           textAlign: TextAlign.center,
        //                                           style: TextStyle(
        //                                               fontSize: 13,
        //                                               color: Colors.white),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                   ),
        //                                 ],
        //                               )),
        //                         ],
        //                       ),
        //                     ),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                       children: [
        //                         Container(
        //                             decoration: BoxDecoration(
        //                                 color: Color(0xFF3498CC),
        //                                 borderRadius: BorderRadius.all(
        //                                     Radius.circular(5))),
        //                             child: Row(
        //                               mainAxisAlignment:
        //                                   MainAxisAlignment.start,
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.start,
        //                               children: [
        //                                 Icon(
        //                                   FontAwesomeIcons.person,
        //                                   color: Colors.white,
        //                                   size: 17,
        //                                 ),
        //                                 SizedBox(
        //                                   width: MediaQuery.of(context)
        //                                           .size
        //                                           .width *
        //                                       0.30,
        //                                   child: Column(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.center,
        //                                     children: [
        //                                       Text(
        //                                         "Sales Person",
        //                                         style: TextStyle(
        //                                             fontWeight: FontWeight.bold,
        //                                             fontSize: 12,
        //                                             color: Colors.white),
        //                                       ),
        //                                       Text(
        //                                         "aaaaaaaaaaa",
        //                                         textAlign: TextAlign.center,
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color: Colors.white),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ],
        //                             )),
        //                         Container(
        //                             decoration: BoxDecoration(
        //                                 color: Color(0xFF3498CC),
        //                                 borderRadius: BorderRadius.all(
        //                                     Radius.circular(5))),
        //                             child: Row(
        //                               mainAxisAlignment:
        //                                   MainAxisAlignment.start,
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.start,
        //                               children: [
        //                                 Icon(
        //                                   FontAwesomeIcons.peopleGroup,
        //                                   color: Colors.white,
        //                                   size: 17,
        //                                 ),
        //                                 SizedBox(
        //                                   width: MediaQuery.of(context)
        //                                           .size
        //                                           .width *
        //                                       0.30,
        //                                   child: Column(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.center,
        //                                     children: [
        //                                       Text(
        //                                         "Sales Team",
        //                                         style: TextStyle(
        //                                             fontWeight: FontWeight.bold,
        //                                             fontSize: 12,
        //                                             color: Colors.white),
        //                                       ),
        //                                       Text(
        //                                         "aaaaaaaaaa",
        //                                         textAlign: TextAlign.center,
        //                                         style: TextStyle(
        //                                             fontSize: 13,
        //                                             color: Colors.white),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ],
        //                             )),
        //                       ],
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        //                 child: Column(
        //                   children: [
        //                     Padding(
        //                       padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        //                       child: Row(
        //                         mainAxisAlignment:
        //                             MainAxisAlignment.spaceAround,
        //                         children: [
        //                           Container(
        //                               decoration: BoxDecoration(
        //                                   color: Color(0xFF3498CC),
        //                                   borderRadius: BorderRadius.all(
        //                                       Radius.circular(5))),
        //                               child: Row(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.start,
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 children: [
        //                                   Icon(Icons.warehouse_outlined,
        //                                       color: Colors.white, size: 18),
        //                                   SizedBox(
        //                                     width: MediaQuery.of(context)
        //                                             .size
        //                                             .width *
        //                                         0.30,
        //                                     child: Padding(
        //                                       padding:
        //                                           const EdgeInsets.fromLTRB(
        //                                               3, 0, 0, 0),
        //                                       child: Column(
        //                                         crossAxisAlignment:
        //                                             CrossAxisAlignment.start,
        //                                         children: [
        //                                           Text(
        //                                             "Warehouse",
        //                                             style: TextStyle(
        //                                                 fontWeight:
        //                                                     FontWeight.bold,
        //                                                 fontSize: 13,
        //                                                 color: Colors.white),
        //                                           ),
        //                                           Text(
        //                                             "aaaaaaaaaaaaaaaaaaaaaaaa",
        //                                             // textAlign: TextAlign.center,
        //                                             style: TextStyle(
        //                                                 fontSize: 13,
        //                                                 color: Colors.white),
        //                                           ),
        //                                         ],
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 ],
        //                               )),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               // Padding(
        //               //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        //               //   child: Column(
        //               //     children: [
        //               //       Padding(
        //               //         padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        //               //         child: Row(
        //               //           crossAxisAlignment: CrossAxisAlignment.start,
        //               //           children: [
        //               //             Text(
        //               //               "Ex-change Rate    :",
        //               //               style: TextStyle(
        //               //                   fontWeight: FontWeight.bold,
        //               //                   fontSize: 13),
        //               //             ),
        //               //             Expanded(
        //               //               child: SizedBox(
        //               //                 child: Text(
        //               //                   " ",
        //               //                   style: TextStyle(fontSize: 13),
        //               //                 ),
        //               //               ),
        //               //             )
        //               //           ],
        //               //         ),
        //               //       ),
        //               //       Padding(
        //               //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //               //         child: Row(
        //               //           crossAxisAlignment: CrossAxisAlignment.start,
        //               //           children: [
        //               //             Text(
        //               //               "Ex-Factory Date    :",
        //               //               style: TextStyle(
        //               //                   fontWeight: FontWeight.bold,
        //               //                   fontSize: 13),
        //               //             ),
        //               //             Expanded(
        //               //               child: SizedBox(
        //               //                 child: Text(
        //               //                   " ",
        //               //                   style: TextStyle(fontSize: 13),
        //               //                 ),
        //               //               ),
        //               //             )
        //               //           ],
        //               //         ),
        //               //       ),
        //               //       Padding(
        //               //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //               //         child: Row(
        //               //           crossAxisAlignment: CrossAxisAlignment.start,
        //               //           children: [
        //               //             Text(
        //               //               "Ship W.Start date :",
        //               //               style: TextStyle(
        //               //                   fontWeight: FontWeight.bold,
        //               //                   fontSize: 13),
        //               //             ),
        //               //             Expanded(
        //               //               child: SizedBox(
        //               //                 child: Text(
        //               //                   " ",
        //               //                   style: TextStyle(fontSize: 13),
        //               //                 ),
        //               //               ),
        //               //             )
        //               //           ],
        //               //         ),
        //               //       ),
        //               //       Padding(
        //               //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //               //         child: Row(
        //               //           crossAxisAlignment: CrossAxisAlignment.start,
        //               //           children: [
        //               //             Text(
        //               //               "Ship W.End date   :",
        //               //               style: TextStyle(
        //               //                   fontWeight: FontWeight.bold,
        //               //                   fontSize: 13),
        //               //             ),
        //               //             Expanded(
        //               //               child: SizedBox(
        //               //                 child: Text(
        //               //                   " ",
        //               //                   style: TextStyle(fontSize: 13),
        //               //                 ),
        //               //               ),
        //               //             )
        //               //           ],
        //               //         ),
        //               //       ),
        //               //       // Row(
        //               //       //   mainAxisAlignment: MainAxisAlignment.end,
        //               //       //   children: [
        //               //       //     GestureDetector(
        //               //       //         onTap: () {
        //               //       //           setState(() {
        //               //       //             showCarouselData = false;
        //               //       //           });
        //               //       //         },
        //               //       //         child: Text(
        //               //       //           "View All",
        //               //       //           style: TextStyle(color: Colors.blue),
        //               //       //         )),
        //               //       //   ],
        //               //       // )
        //               //     ],
        //               //   ),
        //               // ),
        //               // Padding(
        //               //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        //               //   child: Column(
        //               //     children: [
        //               //       Padding(
        //               //         padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        //               //         child: Row(
        //               //           crossAxisAlignment: CrossAxisAlignment.start,
        //               //           children: [
        //               //             Text(
        //               //               "Currency        :",
        //               //               style: TextStyle(
        //               //                   fontWeight: FontWeight.bold,
        //               //                   fontSize: 13),
        //               //             ),
        //               //             Expanded(
        //               //               child: SizedBox(
        //               //                 child: Text(
        //               //                   " ",
        //               //                   style: TextStyle(fontSize: 13),
        //               //                 ),
        //               //               ),
        //               //             )
        //               //           ],
        //               //         ),
        //               //       ),
        //               //       Padding(
        //               //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //               //         child: Row(
        //               //           crossAxisAlignment: CrossAxisAlignment.start,
        //               //           children: [
        //               //             Text(
        //               //               "Total Qty.        :",
        //               //               style: TextStyle(
        //               //                   fontWeight: FontWeight.bold,
        //               //                   fontSize: 13),
        //               //             ),
        //               //             Expanded(
        //               //               child: SizedBox(
        //               //                 child: Text(
        //               //                   " ",
        //               //                   style: TextStyle(fontSize: 13),
        //               //                 ),
        //               //               ),
        //               //             )
        //               //           ],
        //               //         ),
        //               //       ),
        //               //       Padding(
        //               //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //               //         child: Row(
        //               //           crossAxisAlignment: CrossAxisAlignment.start,
        //               //           children: [
        //               //             Text(
        //               //               "Total SKU       :",
        //               //               style: TextStyle(
        //               //                   fontWeight: FontWeight.bold,
        //               //                   fontSize: 13),
        //               //             ),
        //               //             Expanded(
        //               //               child: SizedBox(
        //               //                 child: Text(
        //               //                   " ",
        //               //                   style: TextStyle(fontSize: 13),
        //               //                 ),
        //               //               ),
        //               //             )
        //               //           ],
        //               //         ),
        //               //       ),
        //               //       Padding(
        //               //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //               //         child: Row(
        //               //           crossAxisAlignment: CrossAxisAlignment.start,
        //               //           children: [
        //               //             Text(
        //               //               "Total Amount :",
        //               //               style: TextStyle(
        //               //                   fontWeight: FontWeight.bold,
        //               //                   fontSize: 13),
        //               //             ),
        //               //             Expanded(
        //               //               child: SizedBox(
        //               //                 child: Text(
        //               //                   " ",
        //               //                   style: TextStyle(fontSize: 13),
        //               //                 ),
        //               //               ),
        //               //             )
        //               //           ],
        //               //         ),
        //               //       ),
        //               //       // Row(
        //               //       //   mainAxisAlignment: MainAxisAlignment.end,
        //               //       //   children: [
        //               //       //     GestureDetector(
        //               //       //         onTap: () {
        //               //       //           setState(() {
        //               //       //             showCarouselData = false;
        //               //       //           });
        //               //       //         },
        //               //       //         child: Text(
        //               //       //           "View All",
        //               //       //           style: TextStyle(color: Colors.blue),
        //               //       //         )),
        //               //       //   ],
        //               //       // )
        //               //     ],
        //               //   ),
        //               // ),
        //               // Padding(
        //               //   padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        //               //   child: Column(
        //               //     children: [
        //               //       Padding(
        //               //         padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        //               //         child: Row(
        //               //           crossAxisAlignment: CrossAxisAlignment.start,
        //               //           children: [
        //               //             Text(
        //               //               "Total INR        :",
        //               //               style: TextStyle(
        //               //                   fontWeight: FontWeight.bold,
        //               //                   fontSize: 13),
        //               //             ),
        //               //             Expanded(
        //               //               child: SizedBox(
        //               //                 child: Text(
        //               //                   "",
        //               //                   style: TextStyle(fontSize: 13),
        //               //                 ),
        //               //               ),
        //               //             )
        //               //           ],
        //               //         ),
        //               //       ),
        //               //       Padding(
        //               //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //               //         child: Row(
        //               //           crossAxisAlignment: CrossAxisAlignment.start,
        //               //           children: [
        //               //             Text(
        //               //               "Type                :",
        //               //               style: TextStyle(
        //               //                   fontWeight: FontWeight.bold,
        //               //                   fontSize: 13),
        //               //             ),
        //               //             Expanded(
        //               //               child: SizedBox(
        //               //                 child: Text(
        //               //                   " ",
        //               //                   style: TextStyle(fontSize: 13),
        //               //                 ),
        //               //               ),
        //               //             )
        //               //           ],
        //               //         ),
        //               //       ),
        //               //       Padding(
        //               //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //               //         child: Row(
        //               //           crossAxisAlignment: CrossAxisAlignment.start,
        //               //           children: [
        //               //             Text(
        //               //               "Sales Person :",
        //               //               style: TextStyle(
        //               //                   fontWeight: FontWeight.bold,
        //               //                   fontSize: 13),
        //               //             ),
        //               //             Expanded(
        //               //               child: SizedBox(
        //               //                 child: Text(
        //               //                   " ",
        //               //                   style: TextStyle(fontSize: 13),
        //               //                 ),
        //               //               ),
        //               //             )
        //               //           ],
        //               //         ),
        //               //       ),
        //               //       Padding(
        //               //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //               //         child: Row(
        //               //           crossAxisAlignment: CrossAxisAlignment.start,
        //               //           children: [
        //               //             Text(
        //               //               "Sales Team    :",
        //               //               style: TextStyle(
        //               //                   fontWeight: FontWeight.bold,
        //               //                   fontSize: 13),
        //               //             ),
        //               //             Expanded(
        //               //               child: SizedBox(
        //               //                 child: Text(
        //               //                   " ",
        //               //                   style: TextStyle(fontSize: 13),
        //               //                 ),
        //               //               ),
        //               //             )
        //               //           ],
        //               //         ),
        //               //       ),
        //               //       Padding(
        //               //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        //               //         child: Row(
        //               //           crossAxisAlignment: CrossAxisAlignment.start,
        //               //           children: [
        //               //             Text(
        //               //               "Warehouse     :",
        //               //               style: TextStyle(
        //               //                   fontWeight: FontWeight.bold,
        //               //                   fontSize: 13),
        //               //             ),
        //               //             Expanded(
        //               //               child: SizedBox(
        //               //                 child: Text(
        //               //                   " ",
        //               //                   style: TextStyle(fontSize: 13),
        //               //                 ),
        //               //               ),
        //               //             )
        //               //           ],
        //               //         ),
        //               //       ),
        //               //       // Row(
        //               //       //   mainAxisAlignment: MainAxisAlignment.end,
        //               //       //   children: [
        //               //       //     GestureDetector(
        //               //       //         onTap: () {
        //               //       //           setState(() {
        //               //       //             showCarouselData = false;
        //               //       //           });
        //               //       //         },
        //               //       //         child: Text(
        //               //       //           "View All",
        //               //       //           style: TextStyle(color: Colors.blue),
        //               //       //         )),
        //               //       //   ],
        //               //       // )
        //               //     ],
        //               //   ),
        //               // ),
        //             ]),
        //       )
        //     :
        Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              //   child:
              //    Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       GestureDetector(
              //           onTap: () {
              //             setState(() {
              //               showCarouselData = true;
              //             });
              //             print(showCarouselData);
              //           },
              //           child: SizedBox(
              //             height: 20,
              //             child: Text(
              //               "Minimize",
              //               style: TextStyle(color: Colors.blue),
              //             ),
              //           )),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sales Order No.",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          "   :",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Customer Name",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          "  :",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Buyer Order No",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          "   :",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Date",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          "            :",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ex-change Rate",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          "   :",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ex-Factory Date",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          "   :",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ship W.Start date",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          ":",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ship W.End date",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          "  :",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Currency",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          "               :",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Quantity",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          "      :",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total SKU",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          "              :",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Amount",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          "       :",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total INR",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          "               :",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Type",
              //         style:
              //             TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              //       ),
              //       Expanded(
              //         child: SizedBox(
              //           child: Text(
              //             "                      :",
              //             style: TextStyle(fontSize: 13),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Sales Person",
              //         style:
              //             TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              //       ),
              //       Expanded(
              //         child: SizedBox(
              //           child: Text(
              //             "       :",
              //             style: TextStyle(fontSize: 13),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Sales Team",
              //         style:
              //             TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              //       ),
              //       Expanded(
              //         child: SizedBox(
              //           child: Text(
              //             "          :",
              //             style: TextStyle(fontSize: 13),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Warehouse",
              //         style:
              //             TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              //       ),
              //       Expanded(
              //         child: SizedBox(
              //           child: Text(
              //             "          :",
              //             style: TextStyle(fontSize: 13),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // // Row(
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Sales Order No.",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Customer Name.",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Buyer Order No.",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Order Date",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Ex-change Rate",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Ex-Factory Date",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Ship W. Start Date",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Ship W. End Date",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Currency",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Total Qty.",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Total SKU.",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Total Amount",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Total INR",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Type",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Sales Preson",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Sales Team ",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Warehouse",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 8, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 ":SO/05",
              //                 style: TextStyle(
              //                   fontSize: 15,
              //                 ),
              //               )
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 ": ",
              //                 style: TextStyle(fontSize: 14),
              //               )
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 ":",
              //                 style: TextStyle(fontSize: 15),
              //               )
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 ":",
              //                 style: TextStyle(fontSize: 15),
              //               )
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(": ", style: TextStyle(fontSize: 15)),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(":", style: TextStyle(fontSize: 15)),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(": ", style: TextStyle(fontSize: 14)),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 ": ",
              //                 style: TextStyle(fontSize: 14),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(
              //                 ": ",
              //                 style: TextStyle(fontSize: 14),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(": ", style: TextStyle(fontSize: 15))
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(": ", style: TextStyle(fontSize: 15))
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(": ", style: TextStyle(fontSize: 15))
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(": ", style: TextStyle(fontSize: 15))
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(": ", style: TextStyle(fontSize: 15))
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(": ", style: TextStyle(fontSize: 15))
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(": ", style: TextStyle(fontSize: 15))
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              //           child: Row(
              //             children: [
              //               Text(": ", style: TextStyle(fontSize: 15))
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        // Align(
        //     child: Container(
        //   color: Colors.white,
        //   width: MediaQuery.of(context).size.width * 1,
        //   // decoration:
        //   //     BoxDecoration(color: Color.fromARGB(255, 198, 230, 242)),
        //   child: GestureDetector(
        //       onTap: () {
        //         if (showCarouselData == true) {
        //           setState(() {
        //             showCarouselData = false;
        //           });
        //         } else {
        //           setState(() {
        //             showCarouselData = true;
        //           });
        //         }
        //       },
        //       child: showCarouselData == true
        //           ? Container(
        //               color: Color.fromARGB(255, 214, 237, 245),
        //               child: Padding(
        //                 padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
        //                 child: Text(
        //                   "View All",
        //                   textAlign: TextAlign.end,
        //                   style: TextStyle(
        //                       fontSize: 15,
        //                       color: Colors.blue,
        //                       fontWeight: FontWeight.bold),
        //                 ),
        //               ),
        //             )
        //           : Padding(
        //               padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
        //               child: Text(
        //                 "Show Less",
        //                 textAlign: TextAlign.end,
        //                 style: TextStyle(
        //                     fontSize: 15,
        //                     color: Colors.blue,
        //                     fontWeight: FontWeight.bold),
        //               ),
        //             )),
        // )),

        Expanded(
          child: SingleChildScrollView(
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromARGB(255, 135, 211, 236),
                              width: 1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        tileColor: Color(0xffe6f7fd),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Product Name: ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Wrap(children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        " ",
                                        style: TextStyle(fontSize: 13),
                                        textAlign: TextAlign.start,
                                        maxLines: 3,
                                      ),
                                    ),
                                  )
                                  // ])
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // widget
                                  //             .completeData
                                  //             .purchaseOrderLineList?[index]
                                  //             .image ==
                                  //         " "
                                  //     ? Image(
                                  //         image:
                                  //             AssetImage("assets/no-image.png"),
                                  //         fit: BoxFit.fill,
                                  //         width: 120,
                                  //         alignment: Alignment.center,
                                  //       )
                                  //     : Image.network(
                                  //         "${widget.completeData.purchaseOrderLineList?[index].image}",
                                  //         fit: BoxFit.fill,
                                  //         alignment: Alignment.center,
                                  //       ),
                                  Image(
                                    image: AssetImage("assets/no-image.png"),
                                    fit: BoxFit.fill,
                                    width: 120,
                                    alignment: Alignment.center,
                                  ),
                                  // : CachedNetworkImage(
                                  //     imageUrl:
                                  //         "${widget.completeData.purchaseOrderLineList?[index].image}",
                                  //     placeholder: (context, url) =>
                                  //         CircularProgressIndicator(),
                                  //     errorWidget: (context, url, error) {
                                  //       return Image(
                                  //         image: AssetImage(
                                  //             "assets/no-image.png"),
                                  //         fit: BoxFit.fill,
                                  //         width: 120,
                                  //         alignment: Alignment.center,
                                  //       );
                                  //     }),

                                  Expanded(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "B.P.Code                    :",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    child: Text(
                                                      " ",
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Virtual SO                  :",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    child: Text(
                                                      " ",
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Virtual Balance Qty. :",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                ),
                                                Text(
                                                  " 0.00",
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                )
                                              ],
                                            ),
                                            // : Row(
                                            //     crossAxisAlignment:
                                            //         CrossAxisAlignment
                                            //             .start,
                                            //     children: [
                                            //       Text(
                                            //         "S.Total :",
                                            //         style: TextStyle(
                                            //             fontWeight:
                                            //                 FontWeight.bold,
                                            //             fontSize: 13),
                                            //       ),
                                            //       Expanded(
                                            //         child: SizedBox(
                                            //           child: Text(
                                            //             " ${widget.completeData.purchaseOrderLineList?[index].subtotal?.toStringAsFixed(2)}",
                                            //             style: TextStyle(
                                            //                 fontSize: 13),
                                            //           ),
                                            //         ),
                                            //       )
                                            //     ],
                                            //   ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Unit Price                   :",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    child: Text(
                                                      " ",
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Unit CBM                    :",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    child: Text(
                                                      " ",
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Total CBM                  :",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                ),
                                                Expanded(
                                                    child: SizedBox(
                                                  child: Text(
                                                    " ",
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  ),
                                                ))
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Sub Total                    :",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                ),
                                                Expanded(
                                                    child: SizedBox(
                                                  child: Text(
                                                    " ",
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  ),
                                                ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Remarks: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.black),
                                  ),
                                  Expanded(
                                      child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                  ))
                                ],
                              ),
                            ]),
                      ),
                    );
                  })),
        ),
        Container(
          color: Colors.white,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Type",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: Text(
                        "                :",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sales Person",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: Text(
                        " :",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sales Team",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: Text(
                        "    :",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Warehouse",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: Text(
                        "    :",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
      ]),
    );
  }
}
