import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/pages/profile.dart';

class ProfileLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => ['/profile/:profileId'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('profile'),
          title: 'Profile',
          child: ProfilePage(),
          type: BeamPageType.noTransition,
        ),
      ];
}
