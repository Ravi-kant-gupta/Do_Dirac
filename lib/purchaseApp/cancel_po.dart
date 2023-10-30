class CancelData {
  String? result;

  CancelData({this.result});

  factory CancelData.fromJson(Map<String, dynamic> json) => CancelData(
        result: json['result'],
      );

  Map<String, dynamic> toJson() => {
        'result': result,
      };
}
