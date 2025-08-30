
import 'package:flutter/material.dart';
import 'package:selc_lecturer/components/text.dart';

void showCustomAlertDialog(BuildContext context,{
  AlertType alertType = AlertType.info,
  required String title, 
  required String contentText,
  Function()? onDismiss
}){


  showDialog(
    context: context,
    builder: (BuildContext alertContext) => AlertDialog(

      icon: Icon(
        alertType.iconData,
        color: alertType.iconColor,
        size: 50,
      ),

      title: HeaderText(
        title, 
        fontSize: 18, 
        textAlignment: TextAlign.center,
      ),
      content: CustomText(contentText, fontSize: 14, textAlignment: TextAlign.center,),

      actions: [
        TextButton(
          child: CustomText(
            'Close', 
            fontSize: 15, 
            textColor: alertType.iconColor, 
            fontWeight: FontWeight.w600,
          ),
          onPressed: () {
            Navigator.pop(alertContext);

            if(onDismiss != null){
              onDismiss.call();
            }
          },
        )
      ],
    )
  );

}


enum AlertType{

  warning(Icons.warning, Colors.redAccent),
  success(Icons.done_all, Colors.green),
  info(Icons.info, Colors.blue);

  final IconData iconData;
  final Color iconColor;

  const AlertType(this.iconData, this.iconColor);

}



class LoadingDialog extends StatelessWidget {

  final String? title;
  final String message;
  
  const LoadingDialog({super.key, required this.message, this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: HeaderText(title ?? '', textAlignment: TextAlign.center),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          
          SizedBox(
            height: 45,
            width: 45,
            child: CircularProgressIndicator(
              color: Colors.green.shade400,
            )
          ),

          const SizedBox(height: 8,),
          
          CustomText(message, fontSize: 14, maxLines: 3,)
        ],
      ),
    );
  }
}



void showToastMessage(BuildContext context, {AlertType alertType = AlertType.info, required String details}){
  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      backgroundColor: Colors.grey.shade100,
      surfaceTintColor: Colors.grey.shade100,
      leadingPadding: EdgeInsets.zero,
      margin: const EdgeInsets.all(8),
      leading: Icon(alertType.iconData, color: alertType.iconColor,),
      content: Padding(
        padding: const EdgeInsets.all(3.0),
        child: CustomText(details, fontWeight: FontWeight.w500,),
      ),
      actions: [
        TextButton(
          onPressed: ()=>ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          child: CustomText(
            'CLOSE', 
            textColor: alertType == AlertType.warning ? Colors.red.shade400 : Colors.green.shade400, 
            fontWeight: FontWeight.w600,
          )
        )
      ]
    )
  );
}




void showNoConnectionAlertDialog(BuildContext context) => showCustomAlertDialog(
  context, 
  title: 'No Connection', 
  contentText: 'Make sure you have an active internet connection'
);


