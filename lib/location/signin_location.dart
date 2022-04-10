import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/pages/signin.dart';

class SignInLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => ['/signin'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('signin'),
          title: 'SignIn',
          child: SignInPage(),
          type: BeamPageType.noTransition,
        ),
      ];
}
