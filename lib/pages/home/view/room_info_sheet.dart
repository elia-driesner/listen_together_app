import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:listen_together_app/widgets/widgets.dart';
import 'package:listen_together_app/services/functions/functions.dart';
import 'package:websockets/websockets.dart';
import './../services/listener.dart';
import 'package:listen_together_app/services/data/storage.dart';

class RoomView {
  static Map roomInfo = {};
  static late var homeContext;

  static Future build(BuildContext context) {
    homeContext = context;
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      0, MediaQuery.of(context).size.height * 0.05, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(
                                    MediaQuery.of(context).size.width * 0.05,
                                    0,
                                    0,
                                    0),
                                child: Column(children: [
                                  Container(
                                      child: Text('Listeners',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              fontSize: 23)))
                                ])),
                            Container(
                                margin: EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    MediaQuery.of(context).size.width * 0.05,
                                    0),
                                child: Column(children: [
                                  Container(
                                      child: Text('Host',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              fontSize: 23)))
                                ])),
                          ]),
                      Container(child: Row(children: [])),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0,
                              MediaQuery.of(context).size.height * 0.05)),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
