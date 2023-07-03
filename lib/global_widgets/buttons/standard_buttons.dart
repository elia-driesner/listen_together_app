import 'package:flutter/material.dart';

class WhiteButton extends StatelessWidget {
  const WhiteButton(this.size, this.text, this.function, {super.key});
  final List<double> size;
  final String text;
  final VoidCallback function;

  void initState() {
    debugPrint('test');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(5, 5),
            color: Theme.of(context).primaryColorLight)
      ], borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        width: size[0],
        height: size[1],
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              side: BorderSide(
                  width: 2, color: Theme.of(context).primaryColorDark),
            ),
            onPressed: function,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Text(text,
                      style:
                          TextStyle(color: Theme.of(context).primaryColorDark)),
                ),
                Icon(Icons.arrow_forward,
                    color: Theme.of(context).primaryColorDark)
              ],
            )),
      ),
    );
  }
}

class DarkButton extends StatelessWidget {
  const DarkButton(this.size, this.text, this.function, {super.key});
  final List<double> size;
  final String text;
  final VoidCallback function;

  void initState() {
    debugPrint('test');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(5, 5),
            color: Theme.of(context).primaryColorDark)
      ], borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        width: size[0],
        height: size[1],
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColorDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              side: BorderSide(
                  width: 2, color: Theme.of(context).primaryColorDark),
            ),
            onPressed: function,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Text(text,
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight)),
                ),
                Icon(Icons.arrow_forward,
                    color: Theme.of(context).primaryColorLight)
              ],
            )),
      ),
    );
  }
}
