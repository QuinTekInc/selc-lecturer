

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selc_lecturer/pages/lecturer_info_page.dart';


import '../components/alert_dialog.dart';
import '../components/text.dart';
import '../models/models.dart';
import '../providers/selc_provider.dart';
import 'auth/login_page.dart';


class Dashboard extends StatefulWidget {

  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}


class _DashboardState extends State<Dashboard> {


  bool isLoading = false;

  List<ClassCourse> currentCourses = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }


  void loadData() async {

    setState(() =>  isLoading = true);

    try{
      //todo: do something here
      await Provider.of<SelcProvider>(context, listen: false).loadCourses();

      currentCourses = Provider.of<SelcProvider>(context, listen: false).courses.where(
          (course) => course.year == DateTime.now().year && course.semester == 2
      ).toList();

    }on SocketException{

      showNoConnectionAlertDialog(context);

    }on Error catch(_, trace){

      debugPrint(trace.toString());
      
      showCustomAlertDialog(
        context, 
        alertType: AlertType.warning,
        title: 'Error', 
        contentText: 'An unexpected error occurred. Please try again.'
      );

    }


    setState(() => isLoading = false);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(   
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                HeaderText('Dashboard (Lecturers\' Portal)', textColor: Colors.green.shade400),

                const Spacer(), 


                IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LecturerInfoPage())),
                  tooltip: 'View Profile',
                  icon: CircleAvatar(
                    backgroundColor: Colors.green.shade300,
                    child: Icon(CupertinoIcons.person, color: Colors.white,
                  ))
                ),

                const SizedBox(width: 8,),

                IconButton(
                  onPressed: handleLogout, //todo: implement the logout function here.
                  tooltip: 'Logout',
                  icon: Icon(Icons.logout, color: Colors.red.shade400,)
                ),
              ],
            ),

            const SizedBox(height: 12,),


            buildUserWelcomeText(context),



            const SizedBox(height: 12,),
            
            //todo: dashboard cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(  
                children: buildDashboardCards(),
              ),
            ),


            const SizedBox(height: 12,),


            Expanded(  
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Expanded(
                    child: buildCurrentCoursesTable(),
                  ),


                  Expanded(
                    flex: 3,
                    child: buildCoursesTable(),
                  )
                ],
              )
            ),

            const SizedBox(height: 8,),

            Center(
              child: CustomText(
                'Powered by: Quality Assurance and Academic Planning Directorate',
                textAlignment: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }



  RichText buildUserWelcomeText(BuildContext context){
    return RichText(
      text: TextSpan(
        text: 'Welcome,\n',
        style: TextStyle(
            color: Colors.black87,
            fontFamily: 'Poppins'
        ),


        children: [
          TextSpan(
              text: Provider.of<SelcProvider>(context).lecturer.fullName(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )
          ),

          TextSpan(
              text: '\nto your SELC portal'
          )
        ]
      ),
    );
  }




  List<Widget> buildDashboardCards(){
    
    SizedBox separator = SizedBox(width: 12,);


    bool isSemesterNull = Provider.of<SelcProvider>(context, listen:false).currentSemester == null;
    
    return [
      buildDashboardCard(
          context,
          title: 'Current Semester',
          detail: isSemesterNull ? 'N/A' : Provider.of<SelcProvider>(context).currentSemester.toString(),
          icon: Icons.school,
          backgroundColor: Colors.grey.shade400
      ),

      separator,


      buildDashboardCard(
        context,
        title: 'Current Courses',
        detail: currentCourses.length.toString(),
        icon: Icons.book,
      ),

      separator,

      buildDashboardCard(
          context,
          title: 'Total Courses',
          detail: Provider.of<SelcProvider>(context, listen: false).courses.length.toString(),
          icon: CupertinoIcons.time,
          backgroundColor: Colors.red.shade400
      ),

      separator,

      buildDashboardCard(
          context,
          title: 'Ratings for semester',
          detail: 0.toString(),
          icon: Icons.star_border,
          backgroundColor: Colors.blue.shade400
      ),
    ];
  }




  Widget buildDashboardCard(BuildContext context, {required IconData icon, required String title, required String detail, Color? backgroundColor}){

    return Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.topLeft,
        constraints: BoxConstraints(
            maxWidth: 300
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor ?? Colors.green.shade400,
        ),

        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Color.lerp(backgroundColor ?? Colors.green.shade400, Colors.white, 0.4),
                radius: 30,
                child: Icon(icon, color: Colors.white, size: 35,),
              ),

              const SizedBox(width: 12,),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      detail,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      textColor: Colors.white,
                    ),

                    const SizedBox(height: 3,),

                    CustomText(
                      title,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ]
        )
    );
  }




  Widget buildCurrentCoursesTable(){
    return Container(
      padding: EdgeInsets.all(12),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),


      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          HeaderText(
            'Current Courses',
            fontSize: 16,
            textColor: Colors.green.shade300
          ),

          const SizedBox(height: 8,),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Expanded(
                  child: CustomText('Course Code'),
                ),

                Expanded(
                  flex: 2,
                  child: CustomText('Course Title'),
                ),


                SizedBox(
                  width: 120,
                  child: CustomText('Cred. Hours', softwrap: false,),
                ),

              ],
            ),
          ),


          const SizedBox(height: 8),

          if(isLoading) Expanded(
              child: Center(
                  child: CircularProgressIndicator()
              )
          )else if(!isLoading && currentCourses.isEmpty)Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8,
                children: [


                  Icon(CupertinoIcons.book, size: 40, color: Colors.green.shade400,),

                  const SizedBox(height: 8,),

                  CustomText(
                    'No Data!',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    textAlignment: TextAlign.center,
                  ),

                  CustomText(
                    'Current courses for the semester appear here',
                    textAlignment: TextAlign.center,
                  ),

                ]
              )
            ),
          )else Expanded(
            child: ListView.builder(
              itemCount: currentCourses.length,
              itemBuilder: (_, index) => CurrentCourseCell(course: currentCourses[index],)
            ),
          )



        ]
      )
    );
  }



  Widget buildCoursesTable(){
    return Container(  
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(12),

      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.8
      ),

      decoration: BoxDecoration(  
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),

      child: Column(  
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,

        children: [

          HeaderText(
            'All Courses',
            fontSize: 16,
            textColor: Colors.green.shade400
          ),

          const SizedBox(height: 8,),


          //todo: table headers.

          Container(  
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200
            ),

            child: Row(  
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                //todo: blank space to store the book mark icons.
                const SizedBox(width: 120,),

                const Expanded(
                  child: CustomText(  
                    'Course Code'
                  ),
                ),

                const Expanded(
                  flex: 2,
                  child: CustomText('Course title'),
                ),

                const SizedBox(
                  width: 120,
                  child: CustomText(  
                    'Year',
                    textAlignment: TextAlign.center,
                  ),
                ),


                const SizedBox(
                  width: 120,
                  child: CustomText(
                    'Semester',
                    textAlignment: TextAlign.center,
                  ),
                ),

                const SizedBox(  
                  width: 120,
                  child: CustomText(
                    'Cred. Hours',
                    textAlignment: TextAlign.center,
                  ),
                ),

              ],
            ),
          ),


          const SizedBox(height: 12,),

          if(isLoading)Expanded(  
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
          else if(!isLoading && Provider.of<SelcProvider>(context).courses.isEmpty)Expanded(
            child: Container(  
              alignment: Alignment.center,
              child: Column(  
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Icon(CupertinoIcons.book, size: 40, color: Colors.green.shade400,),

                  const SizedBox(height: 8,),

                  CustomText(
                    'No Data!',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    textAlignment: TextAlign.center,
                  ),

                  CustomText(
                    'All your courses for the semester appear here',
                    textAlignment: TextAlign.center,
                  ),


                  TextButton(  
                    onPressed: () => loadData(),
                    child: Row(  
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.refresh, color: Colors.green.shade300,),
                        const SizedBox(width: 3,),
                        CustomText( 
                          'Refresh',
                          textColor: Colors.green.shade300,
                        )
                      ],
                    ),
                  )
                  
                ],
              ),
            ),  

          )else Expanded(
            flex: 2,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: Provider.of<SelcProvider>(context).courses.length,  
              separatorBuilder: (_, __) => const SizedBox(height: 8,),
              itemBuilder: (_, index) {
                ClassCourse course = Provider.of<SelcProvider>(context, listen: false).courses[index];
                return CourseCell(course: course);
              }
            ),
          )

        ],
      )
    );
  }




  void handleLogout() async {


    showDialog(
        context: context,
        builder: (_) => LoadingDialog(message: 'Logging Out.....Please wait',)
    );


    try{
      await Provider.of<SelcProvider>(context, listen: false).logout();
      Navigator.pop(context); //close the loading dialog dialog.

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => LoginPage(),
          ),
          (route) => false
      );


    }on SocketException catch(_){

      Navigator.pop(context); //close the loading dialog

      showCustomAlertDialog(
          context,
          title: 'Logout Error',
          contentText: 'Make sure you are connected to the internet'
      );

      return;

    }on Exception catch(exception){
      Navigator.pop(context); //close the loading dialog
      showCustomAlertDialog(
          context,
          title: 'Error',
          contentText: exception.toString()
      );
    }

  }


}





