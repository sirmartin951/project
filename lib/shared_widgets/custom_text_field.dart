import 'package:flutter/material.dart';




class  CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? data;
  bool?  isObscure;
  final  String? hintText;
  bool?  enabled;
  int?   maxlines;

  CustomTextField({
    this.controller,
    this.data,
    this.enabled,
    this.hintText,
    this.isObscure,
    this.maxlines
});

  @override
  Widget build(BuildContext context) {
        return Container(
      decoration: const BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      child: TextFormField(

        enabled: enabled,
        controller: controller,
        obscureText: isObscure!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(

          border: InputBorder.none,
          prefixIcon: Icon(data,color: const Color(0XFFb33939),),
          focusColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0XFFb33939))
        ),
      ),
    );
  }
}
