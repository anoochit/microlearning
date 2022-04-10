import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:microlearning/themes/theme.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HeroWidget extends StatefulWidget {
  HeroWidget({Key? key, required this.title, required this.description, required this.image, required this.onTap})
      : super(key: key);

  final String title;
  final String description;
  final String image;
  final VoidCallback onTap;

  @override
  _HeroWidgetState createState() => _HeroWidgetState();
}

class _HeroWidgetState extends State<HeroWidget> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.isDesktop) {
          // desktop size
          log('desktop size');
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // text
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 8.0),

                    // description
                    Text(widget.description),
                    const SizedBox(height: 16.0),

                    // button
                    ElevatedButton(
                      style: kElevatedButtonStyle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "ลงทะเบียน",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                        ),
                      ),
                      onPressed: () => widget.onTap(),
                    )
                  ],
                ),
              ),
              // image
              SizedBox(width: MediaQuery.of(context).size.width * 0.40, child: Image.asset(widget.image)),
            ],
          );
        } else if (sizingInformation.isTablet) {
          // tablet size
          log('tablet size');
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // text
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 8.0),

                    // description
                    Text(widget.description),
                    const SizedBox(height: 16.0),

                    // button
                    ElevatedButton(
                      style: kElevatedButtonStyle,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "ลงทะเบียน",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                        ),
                      ),
                      onPressed: () => widget.onTap(),
                    )
                  ],
                ),
              ),
              // image
              SizedBox(width: MediaQuery.of(context).size.width * 0.40, child: Image.asset(widget.image)),
            ],
          );
        } else {
          // mobile size
          log('mobile size');
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // image
                Image.asset(widget.image),

                // text
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 8.0),

                // description
                Text(widget.description),
                const SizedBox(height: 16.0),

                // button
                ElevatedButton(
                  style: kElevatedButtonStyle,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "ลงทะเบียน",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                    ),
                  ),
                  onPressed: () => widget.onTap(),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
