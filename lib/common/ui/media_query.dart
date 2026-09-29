import 'package:flutter/widgets.dart';

bool checkMediaWidth(BuildContext context, double width) =>
    MediaQuery.of(context).size.width < width;

double getMediaWidth(BuildContext context) => MediaQuery.of(context).size.width;

double getMediaHeight(BuildContext context) => MediaQuery.of(context).size.height;
