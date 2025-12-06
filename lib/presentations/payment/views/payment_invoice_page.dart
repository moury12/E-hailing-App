import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_appbar.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/custom_space.dart';
import 'package:e_hailing_app/core/constants/custom_text.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/utils/variables.dart';
import 'package:e_hailing_app/presentations/driver-dashboard/model/driver_current_trip_model.dart';
import 'package:e_hailing_app/presentations/home/widgets/trip_details_card_widget.dart';
import 'package:e_hailing_app/presentations/navigation/views/navigation_page.dart';
import 'package:e_hailing_app/presentations/trip/model/trip_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';

class PaymentInvoicePage extends StatefulWidget {
  final dynamic rideModel;
  final bool isDriver;
  final bool fromCompleteTrip;
  const PaymentInvoicePage({
    super.key,
    this.rideModel,
    required this.isDriver,
    this.fromCompleteTrip = false,
  });

  @override
  State<PaymentInvoicePage> createState() => _PaymentInvoicePageState();
}

class _PaymentInvoicePageState extends State<PaymentInvoicePage> {
  final GlobalKey repaintKey = GlobalKey();

  // ---------------------------
  // MAIN BUTTON ACTION
  // ---------------------------
  Future<void> _downloadPDF() async {
    try {
      // Capture UI
      final boundary =
          repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      final uiImage = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);

      final pngBytes = byteData!.buffer.asUint8List();

      // Build PDF
      final pdf = pw.Document();
      final pdfImage = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build:
              (_) =>
                  pw.Center(child: pw.Image(pdfImage, fit: pw.BoxFit.contain)),
        ),
      );

      final Uint8List finalPdfBytes = await pdf.save();

      // Save to Android/iOS
      await savePdf(finalPdfBytes);
    } catch (e) {
      print("PDF ERROR: $e");
    }
  }

  // ---------------------------
  // CROSS PLATFORM SAVE
  // ---------------------------
  Future<void> savePdf(Uint8List pdfBytes) async {
    Directory? saveDir;

    if (Platform.isAndroid) {
      // Storage permission for Android 12 and below
      await Permission.storage.request();

      // Public downloads folder
      saveDir = Directory("/storage/emulated/0/Download");

      if (!saveDir.existsSync()) {
        saveDir = await getExternalStorageDirectory();
      }
    } else if (Platform.isIOS) {
      // iOS documents folder (visible in Files app)
      saveDir = await getApplicationDocumentsDirectory();
    }

    if (saveDir == null) {
      print("Save directory is null");
      return;
    }

    final filePath =
        "${saveDir.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf";

    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    // OPTIONAL: open the PDF after saving
    await OpenFilex.open(filePath);

    // Snackbar message
    showSnack(
      Platform.isAndroid
          ? "Saved to Downloads"
          : "Saved to Files → On My iPhone → YourApp",
    );

    print("PDF saved at: $filePath");
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---------------------------
  // UI BELOW
  // ---------------------------
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (widget.fromCompleteTrip) {
          Get.offAllNamed(
            NavigationPage.routeName,
            arguments: {'reconnectSocket': true},
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: "Payment Receipt "),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: RepaintBoundary(
                  key: repaintKey,
                  child: buildInvoiceUI(
                    isDriver: widget.isDriver,
                    rideModel: widget.rideModel,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _downloadPDF,
                icon: const Icon(Icons.download),
                label: const Text("Download PDF"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // YOUR UI DESIGN (Grab-style)
  Widget buildInvoiceUI({required dynamic rideModel, required bool isDriver}) {
    String driverName = 'Unknown Driver';
    String tripId = 'Unknown Trip';
    String driverImage = dummyProfileImage;
    String rating = '0.0';
    String cost = 'RM 0';
    String tollFee = 'RM 0';
    String extra = 'RM 0';
    String distance = '0 km';
    String dateTime = 'N/A';
    String paymentType = 'N/A';
    String? pickup;
    String? rideType;
    String? dropOff;
    String? duration;
    String? userName;
    String? userPic;
    String? title;

    if (rideModel is DriverCurrentTripModel) {
      final model = rideModel;
      // rating=isDriver?model.driver!.rating.toString():"0.0";
      driverName = model.user?.name ?? driverName;
      driverImage =
          model.user?.profileImage != null
              ? "${ApiService().baseUrl}/${model.user!.profileImage}"
              : driverImage;
      cost = 'RM ${model.estimatedFare?.toStringAsFixed(2) ?? "0"}';
      tollFee = 'RM ${model.tollFee?.toStringAsFixed(2) ?? "0"}';
      extra = 'RM ${model.extraCharge?.toStringAsFixed(2) ?? "0"}';
      distance = '${((model.distance ?? 0) / 1000).toStringAsFixed(1)} km';
      dateTime = formatDateTime(
        model.pickUpDate != null
            ? model.pickUpDate.toString()
            : model.createdAt.toString(),
      );
      pickup = model.pickUpAddress;
      rideType = model.tripType;
      duration = model.duration?.toString() ?? "N/A";
      dropOff = model.dropOffAddress;
      tripId = model.sId ?? "Unknown Trip"; // define this method below
      paymentType =
          model.paymentType ?? "Unknown Trip"; // define this method below
      userName = model.user?.name ?? "Unknown User"; // define this method below
      userPic =
          model.user?.profileImage ??
          "Unknown User"; // define this method below
// define this method below
      title = "User Info: ";
    } else if (rideModel is TripResponseModel) {
      final model = rideModel;

      driverName =
          (isDriver
              ? model.user?.name.toString()
              : model.driver?.name.toString()) ??
          AppStaticStrings.noDataFound;
      rating = !isDriver ? model.driver!.rating.toString() : "0.0";
      driverImage =
          model.driver?.profileImage != null
              ? "${ApiService().baseUrl}/${(isDriver ? model.user?.profileImage.toString() : model.driver?.profileImage.toString())}"
              : driverImage;
      cost = 'RM ${model.estimatedFare?.toStringAsFixed(2) ?? "0"}';
      tollFee = 'RM ${model.tollFee?.toStringAsFixed(2) ?? "0"}';
      extra = 'RM ${model.extraCharge?.toStringAsFixed(2) ?? "0"}';
      distance = '${((model.distance ?? 0) / 1000).toStringAsFixed(1)} km';
      dateTime = formatDateTime(
        model.pickUpDate != null
            ? model.pickUpDate.toString()
            : model.createdAt.toString(),
      );
      pickup = model.pickUpAddress;
      rideType = model.tripType;
      duration = model.duration?.toString() ?? "N/A";
      dropOff = model.dropOffAddress;
      tripId = model.sId ?? "Unknown Trip";
      paymentType = model.paymentType ?? "Unknown Trip";
      userName = model.driver?.name ?? "Unknown User";
      userPic = model.driver?.profileImage ?? "Unknown User";
      title = "Driver Info: ";
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Trip Type  ($rideType)",
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  "Payment Method: ($paymentType)",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Hope you enjoyed your ride!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Picked up on ${dateTime}",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Trip ID: ${tripId}",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Paid", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                " $cost",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const Divider(height: 30),
          const Text(
            "Breakdown",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Toll Fee"), Text("$tollFee")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Extra Charge"), Text("$extra")],
          ),
          space8H,
          Text(
            title ?? "null",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          space8H,
          Row(spacing: 12.w,
            children: [
              CustomNetworkImage(
                imageUrl: "${ApiService().baseUrl}/${userPic}",
                height: 50,
                width: 50,
                boxShape: BoxShape.circle,
              ),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: userName!),
                  // CustomText(text: email!)
                ],
              ))
            ],
          ),
          // Center(child: Text("Got an issue? We've got your back.")),
          space8H,

          const Text(
            "Your Trip",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "$distance • $duration mins",
            style: TextStyle(color: Colors.grey),
          ),

          FromToTimeLine(pickUpAddress: pickup, dropOffAddress: dropOff),
        ],
      ),
    );
  }
}
