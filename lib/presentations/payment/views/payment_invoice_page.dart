import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_current_trip_model.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_response_model.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

class PaymentInvoicePage extends StatelessWidget {
  final dynamic rideModel;
  final bool isDriver;

  const PaymentInvoicePage({super.key, this.rideModel, required this.isDriver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invoice Preview")),
      body: Column(
        children: [
          Expanded(
            child: PdfPreview(
              build: (format) {
                return generateInvoicePDF(
                  rideModel: rideModel,
                  isDriver: isDriver,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<Uint8List> generateInvoicePDF({
  required dynamic rideModel,
  required bool isDriver,
}) async {
  // Fallback/default values
  String driverName = 'Unknown Driver';
  String driverImage = dummyProfileImage;
  String rating = '0.0';
  String cost = 'RM 0';
  String distance = '0 km';
  String dateTime = 'N/A';
  String? pickup;
  String? dropOff;
  String? rideType;
  String? duration;
  String? paymentMethod;

  // Logic to populate rideModel data
  if (rideModel is DriverCurrentTripModel) {
    final model = rideModel;
    // driverName = model.name ?? driverName;
    // driverImage = model.profileImage ?? driverImage;
    cost = 'RM ${model.estimatedFare?.toStringAsFixed(2) ?? "0"}';
    distance = '${((model.distance ?? 0) / 1000).toStringAsFixed(1)} km';
    dateTime = model.pickUpDate?.toString() ?? dateTime;
    pickup = model.pickUpAddress;
    dropOff = model.dropOffAddress;
    rideType = model.tripType;
    duration = model.duration?.toString() ?? "N/A";
    paymentMethod = model.paymentType;
  } else if (rideModel is TripResponseModel) {
    final model = rideModel;
    driverName = model.driver?.name ?? driverName;
    rating = model.driver?.rating?.toString() ?? rating;
    driverImage = model.driver?.profileImage ?? driverImage;
    cost = 'RM ${model.estimatedFare?.toStringAsFixed(2) ?? "0"}';
    distance = '${((model.distance ?? 0) / 1000).toStringAsFixed(1)} km';
    dateTime = model.pickUpDate?.toString() ?? dateTime;
    pickup = model.pickUpAddress;
    dropOff = model.dropOffAddress;
    rideType = model.tripType;
    duration = model.duration?.toString() ?? "N/A";
    paymentMethod = model.paymentType;
  }

  final pdf = pw.Document();
  final PdfPageFormat pageFormat = PdfPageFormat.a4;

  pdf.addPage(
    pw.Page(
      pageFormat: pageFormat,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  "DuDu Car",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "Ride Payment Details:",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Text("Ride Type: $rideType"),
              pw.Text("Order Date: $dateTime"),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text('Estimated Fare: $cost', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Driver: $driverName'),
              pw.Text('Driver Rating: $rating'),
              pw.SizedBox(height: 10),
              // pw.ImageProvider(driverImage), // Replace this with an actual image provider
              pw.SizedBox(height: 10),
              pw.Text('Pickup: $pickup'),
              pw.Text('Drop Off: $dropOff'),
              pw.Text('Duration: $duration'),
              pw.Text('Payment Method: $paymentMethod'),
            ],
          ),
        );
      },
    ),
  );

  return pdf.save();
}
