class CompleteData {
  String? vendor;
  double? tax;
  int? purchaseOrderId;
  String? result;
  String? scheduledDate;
  String? dateOrder;
  String? paymentTerms;
  double? untaxedAmount;
  double? total;
  String? name;
  double? amountTax;
  double? amount;
  String? so;
  String? createdby;
  String? type;
  List<PurchaseOrderLineList>? purchaseOrderLineList;

  CompleteData(
      {this.vendor,
      this.tax,
      this.purchaseOrderId,
      this.result,
      this.scheduledDate,
      this.dateOrder,
      this.paymentTerms,
      this.untaxedAmount,
      this.total,
      this.name,
      this.amountTax,
      this.amount,
      this.so,
      this.purchaseOrderLineList,
      this.createdby,
      this.type});

  factory CompleteData.fromJson(Map<String, dynamic> json) => CompleteData(
        vendor: json['vendor'],
        tax: json['tax'],
        purchaseOrderId: json['purchase_order_id'],
        result: json['result'],
        scheduledDate: json['scheduled_date'].runtimeType != String
            ? null
            : json['scheduled_date'],
        dateOrder: json['date_order'].runtimeType != String
            ? null
            : json['date_order'],
        paymentTerms: json['payment_terms'],
        untaxedAmount: json['untaxed_amount'],
        total: json['total'],
        name: json['name'],
        amountTax: json['amount_tax'],
        amount: json['amount'],
        so: json['so'],
        createdby: json['created_by'],
        type: json['type'],
        purchaseOrderLineList: List<PurchaseOrderLineList>.from(
            json["Purchase_order_line_list"]!
                .map((x) => PurchaseOrderLineList.fromJson(x))),
        // if (json['Purchase_order_line_list'] != null) {
        //   purchaseOrderLineList =  List<PurchaseOrderLineList>();
        //   json['Purchase_order_line_list'].forEach((v) {
        //     purchaseOrderLineList.add(new PurchaseOrderLineList.fromJson(v));
        //   });
        // }
      );

  Map<String, dynamic> toJson() => {
        'vendor': vendor,
        'tax': tax,
        'purchase_order_id': purchaseOrderId,
        'result': result,
        'scheduled_date': scheduledDate,
        'date_order': dateOrder,
        'payment_terms': paymentTerms,
        'untaxed_amount': untaxedAmount,
        'total': total,
        'name': name,
        'amount_tax': amountTax,
        'amount': amount,
        'so': so,
        "created_by": createdby,
        "type": type,
        'Purchase_order_line_list':
            List<dynamic>.from(purchaseOrderLineList!.map((x) => x.toJson())),
      };
}

class PurchaseOrderLineList {
  double? sQty;
  String? finalProductId;
  String? productId;
  double? unitPrice;
  String? sUnit;
  double? qty;
  String? image;
  String? uom;
  String? description;
  String? size;
  int? subtotal;

  PurchaseOrderLineList({
    this.sQty,
    this.finalProductId,
    this.productId,
    this.unitPrice,
    this.sUnit,
    this.qty,
    this.image,
    this.uom,
    this.description,
    this.size,
    this.subtotal,
  });

  factory PurchaseOrderLineList.fromJson(Map<String, dynamic> json) =>
      PurchaseOrderLineList(
        sQty: json['s_qty'],
        finalProductId: json['final_product_id'],
        productId: json['product_id'],
        unitPrice: json['unit_price'],
        sUnit: json['s_unit'],
        qty: json['qty'],
        image: json['image'],
        uom: json['uom'],
        description: json['description'],
        size: json['size'],
        subtotal: json['sub_total'],
      );

  Map<String, dynamic> toJson() => {
        's_qty': sQty,
        'final_product_id': finalProductId,
        'product_id': productId,
        'unit_price': unitPrice,
        's_unit': sUnit,
        'qty': qty,
        'image': image,
        'uom': uom,
        'description': description,
        'size': size,
        'sub_total': subtotal,
      };
}