//NOTE: this widget has been made stateful because of the hover color den things

class CourseCell extends StatefulWidget {

  final ClassCourse course;

  const CourseCell({super.key, required this.course});

  @override
  State<CourseCell> createState() => _CourseCellState();
}



class _CourseCellState extends State<CourseCell> {

  Color hoverColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(

      onHover: (_) => setState(() => hoverColor = Colors.green.shade100),

      onExit: (_) => setState(() => hoverColor = Colors.transparent),

      child: GestureDetector(
        onTap: () => handleOpenEvaluation(),
        child: Container(
          padding: const EdgeInsets.all(8),
        
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: hoverColor
          ),
        
          child: Row(  
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
        
              //leading image icon
              SizedBox(
                width: 120,
                child: Icon(CupertinoIcons.book, color: Colors.green.shade400, size: 40,),
              ),
        
        
               Expanded(  
                child: CustomText(
                  widget.course.courseCode
                ),
              ),
        
              Expanded(
                flex: 2,
                child: CustomText(
                  widget.course.courseTitle
                ),
              ),

              SizedBox(
                width: 120,
                child: CustomText(
                  widget.course.year.toString(),
                  textAlignment: TextAlign.center,
                ),
              ),

              SizedBox(
                width: 120,
                child: CustomText(
                  widget.course.semester.toString(),
                  textAlignment: TextAlign.center,
                ),
              ),

              SizedBox(
                width: 120,
                child: CustomText(
                  widget.course.creditHours.toString(),
                  textAlignment: TextAlign.center,
                ),
              ),

              
            ],
          ),
        ),
      ),
    );
  }
  
  
  
  
  void handleOpenEvaluation() async {
    
  }
}







class CurrentCourseCell extends StatefulWidget {

  final ClassCourse course;
  const CurrentCourseCell({super.key, required this.course});

  @override
  State<CurrentCourseCell> createState() => _CurrentCourseCellState();
}

class _CurrentCourseCellState extends State<CurrentCourseCell> {

  Color backgroundColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (mouseEvent) => setState(() => backgroundColor = Colors.green.shade200),
      onExit: (mouseEvent) => setState(() => backgroundColor = Colors.transparent),

      child: GestureDetector(
        onTap: handleOpenEvaluation,
        child: Container(

          padding: const EdgeInsets.all(8),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: backgroundColor
          ),


          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(
                child: CustomText(
                  widget.course.courseCode
                )
              ),

              Expanded(
                flex: 2,
                child: CustomText(
                  widget.course.courseTitle
                ),
              ),


              SizedBox(
                width: 120,
                child: CustomText(
                  widget.course.creditHours.toString(),
                  textAlignment: TextAlign.center,
                ),
              )
            ],
          ),


        ),
      ),
    );
  }



  void handleOpenEvaluation(){

  }
}


