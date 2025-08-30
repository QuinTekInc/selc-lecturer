
import 'package:flutter/material.dart';
import 'package:selc_lecturer/components/text.dart';

class CustomButton extends StatelessWidget {

  final Widget? child;
  final EdgeInsets padding;
  final Function() onPressed;
  final Color? backgroundColor;
  final double height;
  final double? width;
  final bool disable;

  const CustomButton({
    super.key,
    required this.onPressed,
    this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.backgroundColor,
    this.height = 50,
    this.width,
    this.disable = false
  });

  //button with only text in it.
  factory CustomButton.withText(String text, {
    required Function() onPressed, 
    double? width, bool disable = false
  }){

    return CustomButton(
      onPressed: onPressed,
      width: width,
      disable: disable,
      child: CustomText(text, fontSize: 16, textColor: Colors.white,),
    );
  }


  //button with text and an Icon
  factory CustomButton.withIcon(String text, {
    required Function() onPressed, 
    required IconData icon, 
    Color iconColor = Colors.white,
    double width = 135,
    bool disable = false
  }){

    return CustomButton(
      onPressed: onPressed,
      width: 70, 
      disable: disable,
      child: SizedBox(
        width: width,
        child: Row( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            CustomText(text, fontSize: 16, textColor: Colors.white, padding: EdgeInsets.zero,),
            const SizedBox(width: 5,),
            Icon(icon, color: iconColor,)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: padding,

      child: IgnorePointer(
        ignoring: disable,

        child: MaterialButton(
          onPressed: onPressed,
          height: height,
          minWidth: width,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          color: backgroundColor ?? Colors.green.shade400,
          child: child,
        ),

      ),
    );
  }
}



//todo: custom checkBoxes.
class CustomCheckBox extends StatelessWidget {

  final bool value;
  final String text;
  final Function(bool? newValue)? onChanged;
  final MainAxisAlignment alignment;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.text,
    this.onChanged,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(  
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value, 
          onChanged: onChanged,
          activeColor: Colors.green,
        ),
        CustomText(text, fontSize: 14, fontWeight: FontWeight.w500)
      ],
    );
  }
}