import 'package:flutter/material.dart';

bool checkMediaWidth(BuildContext context, double width) {
  return MediaQuery.of(context).size.width < width;
}

bool checkMediaHeight(BuildContext context, double height) {
  return MediaQuery.of(context).size.height < height;
}

double getMediaWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getMediaHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

