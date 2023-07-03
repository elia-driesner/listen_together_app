import 'package:flutter/material.dart';

class InputForm extends StatefulWidget {
  InputForm({
    Key? key,
    required this.size,
    required this.text,
    required this.controller,
    required this.obscureText,
    required this.isPassword,
    this.prefixIcon,
  }) : super(key: key);
  late List<double> size;
  late String text;
  late var controller;
  late bool obscureText;
  late bool isPassword;
  late Widget? prefixIcon;

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  IconButton? getIcon() {
    if (widget.isPassword) {
      return IconButton(
          icon: widget.obscureText
              ? Icon(Icons.visibility_off_outlined,
                  color: Theme.of(context).primaryColorDark)
              : Icon(Icons.visibility_outlined,
                  color: Theme.of(context).primaryColorDark),
          onPressed: () =>
              {setState(() => widget.obscureText = !widget.obscureText)});
    }
    return null;
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
        width: widget.size[0],
        height: widget.size[1],
        child: TextField(
          controller: widget.controller,
          autofocus: false,
          cursorColor: Theme.of(context).primaryColorDark,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
              prefixIcon: widget.prefixIcon ?? null,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      width: 2, color: Theme.of(context).primaryColorDark)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      width: 2, color: Theme.of(context).primaryColorDark)),
              filled: true,
              fillColor: Theme.of(context).primaryColorLight,
              hintText: widget.text,
              hintStyle: TextStyle(color: Theme.of(context).primaryColorDark),
              suffixIcon: getIcon()),
        ),
      ),
    );
  }
}
