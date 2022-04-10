import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/pages/payment.dart';

class PaymentLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => ['/payment'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('payment'),
          title: 'Payment',
          child: PaymentPage(),
          type: BeamPageType.noTransition,
        ),
      ];
}
