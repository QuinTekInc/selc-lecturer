
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







class CustomDropdownButton<T> extends StatefulWidget {

  final List<T> items;
  final DropdownController controller;
  final Function(T? newValue)? onChanged;
  final String? hint;
  final IconData? icon;
  final Color? backgroundColor;

  const CustomDropdownButton({
    super.key,
    required this.controller,
    this.hint,
    this.icon,
    required this.items,
    required this.onChanged,
    this.backgroundColor
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState<T>();
}

class _CustomDropdownButtonState<T> extends State<CustomDropdownButton<T>> {

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 8),

      decoration: BoxDecoration(

          color: widget.backgroundColor ?? Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),

          border: Border.all(
              color: Colors.black26,
              width: 1.5
          )
      ),

      child: DropdownButton<T>(

          value: widget.controller.value,
          icon: Icon(
            widget.icon ?? Icons.arrow_drop_down,
            color: Colors.green.shade400,
            size: widget.icon == null ? 28 : null,
          ),
          isExpanded: true,
          isDense: true,

          underline: SizedBox(),

          hint: widget.hint != null ? CustomText(
            widget.hint!,
            fontWeight: FontWeight.w600,
            textColor: Colors.black38,
          ) : null,

          items: List<DropdownMenuItem<T>>.generate(
              widget.items.length,
                  (index) => DropdownMenuItem<T>(
                value: widget.items[index],
                child: CustomText(
                    widget.items[index].toString()
                ),
              )
          ),


          borderRadius: BorderRadius.circular(12),
          //Colors.grey.shade200
          dropdownColor: Colors.grey.shade200,
          focusColor: Colors.green.shade100,

          onChanged: (newValue) {

            setState(() => widget.controller.value = newValue);


            if(widget.onChanged != null){
              widget.onChanged!.call(newValue);
            }

          }
      ),
    );
  }
}


class DropdownController<T>{

  T? value;


  DropdownController({this.value});

  void reset() => value = null;

}

