import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';
import '../login_page.dart';
import 'drop_down_api_data.dart';
import 'search_api_data.dart';
import 'approve_api_data.dart';
import 'complete_api_data.dart';
import '../exit_app.dart';
import 'form_sheet.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  vendorData? vendorresponsedata;
  List<SupplierList?> vendorNameList = [];
  AddressData? addressresponsedata;
  PurchaseData? purchaseresponsedata;
  PurchaseOrderData? purchaseOrderData;
  CompleteData? purchaseCompleteData;
  String? appBarImage;
  String? appBarName;
  bool isloading = true;
  bool loadListItem = true;
  bool showListDetail = true;
  bool showSelectContainerButton = false;
  bool showapproveLoading = true;
  bool showRemoveBtn = false;
  int? purchaseDropDownId;
  String? purchaseDropDownName;
  int? vendorDropDownId = 0;
  String? vendorDropDownName;
  int? addressDropDownId = 0;
  String? addressDropDownName;
  String? approveResult;
  String? startDate = "";
  String? endDate = "";
  bool? showDate = false;
  List<int> idList = [];
  int selctedNumber = 0;
  bool selectMode = false;

  Future<vendorData> VendorApiFunc() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = await prefs.getString('url');
    String apiurl = "http://$url/json-call";
    String? token = await prefs.getString('token');
    int? uid = await prefs.getInt('uid');
    final vendorResponse = await http.post(
      Uri.parse(apiurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "jsonrpc": "2.0",
        "params": {
          "token": token,
          "model": "res.partner",
          "method": "get_supplier_list",
          "args": [
            {"odoo_user_id": uid}
          ],
          "context": {}
        }
      }),
    );

    if (vendorResponse.statusCode == 200) {
      final vendorResponseBody = jsonDecode(vendorResponse.body);

      final vendorResponseBodyResult = vendorResponseBody['result'];

      return vendorData.fromJson(vendorResponseBodyResult);
    } else {
      throw Exception('Failed to Execute.');
    }
  }

  Future<PurchaseData?> PurchaseApiFunc() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = await prefs.getString('url');
    var apiurl = "http://$url/json-call";
    String? token = await prefs.getString('token');
    int? uid = await prefs.getInt('uid');
    final purchaseResponse = await http.post(
      Uri.parse(apiurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "jsonrpc": "2.0",
        "params": {
          "token": token,
          "model": "purchase.order.type",
          "method": "get_purchase_order_type_list",
          "args": [
            {"odoo_user_id": uid}
          ],
          "context": {}
        }
      }),
    );

    if (purchaseResponse.statusCode == 200) {
      final purchaseResponseBody = jsonDecode(purchaseResponse.body);
      final purchaseResponseBodyResult = purchaseResponseBody['result'];
      return PurchaseData.fromJson(purchaseResponseBodyResult);
    } else {
      throw Exception('not found');
    }
  }

  Future<AddressData> AddressApiFunc() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = await prefs.getString('url');
    var apiurl = "http://$url/json-call";
    String? token = await prefs.getString('token');
    int? uid = await prefs.getInt('uid');

    // print(apiurl);
    final addressResponse = await http.post(
      Uri.parse(apiurl!),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "jsonrpc": "2.0",
        "params": {
          "token": token,
          "model": "stock.warehouse",
          "method": "get_stock_warehouse_list",
          "args": [
            {"odoo_user_id": uid}
          ],
          "context": {}
        }
      }),
    );

    if (addressResponse.statusCode == 200) {
      final addressResponseBody = jsonDecode(addressResponse.body);
      final addressResponseBodyResult = addressResponseBody['result'];
      return AddressData.fromJson(addressResponseBodyResult);
    } else {
      throw Exception('Failed to Execute.');
    }
  }

  Future<PurchaseOrderData?> searchData() async {
    try {
      if (purchaseDropDownId == null) {
        throw ('Select Purchase Type');
      }
      // else if (addressDropDownId == null) {
      //   throw ('Select Address');
      // }
      else {
        loadListItem = true;
        showListDetail = false;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var url = await prefs.getString('url');
        var apiurl = "http://$url/json-call";
        String? token = await prefs.getString('token');
        final searchResponse = await http.post(
          Uri.parse(apiurl!),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "jsonrpc": "2.0",
            "params": {
              "token": token,
              "model": "purchase.order",
              "method": "get_purchase_order_list",
              "args": [
                {
                  "from_date": startDate,
                  "to_date": endDate,
                  "warehouse_id": addressDropDownId,
                  "purchase_type_id": purchaseDropDownId,
                  "vendor_id": vendorDropDownId
                }
              ],
              "context": {}
            }
          }),
        );
        if (searchResponse.statusCode == 200) {
          final searchResponseBody = jsonDecode(searchResponse.body);
          final searchResponseBodyResult = searchResponseBody['result'];
          loadListItem = false;

          return PurchaseOrderData.fromJson(searchResponseBodyResult);
        } else {
          loadListItem = false;
          showSelectContainerButton = false;
          throw Exception('Failed to Execute.');
        }
      }
    } catch (error) {
      Flushbar(
        message: error.toString(),
        backgroundColor: Colors.black,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        borderRadius: BorderRadius.circular(5),
        duration: const Duration(milliseconds: 2000),
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
      ).show(context);
    }
  }

  Future<ApproveData?> approveData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = await prefs.getString('url');
      var apiurl = "http://$url/json-call";
      String? token = await prefs.getString('token');
      // int? uid = await prefs.getInt('uid');

      // print(apiurl);
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
              {"purchase_id": idList}
            ],
            "context": {}
          }
        }),
      );

      if (approveResponse.statusCode == 200) {
        final approveResponseBody = jsonDecode(approveResponse.body);
        if (approveResponseBody["result"] != null) {
          final approveResponseBodyResult = approveResponseBody['result'];
          // print(ApproveData.fromJson(approveResponseBodyResult).result!);
          if (ApproveData.fromJson(approveResponseBodyResult).result ==
              "Po Approved") {
            approveResult =
                await ApproveData?.fromJson(approveResponseBodyResult).result;
            Navigator.pop(context);
            // setState(() {});
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
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        borderRadius: BorderRadius.circular(5),
        duration: const Duration(milliseconds: 6000),
        icon: Icon(
          error.toString() == "success"
              ? Icons.check_circle_rounded
              : Icons.error,
          color: error.toString() == "success" ? Colors.green : Colors.white,
        ),
      ).show(context);
    }
  }

  Future<CompleteData?> completeData(id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = await prefs.getString('url');
      String apiurl = "http://$url/json-call";
      String? token = await prefs.getString('token');
      final completeResponse = await http.post(
        Uri.parse(apiurl!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "jsonrpc": "2.0",
          "params": {
            "token": token,
            "model": "purchase.order",
            "method": "get_purchase_order_line_list",
            "args": [
              {"purchase_id": id}
            ],
            "context": {}
          }
        }),
      );

      if (completeResponse.statusCode == 200) {
        final completeResponseBody = jsonDecode(completeResponse.body);
        final completeResponseBodyResult = completeResponseBody['result'];
        setState(() {
          showapproveLoading = false;
        });

        return CompleteData.fromJson(completeResponseBodyResult);
      } else {
        throw Exception('Failed to Execute.');
      }
    } catch (error) {
      Flushbar(
        message: error.toString(),
        backgroundColor: Colors.black,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        borderRadius: BorderRadius.circular(5),
        duration: const Duration(milliseconds: 1100),
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
      ).show(context);
    }
  }

  List<SupplierList?> vendorSearch(value) {
    List<SupplierList?> vendorName = [];
    for (int i = 0; i < vendorresponsedata!.supplierList!.length; i++) {
      String name = vendorresponsedata!.supplierList![i].name!;
      if (name!.toLowerCase().contains(value.toLowerCase())) {
        vendorName.add(vendorresponsedata!.supplierList![i]);
      }
    }
    return vendorName;
  }

  selectedItem(id) {
    if (idList.contains(id)) {
      idList.remove(id);
    } else {
      idList.add(id);
    }

    setState(() {
      selctedNumber = idList.length;
      showSelectContainerButton = true;
      showRemoveBtn = false;
    });
    if (selctedNumber == 0) {
      setState(() {
        showSelectContainerButton = false;
      });
    } else if (selctedNumber == purchaseOrderData!.purchaseOrderList!.length) {
      setState(() {
        showSelectContainerButton = true;
        showRemoveBtn = true;
      });
    }
  }

  selectAll() {
    for (var item in purchaseOrderData!.purchaseOrderList!) {
      if (idList.contains(item.odooPurchaseOrderId)) {
        continue;
      } else {
        idList.add(item.odooPurchaseOrderId!);
      }
      setState(() {
        showRemoveBtn = true;
        selctedNumber = idList.length;
      });
    }
  }

  removeAll() {
    setState(() {
      idList = [];
      showSelectContainerButton = false;
      selctedNumber = idList.length;
    });
  }

  orderDate(date) {
    if (date == "") {
      return "NAN";
    } else {
      DateTime time = DateTime.parse(date);
      return "${time.day} ${DateFormat.MMM().format(time)}";
    }
  }

  scheduleDate(date) {
    if (date == "") {
      return "NAN";
    } else {
      DateTime time = DateTime.parse(date);
      return "${time.day} ${DateFormat.MMM().format(time)}";
    }
  }

  @override
  void initState() {
    super.initState();
    loaddata();
    // monthZeroCheck();
    appBarImageName();
  }

  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime.now().subtract(const Duration(days: 15)),
    DateTime.now()
  ];

  monthZeroCheck() {
    if (_dialogCalendarPickerValue[0]!.month <= 9 &&
        _dialogCalendarPickerValue[1]!.month >= 10) {
      setState(() {
        _dialogCalendarPickerValue[0]!.day >= 10
            ? startDate =
                "${_dialogCalendarPickerValue[0]?.year}-0${_dialogCalendarPickerValue[0]?.month}-${_dialogCalendarPickerValue[0]?.day}"
            : startDate =
                "${_dialogCalendarPickerValue[0]?.year}-0${_dialogCalendarPickerValue[0]?.month}-0${_dialogCalendarPickerValue[0]?.day}";
        _dialogCalendarPickerValue[1]!.day >= 10
            ? endDate =
                "${_dialogCalendarPickerValue[1]?.year}-${_dialogCalendarPickerValue[1]?.month}-${_dialogCalendarPickerValue[1]?.day}"
            : endDate =
                "${_dialogCalendarPickerValue[1]?.year}-${_dialogCalendarPickerValue[1]?.month}-0${_dialogCalendarPickerValue[1]?.day}";
      });
    } else if (_dialogCalendarPickerValue[0]!.month >= 10 &&
        _dialogCalendarPickerValue[1]!.month <= 9) {
      setState(() {
        _dialogCalendarPickerValue[0]!.day >= 10
            ? startDate =
                "${_dialogCalendarPickerValue[0]?.year}-${_dialogCalendarPickerValue[0]?.month}-${_dialogCalendarPickerValue[0]?.day}"
            : startDate =
                "${_dialogCalendarPickerValue[0]?.year}-${_dialogCalendarPickerValue[0]?.month}-0${_dialogCalendarPickerValue[0]?.day}";

        _dialogCalendarPickerValue[1]!.day >= 10
            ? endDate =
                "${_dialogCalendarPickerValue[1]?.year}-0${_dialogCalendarPickerValue[1]?.month}-${_dialogCalendarPickerValue[1]?.day}"
            : endDate =
                "${_dialogCalendarPickerValue[1]?.year}-0${_dialogCalendarPickerValue[1]?.month}-0${_dialogCalendarPickerValue[1]?.day}";
      });
    } else if (_dialogCalendarPickerValue[0]!.month >= 10 &&
        _dialogCalendarPickerValue[1]!.month >= 10) {
      setState(() {
        _dialogCalendarPickerValue[0]!.day >= 10
            ? startDate =
                "${_dialogCalendarPickerValue[0]?.year}-${_dialogCalendarPickerValue[0]?.month}-${_dialogCalendarPickerValue[0]?.day}"
            : startDate =
                "${_dialogCalendarPickerValue[0]?.year}-${_dialogCalendarPickerValue[0]?.month}-0${_dialogCalendarPickerValue[0]?.day}";
        _dialogCalendarPickerValue[1]!.day >= 10
            ? endDate =
                "${_dialogCalendarPickerValue[1]?.year}-${_dialogCalendarPickerValue[1]?.month}-${_dialogCalendarPickerValue[1]?.day}"
            : endDate =
                "${_dialogCalendarPickerValue[1]?.year}-${_dialogCalendarPickerValue[1]?.month}-0${_dialogCalendarPickerValue[1]?.day}";
      });
    } else {
      setState(() {
        _dialogCalendarPickerValue[0]!.day >= 10
            ? startDate =
                "${_dialogCalendarPickerValue[0]?.year}-0${_dialogCalendarPickerValue[0]?.month}-${_dialogCalendarPickerValue[0]?.day}"
            : startDate =
                "${_dialogCalendarPickerValue[0]?.year}-0${_dialogCalendarPickerValue[0]?.month}-0${_dialogCalendarPickerValue[0]?.day}";
        _dialogCalendarPickerValue[1]!.day >= 10
            ? endDate =
                "${_dialogCalendarPickerValue[1]?.year}-0${_dialogCalendarPickerValue[1]?.month}-${_dialogCalendarPickerValue[1]?.day}"
            : endDate =
                "${_dialogCalendarPickerValue[1]?.year}-0${_dialogCalendarPickerValue[1]?.month}-0${_dialogCalendarPickerValue[1]?.day}";
      });
    }
  }

  int? calenderValue;
  _buildCalendarDialogButton() {
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
        TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: const Color(0xFF3498CC),
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffe6f7fd),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Colors.transparent,
                      elevation: 1,
                      shadowColor: Colors.transparent),
                  onPressed: () async {
                    final values = await showCalendarDatePicker2Dialog(
                      context: context,
                      config: config,
                      dialogSize: const Size(325, 400),
                      borderRadius: BorderRadius.circular(15),
                      value: _dialogCalendarPickerValue,
                      dialogBackgroundColor: Colors.white,
                    );
                    print(values);
                    if (values != null) {
                      if (values.length == 2) {
                        _dialogCalendarPickerValue = values;
                        calenderValue = 2;
                        showDate = true;
                        if (_dialogCalendarPickerValue[0]!.month <= 9 &&
                            _dialogCalendarPickerValue[1]!.month >= 10) {
                          // setState(() {
                          _dialogCalendarPickerValue[0]!.day >= 10
                              ? startDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-0${_dialogCalendarPickerValue[0]?.month}-${_dialogCalendarPickerValue[0]?.day}"
                              : startDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-0${_dialogCalendarPickerValue[0]?.month}-0${_dialogCalendarPickerValue[0]?.day}";
                          _dialogCalendarPickerValue[1]!.day >= 10
                              ? endDate =
                                  "${_dialogCalendarPickerValue[1]?.year}-${_dialogCalendarPickerValue[1]?.month}-${_dialogCalendarPickerValue[1]?.day}"
                              : endDate =
                                  "${_dialogCalendarPickerValue[1]?.year}-${_dialogCalendarPickerValue[1]?.month}-0${_dialogCalendarPickerValue[1]?.day}";
                          // });
                        } else if (_dialogCalendarPickerValue[0]!.month >= 10 &&
                            _dialogCalendarPickerValue[1]!.month <= 9) {
                          // setState(() {
                          _dialogCalendarPickerValue[0]!.day >= 10
                              ? startDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-${_dialogCalendarPickerValue[0]?.month}-${_dialogCalendarPickerValue[0]?.day}"
                              : startDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-${_dialogCalendarPickerValue[0]?.month}-0${_dialogCalendarPickerValue[0]?.day}";

                          _dialogCalendarPickerValue[1]!.day >= 10
                              ? endDate =
                                  "${_dialogCalendarPickerValue[1]?.year}-0${_dialogCalendarPickerValue[1]?.month}-${_dialogCalendarPickerValue[1]?.day}"
                              : endDate =
                                  "${_dialogCalendarPickerValue[1]?.year}-0${_dialogCalendarPickerValue[1]?.month}-0${_dialogCalendarPickerValue[1]?.day}";
                          // });
                        } else if (_dialogCalendarPickerValue[0]!.month >= 10 &&
                            _dialogCalendarPickerValue[1]!.month >= 10) {
                          _dialogCalendarPickerValue[0]!.day >= 10
                              ? startDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-${_dialogCalendarPickerValue[0]?.month}-${_dialogCalendarPickerValue[0]?.day}"
                              : startDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-${_dialogCalendarPickerValue[0]?.month}-0${_dialogCalendarPickerValue[0]?.day}";
                          _dialogCalendarPickerValue[1]!.day >= 10
                              ? endDate =
                                  "${_dialogCalendarPickerValue[1]?.year}-${_dialogCalendarPickerValue[1]?.month}-${_dialogCalendarPickerValue[1]?.day}"
                              : endDate =
                                  "${_dialogCalendarPickerValue[1]?.year}-${_dialogCalendarPickerValue[1]?.month}-0${_dialogCalendarPickerValue[1]?.day}";
                        } else {
                          print(values);
                          _dialogCalendarPickerValue[0]!.day >= 10
                              ? startDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-0${_dialogCalendarPickerValue[0]?.month}-${_dialogCalendarPickerValue[0]?.day}"
                              : startDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-0${_dialogCalendarPickerValue[0]?.month}-0${_dialogCalendarPickerValue[0]?.day}";
                          _dialogCalendarPickerValue[1]!.day >= 10
                              ? endDate =
                                  "${_dialogCalendarPickerValue[1]?.year}-0${_dialogCalendarPickerValue[1]?.month}-${_dialogCalendarPickerValue[1]?.day}"
                              : endDate =
                                  "${_dialogCalendarPickerValue[1]?.year}-0${_dialogCalendarPickerValue[1]?.month}-0${_dialogCalendarPickerValue[1]?.day}";
                        }

                        setState(() {});
                      } else {
                        _dialogCalendarPickerValue = values;
                        showDate = true;
                        print(values);
                        calenderValue = 1;
                        if (_dialogCalendarPickerValue[0]!.month >= 10) {
                          _dialogCalendarPickerValue[0]!.day >= 10
                              ? startDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-${_dialogCalendarPickerValue[0]?.month}-${_dialogCalendarPickerValue[0]?.day}"
                              : startDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-${_dialogCalendarPickerValue[0]?.month}-0${_dialogCalendarPickerValue[0]?.day}";

                          _dialogCalendarPickerValue[0]!.day >= 10
                              ? endDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-${_dialogCalendarPickerValue[0]?.month}-${_dialogCalendarPickerValue[0]?.day}"
                              : endDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-${_dialogCalendarPickerValue[0]?.month}-0${_dialogCalendarPickerValue[0]?.day}";
                        } else {
                          _dialogCalendarPickerValue[0]!.day >= 10
                              ? startDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-0${_dialogCalendarPickerValue[0]?.month}-${_dialogCalendarPickerValue[0]?.day}"
                              : startDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-0${_dialogCalendarPickerValue[0]?.month}-0${_dialogCalendarPickerValue[0]?.day}";

                          _dialogCalendarPickerValue[0]!.day >= 10
                              ? endDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-0${_dialogCalendarPickerValue[0]?.month}-${_dialogCalendarPickerValue[0]?.day}"
                              : endDate =
                                  "${_dialogCalendarPickerValue[0]?.year}-0${_dialogCalendarPickerValue[0]?.month}-0${_dialogCalendarPickerValue[0]?.day}";
                        }

                        setState(() {});
                      }
                    }
                  },
                  child: showDate == true
                      ? startDate != endDate
                          ? Text(
                              '${_dialogCalendarPickerValue[0]?.day} ${DateFormat.MMM().format(_dialogCalendarPickerValue[0]!) == DateFormat.MMM().format(_dialogCalendarPickerValue[1]!) ? "" : DateFormat.MMM().format(_dialogCalendarPickerValue[0]!)} ${_dialogCalendarPickerValue[0]!.year == _dialogCalendarPickerValue[1]!.year ? "" : _dialogCalendarPickerValue[0]!.year} -'
                              ' ${_dialogCalendarPickerValue[1]?.day} ${DateFormat.MMM().format(_dialogCalendarPickerValue[1]!)} ${_dialogCalendarPickerValue[0]!.year == _dialogCalendarPickerValue[1]!.year ? "" : _dialogCalendarPickerValue[1]!.year}',
                              style: const TextStyle(fontSize: 14),
                            )
                          : Text(
                              "${_dialogCalendarPickerValue[0]!.day} ${DateFormat.MMM().format(_dialogCalendarPickerValue[0]!)}")
                      : Text("Please Select"))),
        ],
      ),
    );
  }

  appBarImageName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    appBarImage = await prefs.getString('image');
    appBarName = await prefs.getString('name');
  }

  loaddata() async {
    vendorresponsedata = await VendorApiFunc();
    purchaseresponsedata = await PurchaseApiFunc();
    addressresponsedata = await AddressApiFunc();
    purchaseDropDownName =
        await purchaseresponsedata?.purchaseOrderList?[0].name;
    purchaseDropDownId =
        await purchaseresponsedata?.purchaseOrderList?[0].odooPurchaseTypeId;
    // addressDropDownName =
    //     await addressresponsedata?.stockWarehouseList?[0].name;
    // addressDropDownId =
    //     await addressresponsedata?.stockWarehouseList?[0].odooWarehouseId;
    purchaseOrderData = await searchData();
    isloading = false;
    setState(() {});
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

  void LogoutButton() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('uid');
    await prefs.remove('image');
    await prefs.remove('premium');
    await prefs.remove('name');
    final String? token = prefs.getString('token');
    if (token == null) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    }
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("NO"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
        child: const Text("YES"),
        onPressed: () => {
              Navigator.pop(context),
              LogoutButton(),
            });

    AlertDialog alert = AlertDialog(
      title: const Text(
        "Do You Want to Log Out?",
        style: TextStyle(fontSize: 15, color: Color(0xFF3498CC)),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget build(BuildContext context) {
    return isloading
        ? const Scaffold(
            backgroundColor: Color(0xffe6f7fd),
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 22, // Image radius
                              backgroundImage: NetworkImage('${appBarImage}'),
                            ),
                            Text(
                              "${appBarName}",
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        const Text(
                          "Home Page",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () async {
                              await showAlertDialog(context);
                            },
                            icon: const Icon(
                              Icons.logout,
                              size: 25,
                            )),
                      ],
                    )
                  ]),
              backgroundColor: const Color(0xFF3498CC),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 12, 0, 10),
                      child: Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                                  onTap: () async {
                                    //==purchase type=========================
                                    await showModalBottomSheet<void>(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0),
                                        ),
                                      ),
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: <Widget>[
                                                ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        purchaseresponsedata
                                                            ?.purchaseOrderList
                                                            ?.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                          onTap: () async {
                                                            purchaseDropDownId =
                                                                purchaseresponsedata
                                                                    ?.purchaseOrderList?[
                                                                        index]
                                                                    .odooPurchaseTypeId;
                                                            purchaseDropDownName =
                                                                purchaseresponsedata
                                                                    ?.purchaseOrderList?[
                                                                        index]
                                                                    .name;
                                                            print(
                                                                purchaseDropDownId);
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          },
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              child: ListTile(
                                                                  dense: true,
                                                                  contentPadding:
                                                                      EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              40,
                                                                          vertical:
                                                                              0),
                                                                  visualDensity:
                                                                      VisualDensity(
                                                                          horizontal:
                                                                              0,
                                                                          vertical:
                                                                              -4),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  title: Text(
                                                                    "${purchaseresponsedata?.purchaseOrderList?[index].name}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                  ))));
                                                    })
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Purchase Type",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "*",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${purchaseDropDownName}",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))),
                          Expanded(
                              flex: 1,
                              child: GestureDetector(
                                  onTap: () async {
//==address===========//
                                    await showModalBottomSheet<void>(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0),
                                        ),
                                      ),
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: <Widget>[
                                                ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        addressresponsedata
                                                            ?.stockWarehouseList
                                                            ?.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                          onTap: () async {
                                                            addressDropDownId =
                                                                addressresponsedata
                                                                    ?.stockWarehouseList?[
                                                                        index]
                                                                    .odooWarehouseId;
                                                            addressDropDownName =
                                                                addressresponsedata
                                                                    ?.stockWarehouseList?[
                                                                        index]
                                                                    .name;
                                                            print(
                                                                addressDropDownId);
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          },
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              child: ListTile(
                                                                  dense: true,
                                                                  contentPadding:
                                                                      EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              40,
                                                                          vertical:
                                                                              0),
                                                                  visualDensity:
                                                                      VisualDensity(
                                                                          horizontal:
                                                                              0,
                                                                          vertical:
                                                                              -4),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  // tileColor: Color(
                                                                  //     0xffe6f7fd),
                                                                  title: Text(
                                                                    "${addressresponsedata?.stockWarehouseList?[index].name}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                  ))));
                                                    })
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Address",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              addressDropDownName == null
                                                  ? Text("")
                                                  : GestureDetector(
                                                      onTap: () async {
                                                        addressDropDownName =
                                                            null;
                                                        addressDropDownId = 0;
                                                        setState(() {});
                                                        print(vendorDropDownId);
                                                      },
                                                      child: Icon(
                                                        Icons.cancel,
                                                        size: 20,
                                                      ))
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${addressDropDownName != null ? addressDropDownName : "Please select"}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )))
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Color(0xFF3498CC),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              // flex: 1,
                              child: GestureDetector(
                                  onTap: () async {
                                    vendorNameList =
                                        await vendorresponsedata!.supplierList!;
                                    await showModalBottomSheet(
                                      isDismissible: true,
                                      // isScrollControlled: true,
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0),
                                        ),
                                      ),
                                      builder: (context) {
                                        return StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          return SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.9,
                                            child: SingleChildScrollView(
                                              padding: EdgeInsets.all(0),
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: SizedBox(
                                                      // height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                      child: TextField(
                                                        onChanged:
                                                            (value) async {
                                                          vendorNameList =
                                                              await vendorSearch(
                                                                  value);
                                                          setState(() {});
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                                prefixIcon:
                                                                    Icon(Icons
                                                                        .search),
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        vertical:
                                                                            1),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50.0),
                                                                ),
                                                                hintText:
                                                                    'Search Vendor'),
                                                      ),
                                                    ),
                                                  ),
                                                  vendorNameList.length == 0
                                                      ? Text(
                                                          "Vendor Not Found",
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  0xFF3498CC)),
                                                        )
                                                      : ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              vendorNameList
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  vendorDropDownId =
                                                                      vendorNameList[
                                                                              index]!
                                                                          .odooSupplierId;
                                                                  vendorDropDownName =
                                                                      vendorNameList[
                                                                              index]!
                                                                          .name;

                                                                  Navigator.pop(
                                                                      context);

                                                                  this.setState(
                                                                      () {});
                                                                },
                                                                child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(0),
                                                                    child: ListTile(
                                                                        dense: true,
                                                                        contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                                                                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                        title: Text(
                                                                          "${vendorNameList[index]!.name}",
                                                                          style:
                                                                              TextStyle(fontSize: 15),
                                                                        ))));
                                                          })
                                                ],
                                              ),
                                            ),
                                          );
                                          //   },
                                          // );
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 14),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Vendor",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              vendorDropDownName == null
                                                  ? Text("")
                                                  : GestureDetector(
                                                      onTap: () async {
                                                        vendorDropDownName =
                                                            null;
                                                        vendorDropDownId = 0;
                                                        setState(() {});
                                                        print(vendorDropDownId);
                                                      },
                                                      child: Icon(
                                                        Icons.cancel,
                                                        size: 25,
                                                      ))
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "${(vendorDropDownName != null) ? vendorDropDownName : 'Please Select'}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ))),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Order Date",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  showDate == true
                                      ? GestureDetector(
                                          onTap: () async {
                                            // vendorDropDownName = null;
                                            // vendorDropDownId = 0;
                                            startDate = "";
                                            endDate = "";
                                            showDate = false;

                                            setState(() {});
                                            // print(vendorDropDownId);
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            size: 25,
                                          ))
                                      : Text("")
                                ],
                              ),
                              _buildCalendarDialogButton()
                            ],
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3498CC),
                                ),
                                onPressed: () async {
                                  showLoaderDialog(context);
                                  showSelectContainerButton = false;
                                  idList = [];
                                  purchaseOrderData = await searchData();

                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: const Text(
                                  "Search",
                                  style: TextStyle(fontSize: 18),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                const Divider(
                  height: 1,
                  thickness: 2,
                  color: Color(0xFF3498CC),
                ),
                showSelectContainerButton
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: SizedBox(
                            child: Container(
                          height: 40,
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                              color: const Color(0xFF3498CC),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "${selctedNumber} Selected",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              showRemoveBtn
                                  ? GestureDetector(
                                      onTap: () => {
                                            removeAll(),
                                            print(idList),
                                          },
                                      child: Container(
                                        width: 105,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: const Color(0xffe6f7fd),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Center(
                                          child: Text(
                                            "Remove All",
                                            style: TextStyle(
                                                color: Color(0xFF3498CC),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ))
                                  : GestureDetector(
                                      onTap: () => {
                                            selectAll(),
                                          },
                                      child: Container(
                                        width: 100,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: const Color(0xffe6f7fd),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Center(
                                          child: Text(
                                            "Select All",
                                            style: TextStyle(
                                                color: Color(0xFF3498CC),
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ))
                            ],
                          ),
                        )),
                      )
                    : const SizedBox.shrink(),
                Expanded(
                    child: showListDetail
                        ? const Center(
                            child: Text(
                            "Welcome",
                            style: TextStyle(
                              fontSize: 30,
                              color: Color(0xFF3498CC),
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                        : loadListItem
                            ? const Center()
                            : purchaseOrderData?.purchaseOrderList?.length ==
                                        0 ||
                                    purchaseOrderData
                                            ?.purchaseOrderList?.length ==
                                        null
                                ? Center(
                                    child: Column(
                                    children: [
                                      Lottie.asset(
                                          'assets/NotFoundLottie.json'),
                                      Text(
                                        "PO Not Found",
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Color(0xFF3498CC),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ))
                                : Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                            itemCount: purchaseOrderData!
                                                    .purchaseOrderList!.length +
                                                1,
                                            itemBuilder: (context, index) {
                                              if (purchaseOrderData!
                                                      .purchaseOrderList!
                                                      .length ==
                                                  index) {
                                                return Lottie.asset(
                                                    'assets/Polite Chicky.json',
                                                    fit: BoxFit.cover);
                                              } else {
                                                return GestureDetector(
                                                    onLongPress: () {
                                                      selectedItem(purchaseOrderData
                                                          ?.purchaseOrderList?[
                                                              index]
                                                          .odooPurchaseOrderId);
                                                      setState(() {
                                                        selectMode = true;
                                                      });
                                                    },
                                                    onTap: () async {
                                                      if (selectMode &&
                                                          idList.length != 0) {
                                                        selectedItem(purchaseOrderData
                                                            ?.purchaseOrderList?[
                                                                index]
                                                            .odooPurchaseOrderId);
                                                      } else {
                                                        selectMode = false;
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ListTile(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              color: idList.contains(purchaseOrderData
                                                                      ?.purchaseOrderList?[
                                                                          index]
                                                                      .odooPurchaseOrderId)
                                                                  ? Color(
                                                                      0xFF3498CC)
                                                                  : Color
                                                                      .fromARGB(
                                                                          52,
                                                                          10,
                                                                          9,
                                                                          9),
                                                              width: idList.contains(purchaseOrderData
                                                                      ?.purchaseOrderList?[
                                                                          index]
                                                                      .odooPurchaseOrderId)
                                                                  ? 2
                                                                  : 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(0),
                                                        ),
                                                        tileColor: const Color(
                                                            0xffe6f7fd),
                                                        title: Column(
                                                            children: [
                                                              Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "${purchaseOrderData?.purchaseOrderList?[index].name}",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                    IconButton(
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .arrow_forward_ios,
                                                                        size:
                                                                            20,
                                                                        color: Color(
                                                                            0xFF3498CC),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        showLoaderDialog(
                                                                            context);
                                                                        purchaseCompleteData = await completeData(purchaseOrderData
                                                                            ?.purchaseOrderList?[index]
                                                                            .odooPurchaseOrderId);
                                                                        Navigator.pop(
                                                                            context);
                                                                        final value =
                                                                            await Navigator.push(
                                                                          context
                                                                              as BuildContext,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                FormSheet(completeData: purchaseCompleteData!),
                                                                          ),
                                                                        );
                                                                        if (value ==
                                                                            "Approve Success") {
                                                                          idList =
                                                                              [];
                                                                          showSelectContainerButton =
                                                                              false;
                                                                          Flushbar(
                                                                            message:
                                                                                value.toString(),
                                                                            messageColor: value.toString() == "Approve Success"
                                                                                ? Colors.green
                                                                                : Colors.white,
                                                                            backgroundColor: value.toString() == "Approve Success"
                                                                                ? Colors.white
                                                                                : Colors.black,
                                                                            flushbarPosition:
                                                                                FlushbarPosition.TOP,
                                                                            margin:
                                                                                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            duration:
                                                                                const Duration(milliseconds: 3000),
                                                                            icon:
                                                                                Icon(
                                                                              value.toString() == "Approve Success" ? Icons.check_circle_rounded : Icons.error,
                                                                              color: value.toString() == "Approve Success" ? Colors.green : Colors.white,
                                                                            ),
                                                                            // margin: EdgetInsets.symmetric(horizontal:20,vertical:20),
                                                                          ).show(
                                                                              context);

                                                                          purchaseOrderData =
                                                                              await searchData();
                                                                          setState(
                                                                              () {});
                                                                        } else if (value ==
                                                                            "PO Cancelled") {
                                                                          idList =
                                                                              [];
                                                                          showSelectContainerButton =
                                                                              false;
                                                                          Flushbar(
                                                                            message:
                                                                                value.toString(),
                                                                            messageColor:
                                                                                Colors.green,
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                            flushbarPosition:
                                                                                FlushbarPosition.TOP,
                                                                            margin:
                                                                                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            duration:
                                                                                const Duration(milliseconds: 3000),
                                                                            icon:
                                                                                Icon(
                                                                              Icons.check_circle_rounded,
                                                                              color: Colors.green,
                                                                            ),
                                                                            // margin: EdgetInsets.symmetric(horizontal:20,vertical:20),
                                                                          ).show(
                                                                              context);

                                                                          purchaseOrderData =
                                                                              await searchData();
                                                                          setState(
                                                                              () {});
                                                                        }
                                                                        print(
                                                                            value);
                                                                      },
                                                                    ),
                                                                  ]),
                                                              const Divider(
                                                                height: 1,
                                                                color: Color
                                                                    .fromARGB(
                                                                        52,
                                                                        10,
                                                                        9,
                                                                        9),
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            0,
                                                                            15,
                                                                            0,
                                                                            5),
                                                                    child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              purchaseOrderData?.purchaseOrderList?[index].dateOrder.runtimeType != String
                                                                                  ? Text(
                                                                                      "NA",
                                                                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                                                                    )
                                                                                  : Text(
                                                                                      "${orderDate(purchaseOrderData?.purchaseOrderList![index].dateOrder?.substring(0, 10))}",
                                                                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                                                                    ),
                                                                              Padding(
                                                                                padding: EdgeInsets.fromLTRB(0, 3, 0, 8),
                                                                                child: Text(
                                                                                  "(Order Date)",
                                                                                  style: TextStyle(
                                                                                    fontSize: 13,
                                                                                    color: Colors.grey,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Expanded(
                                                                              child: Padding(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                10,
                                                                                0,
                                                                                10,
                                                                                0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  "${purchaseOrderData?.purchaseOrderList?[index].vendor}",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                    fontSize: 11,
                                                                                    color: Color.fromARGB(234, 27, 25, 25),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )),
                                                                          Column(
                                                                            children: [
                                                                              purchaseOrderData?.purchaseOrderList?[index].scheduledDate.runtimeType != String
                                                                                  ? Text(
                                                                                      "NA",
                                                                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                                                                    )
                                                                                  : Text(
                                                                                      "${scheduleDate(purchaseOrderData?.purchaseOrderList?[index].scheduledDate?.substring(0, 10))}",
                                                                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                                                                    ),
                                                                              Padding(
                                                                                padding: EdgeInsets.fromLTRB(0, 3, 0, 8),
                                                                                child: Text(
                                                                                  "(Schedule Date)",
                                                                                  style: TextStyle(
                                                                                    fontSize: 13,
                                                                                    color: Colors.grey,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                  Divider(
                                                                    height: 1,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            52,
                                                                            10,
                                                                            9,
                                                                            9),
                                                                  ),
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            purchaseOrderData?.purchaseOrderList?[index].amount == null || purchaseOrderData?.purchaseOrderList?[index].amount == 0.0
                                                                                ? Text("0.00")
                                                                                : Text(
                                                                                    "₹ ${purchaseOrderData?.purchaseOrderList?[index].amount?.toStringAsFixed(2)}",
                                                                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                            Text(
                                                                              "(Amount)",
                                                                              style: TextStyle(
                                                                                fontSize: 13,
                                                                                color: Colors.grey,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        TextButton(
                                                                            onPressed:
                                                                                () async {
                                                                              idList.add(purchaseOrderData!.purchaseOrderList![index].odooPurchaseOrderId!);
                                                                              showLoaderDialog(context);

                                                                              await approveData();

                                                                              showSelectContainerButton = false;
                                                                              if (approveResult == "Po Approved") {
                                                                                purchaseOrderData = await searchData();

                                                                                Flushbar(
                                                                                  message: approveResult.toString(),
                                                                                  messageColor: Colors.green,
                                                                                  backgroundColor: Colors.white,
                                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  duration: const Duration(milliseconds: 3000),
                                                                                  icon: Icon(
                                                                                    Icons.check_circle_rounded,
                                                                                    color: Colors.green,
                                                                                  ),
                                                                                ).show(context);
                                                                              }

                                                                              idList.clear();
                                                                              setState(() {});
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              "Approve",
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color(0xFF3498CC),
                                                                              ),
                                                                            ))
                                                                      ]),
                                                                ],
                                                              ),
                                                            ]),
                                                      ),
                                                    ));
                                              }
                                            }),
                                      ),
                                    ],
                                  )),
              ],
            ),
            floatingActionButton: showSelectContainerButton
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF3498CC),
                    ),
                    onPressed: () async {
                      showLoaderDialog(context);
                      await approveData();

                      idList = [];
                      showSelectContainerButton = false;

                      if (approveResult == "Po Approved") {
                        purchaseOrderData = await searchData();
                        Flushbar(
                          message: approveResult.toString(),
                          messageColor: Colors.green,
                          backgroundColor: Colors.white,
                          flushbarPosition: FlushbarPosition.TOP,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          borderRadius: BorderRadius.circular(5),
                          duration: const Duration(milliseconds: 3000),
                          icon: Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                          ),
                        ).show(context);
                      }
                      setState(() {});
                      print(idList);
                    },
                    child: const Text('Approve',
                        style: TextStyle(color: Colors.white)))
                : SizedBox.shrink());
  }
}
