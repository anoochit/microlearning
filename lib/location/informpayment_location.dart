import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/pages/inform_payment.dart';

class InformPaymentLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => ['/inform_payment'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('inform_payment'),
          title: 'Inform Payment',
          child: InformPaymentPage(),
          type: BeamPageType.noTransition,
        ),
      ];
}
