class vendorData {
  vendorData({this.supplierList, this.result});
  String? result;
  List<SupplierList>? supplierList;

  factory vendorData.fromJson(Map<String, dynamic> json) => vendorData(
        result: json["result"],
        supplierList: List<SupplierList>.from(
            json["supplier_list"]!.map((x) => SupplierList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "supplier_list":
            List<dynamic>.from(supplierList!.map((x) => x.toJson())),
      };

  // vendorData.fromJson(Map<String, dynamic> json) {
  //   if (json['supplier_list'] != null) {
  //     supplierList = List<SupplierList>();
  //     json['supplier_list'].forEach((v) {
  //       supplierList!.add( SupplierList.fromJson(v));
  //     });
  //   }
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data =  Map<String, dynamic>();
  //   if (this.supplierList != null) {
  //     data['supplier_list'] =
  //         this.supplierList!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class SupplierList {
  String? name;
  int? odooSupplierId;

  SupplierList({this.name, this.odooSupplierId});

  factory SupplierList.fromJson(Map<String, dynamic> json) => SupplierList(
        name: json["name"],
        odooSupplierId: json["odoo_supplier_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "odoo_supplier_id": odooSupplierId,
      };

  // SupplierList.fromJson(Map<String, dynamic> json) {
  //   name = json['name'];
  //   odooSupplierId = json['odoo_supplier_id'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data =  Map<String, dynamic>();
  //   data['name'] = this.name;
  //   data['odoo_supplier_id'] = this.odooSupplierId;
  //   return data;
  // }
}

// ADDRESS

class AddressData {
  AddressData({this.stockWarehouseList, this.result});

  String? result;
  List<StockWarehouseList>? stockWarehouseList;

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
        result: json["result"],
        stockWarehouseList: List<StockWarehouseList>.from(
            json["stock_warehouse_list"]
                .map((x) => StockWarehouseList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "stock_warehouse_list":
            List<dynamic>.from(stockWarehouseList!.map((x) => x.toJson())),
      };

  // AddressData.fromJson(Map<String, dynamic> json) {
  //   if (json['stock_warehouse_list'] != null) {
  //     stockWarehouseList = List<StockWarehouseList>();
  //     json['stock_warehouse_list'].forEach((v) {
  //       stockWarehouseList!.add(new StockWarehouseList.fromJson(v));
  //     });
  //   }
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.stockWarehouseList != null) {
  //     data['stock_warehouse_list'] =
  //         this.stockWarehouseList!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class StockWarehouseList {
  int? odooWarehouseId;
  String? name;

  StockWarehouseList({this.odooWarehouseId, this.name});

  StockWarehouseList.fromJson(Map<String, dynamic> json) {
    odooWarehouseId = json['odoo_warehouse_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['odoo_warehouse_id'] = this.odooWarehouseId;
    data['name'] = this.name;
    return data;
  }
}

//PurchaseData

class PurchaseData {
  List<PurchaseOrderList>? purchaseOrderList;
  String? result;
  PurchaseData({this.purchaseOrderList, this.result});

  factory PurchaseData.fromJson(Map<String, dynamic> json) => PurchaseData(
        result: json["result"],
        purchaseOrderList: List<PurchaseOrderList>.from(
            json["purchase_order_list"]!
                .map((x) => PurchaseOrderList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "purchase_order_list":
            List<dynamic>.from(purchaseOrderList!.map((x) => x.toJson())),
      };

  // PurchaseData.fromJson(Map<String, dynamic> json) {
  //   if (json['purchase_order_list'] != null) {
  //     purchaseOrderList = List<PurchaseOrderList>();
  //     json['purchase_order_list'].forEach((v) {
  //       purchaseOrderList!.add(new PurchaseOrderList.fromJson(v));
  //     });
  //   }
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.purchaseOrderList != null) {
  //     data['purchase_order_list'] =
  //         this.purchaseOrderList?.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class PurchaseOrderList {
  int? odooPurchaseTypeId;
  String? name;

  PurchaseOrderList({this.odooPurchaseTypeId, this.name});

  PurchaseOrderList.fromJson(Map<String, dynamic> json) {
    odooPurchaseTypeId = json['odoo_purchase_type_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['odoo_purchase_type_id'] = this.odooPurchaseTypeId;
    data['name'] = this.name;
    return data;
  }
}
