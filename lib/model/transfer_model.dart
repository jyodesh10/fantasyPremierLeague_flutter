// To parse this JSON data, do
//
//     final transferModel = transferModelFromJson(jsonString);

import 'dart:convert';

List<TransferModel> transferModelFromJson(String str) => List<TransferModel>.from(json.decode(str).map((x) => TransferModel.fromJson(x)));

String transferModelToJson(List<TransferModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransferModel {
    int elementIn;
    int elementInCost;
    int elementOut;
    int elementOutCost;
    int entry;
    int event;
    DateTime time;

    TransferModel({
        required this.elementIn,
        required this.elementInCost,
        required this.elementOut,
        required this.elementOutCost,
        required this.entry,
        required this.event,
        required this.time,
    });

    factory TransferModel.fromJson(Map<String, dynamic> json) => TransferModel(
        elementIn: json["element_in"],
        elementInCost: json["element_in_cost"],
        elementOut: json["element_out"],
        elementOutCost: json["element_out_cost"],
        entry: json["entry"],
        event: json["event"],
        time: DateTime.parse(json["time"]),
    );

    Map<String, dynamic> toJson() => {
        "element_in": elementIn,
        "element_in_cost": elementInCost,
        "element_out": elementOut,
        "element_out_cost": elementOutCost,
        "entry": entry,
        "event": event,
        "time": time.toIso8601String(),
    };
}
