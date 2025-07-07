import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerMessageCard extends StatelessWidget {
  final bool sendByMe;

  const ShimmerMessageCard({super.key, this.sendByMe = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!sendByMe)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Shimmer.fromColors(
                baseColor: const Color(0xffF3E8FF),
                highlightColor: const Color(0xffEEDDFF),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: sendByMe ? 0 : 8,
                    right: sendByMe ? 8 : 0,
                  ),
                  constraints: BoxConstraints(maxWidth: Get.width * 0.8),
                  child: Shimmer.fromColors(
                    baseColor: const Color(0xffF3E8FF),
                    highlightColor: const Color(0xffEEDDFF),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                    left: sendByMe ? 0 : 8,
                    right: sendByMe ? 8 : 0,
                  ),
                  child: Shimmer.fromColors(
                    baseColor: const Color(0xffF3E8FF),
                    highlightColor: const Color(0xffEEDDFF),
                    child: Container(
                      height: 15,
                      width: 60,
                      color: Colors.white,
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

class ShimmerChatList extends StatelessWidget {
  const ShimmerChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (index) => ShimmerMessageCard(sendByMe: index % 2 == 0),
      ),
    );
  }
}
