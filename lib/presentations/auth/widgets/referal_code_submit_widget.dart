import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_textfield.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/presentations/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferalCodeSubmitWidget extends StatefulWidget {
  const ReferalCodeSubmitWidget({
    super.key,
  });

  @override
  State<ReferalCodeSubmitWidget> createState() =>
      _ReferalCodeSubmitWidgetState();
}

class _ReferalCodeSubmitWidgetState extends State<ReferalCodeSubmitWidget> {
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.8,
  
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          CustomTextField(title: AppStaticStrings.referalCode.tr,
            textEditingController: codeController,),
          Row(spacing: 8,
            children: [
              Expanded(child: CustomButton(onTap: () {
   final navigator = Navigator.of(Get.context!, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      }
              },title: AppStaticStrings.cancel.tr,)),
              Expanded(
                child: Obx(() {
                  return CustomButton(
                    isLoading: AuthController.to.isLoadingApply.value,
                    onTap: () async {
                    bool onSuccess =  await AuthController.to.applyReferalCode(code: codeController.text);
                    if(onSuccess){
                     
      final navigator = Navigator.of(Get.context!, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      }
    
                    }else{
                     final navigator = Navigator.of(Get.context!, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      }
                    }
                    }, title: AppStaticStrings.submit.tr,);
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
