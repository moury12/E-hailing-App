import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/pagination_loading_widget.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerPage extends StatefulWidget {


  const PdfViewerPage({super.key});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("E-Hailing Vehicle Permit")),
      body: AccountInformationController.to.pdfController == null
          ? PaginationLoadingWidget()
          : PdfViewPinch(
       controller:  AccountInformationController.to.pdfController!,

        backgroundDecoration:BoxDecoration(color: AppColors.kScaffoldBackgroundColor,

      ),
    ));
  }
}
