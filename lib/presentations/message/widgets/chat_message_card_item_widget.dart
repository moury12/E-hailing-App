import 'package:e_hailing_app/core/api-client/api_service.dart';
import 'package:e_hailing_app/core/components/custom_button.dart';
import 'package:e_hailing_app/core/components/custom_button_tap.dart';
import 'package:e_hailing_app/core/components/custom_network_image.dart';
import 'package:e_hailing_app/core/components/custom_text_button.dart';
import 'package:e_hailing_app/core/constants/app_static_strings_constant.dart';
import 'package:e_hailing_app/core/constants/color_constants.dart';
import 'package:e_hailing_app/core/constants/padding_constant.dart';
import 'package:e_hailing_app/core/helper/helper_function.dart';
import 'package:e_hailing_app/core/service/translation-service/translation_service.dart';
import 'package:e_hailing_app/presentations/profile/controllers/account_information_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../model/chat_message_model.dart';

class ChatMessageCardItemWidget extends StatefulWidget {
  const ChatMessageCardItemWidget({
    super.key,
    required this.sendByMe,
    required this.message,
    required this.chatModel,
  });

  final bool sendByMe;
  final Messages message;
  final ChatModel chatModel;

  @override
  State<ChatMessageCardItemWidget> createState() =>
      _ChatMessageCardItemWidgetState();
}

class _ChatMessageCardItemWidgetState extends State<ChatMessageCardItemWidget> {
  Participants? getOtherUser() {
    final myId = AccountInformationController.to.userModel.value.sId;

    if (widget.chatModel.participants == null) return null;

    return widget.chatModel.participants!.firstWhere(
      (p) => p.sId != myId,
      orElse: () => Participants(name: 'Unknown', profileImage: null),
    );
  }

  late String displayedText;
  bool isTranslated = false;
  bool isTranslating = false;
  final TranslationService _translationService = TranslationService();
  @override
  void initState() {
    super.initState();
    displayedText = widget.message.message ?? '';
  }

  // Add this method to handle widget updates
  @override
  void didUpdateWidget(ChatMessageCardItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset displayed text when message changes
    if (oldWidget.message.sId != widget.message.sId ||
        oldWidget.message.message != widget.message.message) {
      displayedText = widget.message.message ?? '';
      isTranslated = false;
      isTranslating = false;
    }
  }

  Future<void> _handleTranslation() async {
    if (isTranslated) {
      // Revert to original
      setState(() {
        displayedText = widget.message.message ?? '';
        isTranslated = false;
      });
      return;
    }

    final currentLocale = Get.locale?.languageCode ?? 'en';
    String? translatedContent;

    // Check database/stored translations first
    switch (currentLocale) {
      case 'en':
        translatedContent = widget.message.english;
        break;
      case 'ms':
        translatedContent = widget.message.malay;
        break;
      default:
        translatedContent = null;
    }

    if (translatedContent != null && translatedContent.isNotEmpty) {
      setState(() {
        displayedText = translatedContent!;
        isTranslated = true;
      });
      return;
    }

    // Dynamic translation
    setState(() {
      isTranslating = true;
    });

    try {
      final result = await _translationService.translate(
        widget.message.message ?? '',
        currentLocale,
      );
      if (mounted) {
        setState(() {
          displayedText = result;
          isTranslated = true;
        });
      }
    } catch (e) {
      // Handle error (maybe show snackbar or revert)
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Translation failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isTranslating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isToday = isTodayFunction(widget.message.createdAt.toString());
    String createdDate =
        isToday
            ? formatTime(widget.message.createdAt.toString())
            : formatDate(widget.message.createdAt.toString());
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            widget.sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.sendByMe)
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: CustomNetworkImage(
                imageUrl:
                    "${ApiService().baseUrl}/${getOtherUser()!.profileImage.toString()}",
                height: 50.w,
                boxShape: BoxShape.circle,
                width: 50.w,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  widget.sendByMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                // Message container
                Container(
                  margin: EdgeInsets.only(
                    left: widget.sendByMe ? 0 : 8,
                    right: widget.sendByMe ? 8 : 0,
                  ),
                  constraints: BoxConstraints(maxWidth: Get.width * 0.8),
                  padding: paddingH12V8,

                  decoration: BoxDecoration(
                    color:
                        widget.sendByMe
                            ? AppColors.kLightGreyColor
                            : AppColors.kBrightBlueColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    displayedText,
                    style: TextStyle(
                      color:
                          widget.sendByMe
                              ? AppColors.kTextColor
                              : AppColors.kWhiteColor,
                      fontSize: 15,
                    ),
                  ),
                ),

                // Timestamp
                Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                    left: widget.sendByMe ? 0 : 8,
                    right: widget.sendByMe ? 8 : 0,
                  ),
                  child:
                      !widget.sendByMe
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                createdDate,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),

                              isTranslating
                                  ? SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: DefaultProgressIndicator(),
                                  )
                                  : CustomTextButton(
                                    fontSize: 12,
                                    title: AppStaticStrings.translate.tr,
                                    textColor:
                                        isTranslated
                                            ? Colors.grey
                                            : AppColors.kPrimaryColor,
                                    onPressed: _handleTranslation,
                                    // color: isTranslated ? Colors.blue : null,
                                  ),

                              // User avatar (only for user messages)
                            ],
                          )
                          : Text(
                            createdDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
