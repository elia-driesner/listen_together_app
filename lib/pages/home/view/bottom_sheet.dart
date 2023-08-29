import 'package:flutter/material.dart';
import 'package:listen_together_app/widgets/widgets.dart';
import 'package:listen_together_app/services/functions/functions.dart';

class CustomBottomSheet {
  static TextEditingController idController = TextEditingController();
  static double nameMargin = 0.05;
  static List<double> nameSize = [0.8, 0.1];

  static String errorMessage = '';
  static Widget? loadingIndicator;
  static String roomID = '';

  static String text = "Start";

  static void moveName(setModalState) async {
    setModalState(() => {
          loadingIndicator = getLoadingIndicator(),
          nameMargin = 0.02,
          nameSize = [0.6, 0.09]
        });
  }

  static void moveNameBack(setModalState) async {
    setModalState(() => {
          loadingIndicator = null,
          nameMargin = 0.05,
          nameSize = [0.8, 0.1]
        });
  }

  static Future build(BuildContext context) {
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 120),
                      margin: EdgeInsets.fromLTRB(
                          0,
                          (MediaQuery.of(context).size.height * nameMargin),
                          0,
                          0),
                      child: AnimatedSize(
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 100),
                        child: BigInput(
                          size: [
                            (MediaQuery.of(context).size.width * nameSize[0])
                                .toDouble(),
                            (MediaQuery.of(context).size.height * nameSize[1])
                                .toDouble()
                          ],
                          text: "Room ID",
                          controller: idController,
                          obscureText: false,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0, 0, 0, MediaQuery.of(context).size.height * 0.05),
                      child: Column(
                        children: [
                          if (loadingIndicator == null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: AccentButton(
                                      [
                                        (MediaQuery.of(context).size.width *
                                                0.4)
                                            .toDouble(),
                                        (MediaQuery.of(context).size.height *
                                                0.062)
                                            .toDouble()
                                      ],
                                      text,
                                      () => moveName(setModalState),
                                    )),
                                Container(
                                    margin: EdgeInsets.fromLTRB(
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                        0,
                                        0,
                                        0),
                                    child: AccentButton(
                                      [
                                        (MediaQuery.of(context).size.width *
                                                0.4)
                                            .toDouble(),
                                        (MediaQuery.of(context).size.height *
                                                0.062)
                                            .toDouble()
                                      ],
                                      'Join',
                                      () => Navigator.pop(context),
                                    )),
                              ],
                            )
                          else
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: loadingIndicator)
                                ])
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}
