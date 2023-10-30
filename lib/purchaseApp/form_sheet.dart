import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'complete_api_data.dart';
import 'approve_api_data.dart';
import 'home_page.dart';
import 'cancel_po.dart';

class FormSheet extends StatefulWidget {
  CompleteData completeData;
  FormSheet({
    Key? key,
    required this.completeData,
  }) : super(key: key);
  @override
  State<FormSheet> createState() => _FormSheetPage();
}

class _FormSheetPage extends State<FormSheet> {
  String? approveSuccess;
  String? cancelReason = "";
  String? cancelSuccess;

  Future<ApproveData?> approvePOData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = await prefs.getString('url');
      var apiurl = "http://$url/json-call";
      String? token = await prefs.getString('token');

      final approveResponse = await http.post(
        Uri.parse(apiurl!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "jsonrpc": "2.0",
          "params": {
            "token": token,
            "model": "purchase.order",
            "method": "get_purchase_order_return_list",
            "args": [
              {
                "purchase_id": [widget.completeData.purchaseOrderId]
              }
            ],
            "context": {}
          }
        }),
      );

      if (approveResponse.statusCode == 200) {
        final approveResponseBody = jsonDecode(approveResponse.body);
        if (approveResponseBody['result'] != null) {
          final approveResponseBodyResult = approveResponseBody['result'];
          if (ApproveData.fromJson(approveResponseBodyResult).result != null) {
            approveSuccess =
                ApproveData?.fromJson(approveResponseBodyResult).result;
          }
        } else {
          throw approveResponseBody["error"]["data"]["message"];
        }
      } else {
        throw Exception('Failed to Execute.');
      }
    } catch (error) {
      Navigator.pop(context);
      Flushbar(
        message: error.toString(),
        messageColor:
            error.toString() == "success" ? Colors.green : Colors.white,
        backgroundColor:
            error.toString() == "success" ? Colors.white : Colors.black,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        borderRadius: BorderRadius.circular(5),
        duration: const Duration(milliseconds: 2000),
        icon: Icon(
          error.toString() == "success"
              ? Icons.check_circle_rounded
              : Icons.error,
          color: error.toString() == "success" ? Colors.green : Colors.white,
        ),
      ).show(context);
    }
  }

  Future<ApproveData?> cancelPOData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = await prefs.getString('url');
      var apiurl = "http://$url/json-call";
      String? token = await prefs.getString('token');

      final approveResponse = await http.post(
        Uri.parse(apiurl!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "jsonrpc": "2.0",
          "params": {
            "token": "${token}",
            "model": "purchase.order",
            "method": "get_purchase_order_cancel",
            "args": [
              {
                "purchase_id": widget.completeData.purchaseOrderId,
                "reason_cancel": "${cancelReason}"
              }
            ],
            "context": {}
          }
        }),
      );

      if (approveResponse.statusCode == 200) {
        final approveResponseBody = jsonDecode(approveResponse.body);
        if (approveResponseBody['result'] != null) {
          final approveResponseBodyResult = approveResponseBody['result'];
          if (CancelData.fromJson(approveResponseBodyResult).result ==
              "PO Cancelled") {
            cancelSuccess =
                CancelData?.fromJson(approveResponseBodyResult).result;
          }
        } else {
          throw approveResponseBody["error"]["data"]["message"];
        }
      } else {
        throw Exception('Failed to Execute.');
      }
    } catch (error) {
      Navigator.pop(context);
      Flushbar(
        message: error.toString(),
        messageColor:
            error.toString() == "PO Cancelled" ? Colors.green : Colors.white,
        backgroundColor:
            error.toString() == "PO Cancelled" ? Colors.white : Colors.black,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        borderRadius: BorderRadius.circular(5),
        duration: const Duration(milliseconds: 2000),
        icon: Icon(
          error.toString() == "success"
              ? Icons.check_circle_rounded
              : Icons.error,
          color: error.toString() == "success" ? Colors.green : Colors.white,
        ),
      ).show(context);
    }
  }

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
                  await cancelPOData();
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
            Text('PO Details'),
            Row(children: [
              TextButton(
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.white, width: 1),
                  ),
                  onPressed: () async {
                    showLoaderDialog(context);
                    await approvePOData();
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
        Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.name == " " ||
                                    widget.completeData.name == null
                                ? SizedBox.shrink()
                                : Text(
                                    "PO No.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.vendor == " " ||
                                    widget.completeData.vendor == null
                                ? SizedBox.shrink()
                                : Text(
                                    "Vendor",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.dateOrder == " " ||
                                    widget.completeData.dateOrder == null
                                ? SizedBox.shrink()
                                : Text(
                                    "Order Date",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.scheduledDate == " " ||
                                    widget.completeData.scheduledDate == null
                                ? SizedBox.shrink()
                                : Text(
                                    "Sched. Date",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.so == " " ||
                                    widget.completeData.so == null
                                ? SizedBox.shrink()
                                : Text(
                                    "S.O No.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.paymentTerms == null ||
                                    widget.completeData.paymentTerms == " "
                                ? SizedBox.shrink()
                                : Text(
                                    "Pay Term",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.type == null ||
                                    widget.completeData.type == " "
                                ? SizedBox.shrink()
                                : Text(
                                    "Type  ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.amountTax == null ||
                                    widget.completeData.untaxedAmount == " " ||
                                    widget.completeData.untaxedAmount == 0.0
                                ? SizedBox.shrink()
                                : Text(
                                    "Amount  ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.amountTax == null ||
                                    widget.completeData.amountTax == " " ||
                                    widget.completeData.amountTax == 0.0
                                ? SizedBox.shrink()
                                : Text(
                                    "Taxes  ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Row(
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.createdby == " " ||
                                    widget.completeData.createdby == null
                                ? SizedBox.shrink()
                                : Text(
                                    "Created By",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 8, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.name == " " ||
                                    widget.completeData.name == null
                                ? SizedBox.shrink()
                                : Text(
                                    ": ${widget.completeData.name}",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.vendor == " " ||
                                    widget.completeData.vendor == null
                                ? SizedBox.shrink()
                                : Text(
                                    ": ${widget.completeData.vendor}",
                                    style: TextStyle(fontSize: 14),
                                  )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.dateOrder == " " ||
                                    widget.completeData.dateOrder == null
                                ? SizedBox.shrink()
                                : Text(
                                    ": ${scheduleDatetime(widget.completeData.dateOrder?.substring(0, 10))}",
                                    style: TextStyle(fontSize: 15),
                                  )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.scheduledDate == " " ||
                                    widget.completeData.scheduledDate == null
                                ? SizedBox.shrink()
                                : Text(
                                    ": ${scheduleDatetime(widget.completeData.scheduledDate?.substring(0, 10))}",
                                    style: TextStyle(fontSize: 15),
                                  )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.so == " " ||
                                    widget.completeData.so == null
                                ? SizedBox.shrink()
                                : Text(": ${widget.completeData.so}",
                                    style: TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.paymentTerms == null ||
                                    widget.completeData.paymentTerms == " "
                                ? SizedBox.shrink()
                                : Text(": ${widget.completeData.paymentTerms}",
                                    style: TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.type == null ||
                                    widget.completeData.type == " "
                                ? SizedBox.shrink()
                                : Text(": ${widget.completeData.type}",
                                    style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.amountTax == null ||
                                    widget.completeData.untaxedAmount == " " ||
                                    widget.completeData.untaxedAmount == 0.0
                                ? SizedBox.shrink()
                                : Text(
                                    ": ${widget.completeData.untaxedAmount?.toStringAsFixed(2)}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.amountTax == null ||
                                    widget.completeData.amountTax == " " ||
                                    widget.completeData.amountTax == 0.0
                                ? SizedBox.shrink()
                                : Text(
                                    ": ${widget.completeData.amountTax?.toStringAsFixed(2)}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.total == null
                                ? Text(": 0.00")
                                : Text(
                                    ": ${widget.completeData.total?.toStringAsFixed(2)}",
                                    style: TextStyle(fontSize: 15))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Row(
                          children: [
                            widget.completeData.createdby == null
                                ? SizedBox.shrink()
                                : Text(": ${widget.completeData.createdby}",
                                    style: TextStyle(fontSize: 15))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.completeData.purchaseOrderLineList?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color(0xFF3498CC), width: 1),
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
                                    "Product: ",
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
                                        "${widget.completeData.purchaseOrderLineList?[index].productId}",
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
                                  widget
                                                  .completeData
                                                  .purchaseOrderLineList?[index]
                                                  .image ==
                                              " " ||
                                          widget
                                                  .completeData
                                                  .purchaseOrderLineList?[index]
                                                  .image ==
                                              null
                                      ? Image(
                                          image:
                                              AssetImage("assets/no-image.png"),
                                          fit: BoxFit.fill,
                                          width: 120,
                                          alignment: Alignment.center,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl:
                                              "${widget.completeData.purchaseOrderLineList?[index].image}",
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) {
                                            return Image(
                                              image: AssetImage(
                                                  "assets/no-image.png"),
                                              fit: BoxFit.fill,
                                              width: 120,
                                              alignment: Alignment.center,
                                            );
                                          }),

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
                                            widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .qty ==
                                                        null ||
                                                    widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .qty ==
                                                        " " ||
                                                    widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .qty ==
                                                        0.0
                                                ? SizedBox.shrink()
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Qty        :",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          child: Text(
                                                            " ${widget.completeData.purchaseOrderLineList?[index].qty?.toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                            widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .uom ==
                                                        null ||
                                                    widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .uom ==
                                                        " "
                                                ? SizedBox.shrink()
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "UOM     :",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          child: Text(
                                                            " ${widget.completeData.purchaseOrderLineList?[index].uom}",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                            widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .unitPrice ==
                                                        null ||
                                                    widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .unitPrice ==
                                                        " " ||
                                                    widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .unitPrice ==
                                                        0.0
                                                ? SizedBox.shrink()
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "U.Price :",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          child: Text(
                                                            " ${widget.completeData.purchaseOrderLineList?[index].unitPrice?.toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                            widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .subtotal ==
                                                        0.0 ||
                                                    widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .subtotal ==
                                                        null
                                                ? Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "S.Total :",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                      Text(
                                                        " 0.00",
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      )
                                                    ],
                                                  )
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "S.Total :",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          child: Text(
                                                            " ${widget.completeData.purchaseOrderLineList?[index].subtotal?.toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                            widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .sQty ==
                                                        null ||
                                                    widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .sQty ==
                                                        " " ||
                                                    widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .sQty ==
                                                        0.0
                                                ? SizedBox.shrink()
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "S.Qty    :",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          child: Text(
                                                            " ${widget.completeData.purchaseOrderLineList?[index].sQty?.toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                            widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .sUnit ==
                                                        null ||
                                                    widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .sUnit ==
                                                        " "
                                                ? SizedBox.shrink()
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "S.Unit   :",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          child: Text(
                                                            " ${widget.completeData.purchaseOrderLineList?[index].sUnit}",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                            widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .size ==
                                                        null ||
                                                    widget
                                                            .completeData
                                                            .purchaseOrderLineList?[
                                                                index]
                                                            .size ==
                                                        " "
                                                ? SizedBox.shrink()
                                                : Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Size      :",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                      Expanded(
                                                          child: SizedBox(
                                                        child: Text(
                                                          " ${widget.completeData.purchaseOrderLineList?[index].size}",
                                                          style: TextStyle(
                                                              fontSize: 13),
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
                                  widget
                                              .completeData
                                              .purchaseOrderLineList?[index]
                                              .finalProductId ==
                                          " "
                                      ? SizedBox.shrink()
                                      : Text(
                                          "Final Product: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.black),
                                        ),
                                  widget
                                              .completeData
                                              .purchaseOrderLineList?[index]
                                              .finalProductId ==
                                          " "
                                      ? SizedBox.shrink()
                                      : Expanded(
                                          child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Text(
                                            "${widget.completeData.purchaseOrderLineList?[index].finalProductId}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ))
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget
                                              .completeData
                                              .purchaseOrderLineList?[index]
                                              .description ==
                                          " "
                                      ? SizedBox.shrink()
                                      : Text(
                                          "Description: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 13,
                                              color: Colors.black),
                                        ),
                                  widget
                                              .completeData
                                              .purchaseOrderLineList?[index]
                                              .description ==
                                          " "
                                      ? SizedBox.shrink()
                                      : Expanded(
                                          child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Text(
                                            "${widget.completeData.purchaseOrderLineList?[index].description}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                            maxLines: 2,
                                          ),
                                        ))
                                ],
                              )
                            ]),
                      ),
                    );
                  })),
        )
      ]),
    );
  }
}
