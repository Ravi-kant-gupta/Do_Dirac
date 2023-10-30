class ApproveData {
  String? result;

  ApproveData({this.result});

  factory ApproveData.fromJson(Map<String, dynamic> json) => ApproveData(
        result: json['result'],
      );

  Map<String, dynamic> toJson() => {
        'result': result,
      };
}
