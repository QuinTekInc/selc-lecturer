
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import 'button.dart';
import 'text.dart';






class CourseDetailSection extends StatelessWidget {

  final ClassCourse course;

  final bool showAvatar;

  const CourseDetailSection({super.key, required this.course, this.showAvatar=true});

  @override
  Widget build(BuildContext context) {
    return Container( 
      width: 470,
      padding: const EdgeInsets.all(12),  
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100
      ),
    
    
      child: Column(  
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
    
          CustomText(
            'Course Information',
            fontWeight: FontWeight.w600,
            textColor: Colors.green.shade300,
          ),
    
    
          if(showAvatar) const SizedBox(height: 16,),
    
          if(showAvatar) Center(
            child: CircleAvatar(  
              radius: 80,
              backgroundColor: Colors.green.shade400,
              child: Icon(Icons.school, size: 80, color: Colors.white,),
            ),
          ),
    
          
          const SizedBox(height: 16),
    
    
          DetailContainer(title: 'Course Code', detail: course.courseCode),
          
          const SizedBox(height: 8,),
    
          DetailContainer(title: 'Course Title', detail: course.courseCode),
          
          const SizedBox(height: 8,),
    
  
          DetailContainer(title: 'Semester', detail: course.semester.toString()),
          
          const SizedBox(height: 8,),
    
    
          DetailContainer(title: 'Year', detail: course.year.toString()),
          
          const SizedBox(height: 8,),


          DetailContainer(title: 'Mean Score', detail: course.meanScore.toStringAsFixed(3)),

          const SizedBox(height: 8,),


          DetailContainer(title: 'Remark', detail: course.remark)
    
          
        ],
      )
    );
  }
}









class RatingStars extends StatelessWidget {

  final double rating;
  final bool transparentBackground;
  final bool zeroPadding;
  final double spacing;

  const RatingStars({
    super.key,
    required this.rating,
    this.transparentBackground = false,
    this.zeroPadding = false,
    this.spacing = 5
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: zeroPadding ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 8, horizontal: 12),

        decoration: BoxDecoration(
            color: transparentBackground ? Colors.transparent : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12)
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: spacing,
          children: List<Widget>.generate(5,  (index) => buildStar(index, rating)),
        )
    );
  }


  Widget buildStar(int index, double rating){

    IconData iconData = Icons.star_outline;
    bool shouldColor = false;

    int rateInt = rating.toInt();

    if(rating > index){

      iconData = Icons.star;

      //check whether the current should be halved.
      if((rating-rateInt) >= 0.5){
        iconData = Icons.star_half;
      }

      shouldColor = true;
    }

    return Icon(iconData, color: shouldColor ? Colors.green.shade400 : null,);
  }
}





class DetailContainer extends StatelessWidget {

  final String title;
  final String detail;

  const DetailContainer({super.key, required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black38)
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      
        children: [
      
          CustomText(
            title,
            fontWeight: FontWeight.w600
          ),
      
          const SizedBox(height: 3),
      
          CustomText(
            detail,
            softwrap: true,
          )
        ],
      ),
    );
  }
}





class ClickableMenuItem extends StatelessWidget {

  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? trailing;
  final Color? iconBackgroundColor;
  final VoidCallback? onPressed;

  const ClickableMenuItem({super.key, required this.title, required this.icon, this.trailing, this.onPressed, this.subtitle, this.iconBackgroundColor});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(

      decoration: BoxDecoration(
        //Colors.grey.shade200
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8)
      ),

      child: ListTile(

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
        ),

        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        leading: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,

            decoration: BoxDecoration(
                color: iconBackgroundColor ?? Colors.green.shade300,
                borderRadius: BorderRadius.circular(8)
            ),
            child: Icon(icon, color: Colors.white,)
        ),


        title: CustomText(
          title,
          fontSize: 16,
        ),


        subtitle: subtitle == null ? null : CustomText(
          subtitle!,
          fontSize: 13,
        ),


        trailing: trailing ?? Icon(CupertinoIcons.forward),

        onTap: onPressed,
      ),
    );
  }
}




