

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/cells.dart';
import '../components/text.dart';
import '../models/models.dart';
import '../providers/selc_provider.dart';


class LecturerInfoPage extends StatelessWidget {
  
  const LecturerInfoPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: HeaderText('Lecturer Information')
      ),


      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: 470,
              child: buildDetailsBody(context),
            )
          ),
        ),
      ),
    );
  }




  Column buildDetailsBody(BuildContext context) {

    Lecturer lecturer = Provider.of<SelcProvider>(context, listen: false).lecturer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
            
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 20),
          child: CircleAvatar(
            backgroundColor: Colors.green.shade400,
            radius: 60,
            child: const Icon(CupertinoIcons.person, size: 60, color: Colors.white),
          ),
        ),
            
        const SizedBox(height: 12,),

        RatingStars(rating: lecturer.rating),

        const SizedBox(height: 12,),


        DetailContainer(title: 'Full Name', detail: lecturer.fullName()),
    
        const SizedBox(height: 8,),
            
            
        DetailContainer(title: 'Username: ', detail: lecturer.username),
            
        const SizedBox(height: 8,),

            
        DetailContainer(title: 'Email: ', detail: lecturer.email),
            
        const SizedBox(height: 8),


        DetailContainer(title: 'Department: ', detail: lecturer.department),

        const SizedBox(height: 8),
            
        // DetailContainer(title: 'Campus of study:', detail: lecturer.campus!),
        // const SizedBox(height: 8),
            
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Divider(),
        ),


        ClickableMenuItem(
          title: 'Change Password',
          icon: CupertinoIcons.lock,
          iconBackgroundColor: Colors.green.shade300,
          onPressed: (){},
        ),


        const SizedBox(height: 8,),


        ClickableMenuItem(
          title: 'Logout',
          icon: Icons.logout,
          iconBackgroundColor: Colors.red.shade400,
          onPressed: (){},
        ),

            
      ],
    );
  }

}
