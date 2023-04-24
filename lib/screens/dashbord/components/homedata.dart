
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class RecentFiels extends StatelessWidget {
  const RecentFiels({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: double.infinity,
              child: Text("Welcome to G4SCam",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ))),
          SizedBox(
              width: double.infinity,
              child: Text("Your number one security choice",
                style: Theme.of(context).textTheme.subtitle1,)),
          Text(
            'On this platform we use the most poweful techniques in order for your environment to be completely'
                'secure enough'
                'So you do not have to worry about anything at all while we take charhe of it'
          )
        ],
      ),
    );
  }
}
