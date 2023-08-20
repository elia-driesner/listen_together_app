import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getLoadingIndicator() {
  Widget loadingIndicator;
  if (Platform.isAndroid) {
    loadingIndicator = const CircularProgressIndicator();
  } else {
    loadingIndicator = const CupertinoActivityIndicator(radius: 18);
  }
  return loadingIndicator;
}
