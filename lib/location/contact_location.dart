import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/pages/contact.dart';

class ContactLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => ['/contact'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('contact'),
          title: 'Contact',
          child: ContactPage(),
          type: BeamPageType.noTransition,
        ),
      ];
}
