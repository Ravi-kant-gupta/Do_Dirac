class PurchaseOrderData {
  List<PurchaseOrderList>? purchaseOrderList;
  String? result;

  PurchaseOrderData({this.purchaseOrderList, this.result});

  factory PurchaseOrderData.fromJson(Map<String, dynamic> json) =>
      PurchaseOrderData(
        result: json["result"],
        purchaseOrderList: List<PurchaseOrderList>.from(
            json["Purchase_order_list"]!
                .map((x) => PurchaseOrderList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "Purchase_order_list":
            List<dynamic>.from(purchaseOrderList!.map((x) => x.toJson())),
      };
}

class PurchaseOrderList {
  int? odooPurchaseOrderId;
  double? amountTax;
  double? amount;

  String? vendor;
  String? name;
  String? scheduledDate;
  String? so;
  String? dateOrder;
  String? paymentTerms;

  PurchaseOrderList(
      {this.odooPurchaseOrderId,
      this.amountTax,
      this.amount,
      this.vendor,
      this.name,
      this.scheduledDate,
      this.so,
      this.dateOrder,
      this.paymentTerms});

  factory PurchaseOrderList.fromJson(Map<String, dynamic> json) =>
      PurchaseOrderList(
        odooPurchaseOrderId: json['odoo_purchase_order_id'],
        amountTax: json['amount_tax'],
        amount: json['amount'],
        vendor: json['vendor'],
        name: json['name'],
        scheduledDate: json['scheduled_date'].runtimeType != String
            ? null
            : json['scheduled_date'],
        so: json['so'],
        dateOrder: json['date_order'].runtimeType != String
            ? null
            : json['date_order'],
        paymentTerms: json['payment_terms'],
      );

  Map<String, dynamic> toJson() => {
        'odoo_purchase_order_id': odooPurchaseOrderId,
        'amount_tax': amountTax,
        'amount': amount,
        'vendor': vendor,
        'name': name,
        'scheduled_date': scheduledDate,
        'so': so,
        'date_order': dateOrder,
        'payment_terms': paymentTerms,
      };
}
