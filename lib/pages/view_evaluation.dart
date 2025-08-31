

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selc_lecturer/components/cells.dart';

import '../components/text.dart';
import '../models/models.dart';



class ViewCourseEvaluation extends StatelessWidget {


  final ClassCourse course;


  const ViewCourseEvaluation({super.key, required this.course});

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


            //todo: top bar.
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(CupertinoIcons.back, color: Colors.green.shade400)
                ),

                const SizedBox(width: 8,),

                HeaderText('Evaluation')

              ],
            ),


            const SizedBox(height: 12),


            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [

                  CourseDetailSection(course: course),


                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 12,
                        children: [
                      
                          QuestionnaireTable(),
                      
                      
                          CategoriesTable()
                        ],
                      ),
                    )
                  )


                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}




class QuestionnaireTable extends StatelessWidget {

  const QuestionnaireTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),

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
            'Questionnaire Responses',
            fontSize: 15
          ),


          const SizedBox(height: 12,),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12)
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Expanded(
                  flex: 2,
                  child: CustomText(
                    'Question'
                  )
                ),

                SizedBox(
                  width: 150,
                  child: CustomText(
                    'Answer type'
                  )
                ),


                Expanded(
                  child: CustomText(
                      'Answer Summary'
                  )
                ),


                SizedBox(
                  width: 120,
                  child: CustomText(
                    'Mean Score',
                    textAlignment: TextAlign.center,
                  )
                ),

                SizedBox(
                  width: 120,
                  child: CustomText(
                    'Percentage Score',
                    textAlignment: TextAlign.center,
                  )
                ),


                SizedBox(
                  width: 160,
                  child: CustomText(
                    'Remark'
                  )
                )
              ],
            ),
          ),



          //todo: questionnaire rows
          for(int i=0; i < 19; i++) buildQuestionnaireTableRow(isLast: i==18),

        ],
      ),
    );
  }
  
  
  
  Widget buildQuestionnaireTableRow({bool isLast = false}){

    VerticalDivider divider = VerticalDivider(color: Colors.black54, thickness: 1, width: 0,);

    return Container(  
      decoration: BoxDecoration(  
        border: isLast ? null : Border(
          bottom: BorderSide(color: Colors.black54)
        )
      ),
      
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            //todo: the actual question

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CustomText(
                    'This is a question here. Lorem ipsum something something'
                ),
              ),
            ),


            divider,


            //todo: answer type
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText('performance'),
              ),
            ),


            divider,

            //todo: answer summary
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,

                  children: List<Widget>.generate(
                    AnswerType.performance.answers.length,
                    (index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          AnswerType.performance.answers[index]
                        ),


                        CustomText(
                          '20'
                        )
                      ],
                    )
                  )
                ),
              ),
            ),


            divider,



            //todo: mean score
            SizedBox(
              width: 120,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CustomText(
                  '4.5'
                ),
              ),
            ),

            divider,


            //todo: percentage score
            SizedBox(
              width: 120,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                    '75'
                ),
              ),
            ),


            divider,


            //todo: questionnaire remark
            SizedBox(
              width: 160,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText('Very good'),
              ),
            )
          ]
        )
      ),
    );
  }
}











class CategoriesTable extends StatelessWidget {

  const CategoriesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),

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
            'Categories Report',
            fontSize: 15
          ),


          const SizedBox(height: 8),


          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12)
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Expanded(
                    flex: 2,
                    child: CustomText(
                        'Core Area(Category)'
                    )
                ),

                Expanded(
                    flex: 3,
                    child: CustomText(
                        'Questions'
                    )
                ),



                SizedBox(
                    width: 120,
                    child: CustomText(
                      'Mean Score',
                      textAlignment: TextAlign.center,
                    )
                ),

                SizedBox(
                    width: 120,
                    child: CustomText(
                      'Percentage Score',
                      textAlignment: TextAlign.center,
                    )
                ),


                Expanded(
                    child: CustomText(
                        'Remark'
                    )
                )
              ],
            ),
          ),

          categoryRow(),

          categoryRow(),

          categoryRow(),

          categoryRow(isLast: true)

        ],
      ),
    );
  }





  Widget categoryRow({bool isLast= false}){


    final divider = VerticalDivider(
      thickness: 1, width: 0, color: Colors.black54,);

    return IntrinsicHeight(
      child: Container(
        width: double.infinity,

        decoration: isLast ? null : BoxDecoration(
          borderRadius: BorderRadius.zero,
          border: Border(bottom: BorderSide(color: Colors.black54))
        ),


        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText('Small Category'),
              ),
            ),


            divider,


            Expanded(
              flex: 3,
              child: Column(

                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: List<Widget>.generate(
                  5,(int index) => Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    width: double.infinity,

                    decoration: BoxDecoration(
                      border: index == 4 ? null : Border(
                        bottom: BorderSide(color: Colors.black26)
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText('Question number $index appear here'),
                    ),
                  )
                )
              )
            ),


            divider,


            SizedBox(
              width: 120,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                  '4.345',
                  textAlignment: TextAlign.center,
                ),
              ),
            ),


            divider,


            SizedBox(
              width: 120,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                  '75',
                  textAlignment: TextAlign.center,
                ),
              ),
            ),



            divider,


            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText('Very good'),
              )
            )

          ],
        ),
      ),
    );
  }
}






