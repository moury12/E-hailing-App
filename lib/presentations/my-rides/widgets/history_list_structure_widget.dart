import 'package:flutter/cupertino.dart';

import 'my_rides_history_card_item_widget.dart';

class HistoryListStructureWidget extends StatelessWidget {
  final int length;

  const HistoryListStructureWidget({super.key, required this.length});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        length,
        (index) => MyRidesHistoryCardItemWidget(),
      ),
    );
  }
}
