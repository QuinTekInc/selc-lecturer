
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomText extends StatelessWidget {

  final String text;
  final Color textColor;
  final double fontSize;
  final EdgeInsets padding;
  final TextAlign textAlignment;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softwrap;

  const CustomText(this.text, {
    super.key,
    this.textColor = Colors.black87,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.textAlignment = TextAlign.left,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.overflow,
    this.softwrap = true
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(  
        text,  
        softWrap: softwrap,
        textAlign: textAlignment,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(  
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          fontFamily: "Poppins"
        )
      ),
    );
  }
}


CustomText HeaderText(String text, {
  double fontSize = 20, 
  Color textColor = Colors.black87,
  TextAlign textAlignment = TextAlign.left
}) => CustomText(
  text,  
  textColor: textColor,
  fontWeight: FontWeight.bold,
  fontSize: fontSize,
  textAlignment: textAlignment,
);



//todo: custom textfield
class CustomTextField extends StatelessWidget {

  final TextEditingController controller;
  final String? hintText;
  final IconData? leadingIcon;
  final Function(String)? onChanged;
  final Widget? suffix;
  final int maxLines;
  final bool obscureText;
  final bool useLabel;
  final Color? fillColor;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlignment;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.leadingIcon,
    this.onChanged,
    this.maxLines = 1,
    this.suffix,
    this.obscureText = false,
    this.useLabel = false,
    this.fillColor,
    this.maxLength,
    this.inputFormatters,
    this.textAlignment = TextAlign.left,
    this.keyboardType = TextInputType.text
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),

      child: TextField(  
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        obscureText: obscureText,

        textAlign: textAlignment,

        inputFormatters: inputFormatters,

        onChanged: onChanged,

        decoration: InputDecoration(

          border: OutlineInputBorder(  
            borderSide: const BorderSide(),
            borderRadius: BorderRadius.circular(12),
          ),

          focusedBorder: OutlineInputBorder(  
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.green
            )
          ),

          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: "Poppins"
          ),

          filled: true,
          fillColor: fillColor,

          prefixIcon: leadingIcon == null ? null : Icon(leadingIcon),
          suffix: suffix,
          
          label: (!useLabel || hintText == null) ? null : CustomText(hintText!, fontSize: 15,)
        ),
      ),
    );
  }
}

//todo: custom password field

class CustomPasswordField extends StatefulWidget {

  final TextEditingController controller;
  final String? hintText;
  final bool useLabel;
  final void Function(String?)?  onChanged;

  const CustomPasswordField({
    super.key, 
    required this.controller,
    this.hintText,
    this.useLabel = true,
    this.onChanged
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {

  bool? obscureText;

  @override
  void initState() {
    super.initState();
    
    setState(() {
      obscureText = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      obscureText: obscureText!,
      leadingIcon: CupertinoIcons.lock,
      useLabel: widget.useLabel,
      suffix: buildTrailingIconButton(),
      onChanged: widget.onChanged,
    );
  }

  Widget buildTrailingIconButton() => GestureDetector(
    onTap: (){
      setState(() {
        obscureText = !obscureText!;
      });
    }, 
    child: Icon(obscureText! ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: Colors.green, size: 20,)
  );
}


//todo: build a text area.
class CustomTextArea extends StatelessWidget{

  final TextEditingController controller;
  final String? hintText;
  final int? maxLength;

  const CustomTextArea({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLength
  });


  @override
  Widget build(BuildContext context) {
    
    return CustomTextField(
      controller: controller,
      maxLines: 4,
      maxLength: maxLength,
      hintText: hintText,
      useLabel: false,
    );
  }

}



class OtpTextField extends StatefulWidget {

  final OtpTextEditingController controller;

  const OtpTextField({super.key, required this.controller});

  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {

  final List<TextEditingController> textControllers = List.generate(6, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: List<Widget>.generate(6, (index) {

          return Expanded(

              child: CustomTextField(
                controller: textControllers[index],
                textAlignment: TextAlign.center,
                keyboardType: TextInputType.number,

                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],

                onChanged: (newValue){

                  if(textControllers[index].text.length == 1 && index != 5) FocusScope.of(context).nextFocus();

                  String otpText = '';

                  //todo: collect the text from every text field in the Otp Text field controllers.
                  for(TextEditingController textController in textControllers){
                    otpText += textController.text;
                  }


                  widget.controller.text = otpText;

                },
              )
          );
        }),
      ),
    );
  }
}

class OtpTextEditingController{

  String text;

  OtpTextEditingController({this.text=''});

  void clear(){
    text = '';
  }

}



CustomText answerColorText(String answer){

  Color answerTextColor = Colors.green.shade400;

  String alc = answer.toLowerCase();

  if(alc =="average" || alc == "sometimes" || alc == "rarely"){
    answerTextColor = Colors.yellowAccent;
  }else if(alc == "poor" || alc == "no" || alc == "never"){
    answerTextColor = Colors.redAccent;
  }else if(alc == "no answer"){
    answerTextColor = Colors.black54;
  }


  return CustomText(answer, textColor: answerTextColor, fontWeight: FontWeight.w700, fontSize: 13,);

}