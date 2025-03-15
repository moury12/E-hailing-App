import 'package:flutter/cupertino.dart';

import '../../navigation/widgets/google_map_widget.dart';

class TrackRidePage extends StatelessWidget {
  const TrackRidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GoogleMapWidget(),

      ],
    );
  }
}
