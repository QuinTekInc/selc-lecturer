

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selc_lecturer/components/alert_dialog.dart';
import 'package:selc_lecturer/components/button.dart';
import 'package:selc_lecturer/components/cells.dart';
import 'package:selc_lecturer/components/charts/bar_chart.dart';
import 'package:selc_lecturer/components/charts/pie_chart.dart';
import 'package:selc_lecturer/providers/selc_provider.dart';

import '../components/text.dart';
import '../models/models.dart';



class ViewCourseEvaluation extends StatefulWidget {


  final ClassCourse course;
  const ViewCourseEvaluation({super.key, required this.course});

  @override
  State<ViewCourseEvaluation> createState() => _ViewCourseEvaluationState();
}

class _ViewCourseEvaluationState extends State<ViewCourseEvaluation>  with TickerProviderStateMixin{

  late final TabController tabController;

  late List<QuestionnaireEvaluation> questionEvaluations;
  late List<CategorySummary> categorySummaries;
  late List<LecturerRatingSummary> ratingSummary;
  late CourseEvaluationSuggestion evaluationSuggestion;

  bool isLoading = false;

  bool hasError = false;


  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);

    loadData();

    super.initState();
  }


  @override
  void dispose(){
    tabController.dispose();
    super.dispose();
  }



  void loadData() async {

    setState(() {
      isLoading = true;
      hasError = false;
    });


    try{
      questionEvaluations = await Provider.of<SelcProvider>(context, listen: false).loadQuestionnaireEvaluations(widget.course.classCourseId);

      categorySummaries = await Provider.of<SelcProvider>(context, listen: false).loadCategorySummary(widget.course.classCourseId);

      ratingSummary = await Provider.of<SelcProvider>(context, listen: false).loadCourseLRatingSummary(widget.course.classCourseId);

      evaluationSuggestion = await Provider.of<SelcProvider>(context, listen: false).loadEvaluationSuggestion(widget.course.classCourseId);

    } on SocketException{

      hasError = true;

      showNoConnectionAlertDialog(context);

    }on Error catch(error, trace){

      debugPrint(error.toString());
      debugPrint(trace.toString());


      hasError = true;

      showCustomAlertDialog(
        context,
        alertType: AlertType.warning,
        title: 'Error',
        contentText: 'An unexpected error occurred. Please try again'
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

                HeaderText('Evaluation Summary', textColor: Colors.green.shade400),

                Spacer(),

                if(!isLoading && !hasError) Container(
                    padding: EdgeInsets.zero,
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.22,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400, width: 1.5)
                    ),


                    child: TabBar(
                        controller: tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicatorPadding: EdgeInsets.zero,

                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.green.shade400,
                        ),

                        padding: const EdgeInsets.all(4),
                        labelColor: Colors.white,
                        labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600
                        ),
                        unselectedLabelStyle: TextStyle(
                            fontFamily: 'Poppins'
                        ),

                        tabs: [
                          Tab(
                            //icon: Icon(CupertinoIcons.table),
                            text: 'Table Summary',
                          ),

                          Tab(
                            //icon: Icon(CupertinoIcons.table),
                            text: 'Visualized Summary',
                          ),

                          Tab(
                            text: 'Suggestions'
                          )
                        ]
                    )
                ),

              ],
            ),


            const SizedBox(height: 12),


            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [

                  CourseDetailSection(course: widget.course),

                  if(isLoading) Expanded(
                    child: Center(
                      child: CircularProgressIndicator()
                    ),
                  )
                  else if(!isLoading && hasError) Expanded(
                    child: Center(

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          HeaderText('Oops'),
                          CustomText('Could not load data due an unexpected error. Please try again.'),
                          CustomButton.withIcon(
                            'Reload',
                            icon: CupertinoIcons.refresh,
                            onPressed: loadData,
                          )
                        ]
                      )
                    )
                  )
                  else Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: TabBarView(
                        controller: tabController,

                        children: [

                          buildTablesView(),
                          
                          QuestionsVisualization(
                            lecturerRating: widget.course.ccLecturerRating,
                            categorySummaries: categorySummaries,
                            questionEvaluations: questionEvaluations, 
                            ratingSummary: ratingSummary,
                            sentimentSummary: evaluationSuggestion.sentimentSummary,
                          ),
                          
                          SuggestionSection(evalSuggestion: evaluationSuggestion,)
                        ]
                      )
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



  SingleChildScrollView buildTablesView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 12,
        children: [

          QuestionnaireTable(questionnaireEvaluations: questionEvaluations,),


          CategoriesTable(categorySummaries: categorySummaries,)
        ],
      ),
    );
  }


}





//todo: questionnaire evaluation tables.
class QuestionnaireTable extends StatelessWidget {

  final List<QuestionnaireEvaluation> questionnaireEvaluations;

  const QuestionnaireTable({super.key, required this.questionnaireEvaluations});

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


          //todo: table header
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
          for(int i=0; i < questionnaireEvaluations.length; i++) buildQuestionnaireTableRow(evaluation: questionnaireEvaluations[i] , isLast: i==18),

        ],
      ),
    );
  }
  
  
  
  Widget buildQuestionnaireTableRow({required QuestionnaireEvaluation evaluation, bool isLast = false}){

    Map<String, dynamic> summary = evaluation.answerSummary;


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
                    evaluation.questionnaire.question
                ),
              ),
            ),


            divider,


            //todo: answer type
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(evaluation.questionnaire.answerType.toString()),
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
                    summary.length,
                    (index) {


                      String answer = summary.keys.elementAt(index);


                      return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        CustomText(
                          answer
                        ),


                        CustomText(
                          '${summary[answer]}'
                        )
                      ],
                    );
                    }
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
                  '${evaluation.meanScore}'
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
                  '${evaluation.percentageScore}'
                ),
              ),
            ),


            divider,


            //todo: questionnaire remark
            SizedBox(
              width: 160,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(evaluation.remark),
              ),
            )
          ]
        )
      ),
    );
  }
}






//todo: categories table
class CategoriesTable extends StatelessWidget {

  final List<CategorySummary> categorySummaries;

  const CategoriesTable({super.key, required this.categorySummaries});

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


          //todo: table header

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
                  child: CustomText('Core Area (Category)'),
                ),


                Expanded(
                  flex: 3,
                  child: CustomText('Questions'),
                ),



                SizedBox(
                  width: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                      'Mean Score',
                      textAlignment: TextAlign.center,
                    ),
                  ),
                ),



                SizedBox(
                  width: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                      'Percentage Score(%)',
                      textAlignment: TextAlign.center,
                    ),
                  ),
                ),




                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText('Remark'),
                    )
                )




              ],
            ),
          ),


          for(CategorySummary summary in categorySummaries) categoryRow(summary: summary, isLast: categorySummaries.indexOf(summary) == categorySummaries.length-1)

        ],
      ),
    );
  }





  Widget categoryRow({required CategorySummary summary, bool isLast= false}){


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


            //category name

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(summary.category),
              ),
            ),


            divider,

            //questions
            Expanded(
              flex: 3,
              child: Column(

                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: List<Widget>.generate(
                  summary.questions.length,
                  (int index) => Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    width: double.infinity,

                    decoration: BoxDecoration(
                      border: index+1 == summary.questions.length ? null : Border(
                        bottom: BorderSide(color: Colors.black26)
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(summary.questions[index].question),
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
                  summary.meanScore.toStringAsFixed(3),
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
                  summary.percentageScore.toStringAsFixed(3),
                  textAlignment: TextAlign.center,
                ),
              ),
            ),



            divider,


            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(summary.remark),
              )
            )

          ],
        ),
      ),
    );
  }
}







class QuestionsVisualization extends StatelessWidget {
  
  final double lecturerRating;

  final List<CategorySummary> categorySummaries;
  final List<QuestionnaireEvaluation> questionEvaluations;
  final List<LecturerRatingSummary> ratingSummary;

  final List<SuggestionSentimentSummary> sentimentSummary;

  const QuestionsVisualization({
    super.key,
    required this.lecturerRating,
    required this.categorySummaries,
    required this.questionEvaluations,
    required this.ratingSummary,
    required this.sentimentSummary
  });


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 12,
        children: List<Widget>.generate(
          categorySummaries.length,
          (index){

            String category = categorySummaries[index].category;

            List<QuestionnaireEvaluation> evaluations = [];


            for(Questionnaire question in categorySummaries[index].questions){

              for(QuestionnaireEvaluation evaluation in questionEvaluations){
                if(question != evaluation.questionnaire) continue;

                evaluations.add(evaluation);
              }

            }

            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children:[

                  Center(
                      child: FractionallySizedBox(
                          widthFactor: 0.6,
                          child: HeaderText(category)
                      )
                  ),

                  for(int i = 0; i < evaluations.length; i++) QuestionnaireCard(
                    questionNumber: 1+questionEvaluations.indexOf(evaluations[i]),
                    evaluation: evaluations[i],
                  )

                ]
            );
          }
        ) + [

          Center(
            child: FractionallySizedBox(
              widthFactor: 0.6,
              child: HeaderText('Lecturer Rating'),
            )
          ),

          //todo: lecturer rating card

          Center(
            child: LecturerRatingCard(lecturerRating: lecturerRating, ratingSummary: ratingSummary,)
          ),




          Center(
              child: FractionallySizedBox(
                widthFactor: 0.6,
                child: HeaderText('Evaluation Suggestions'),
              )
          ),



          Center(
            child: FractionallySizedBox(
              widthFactor: 0.6,

              child: Container(

                padding: const EdgeInsets.all(12),
                width: double.infinity,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.grey.shade50
                ),

                child: Column(

                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,

                  children: [

                    Row(
                      spacing: 8,
                      children: [

                        CustomText(
                          'Evaluation Suggestion Sentiment Summary',
                          fontSize: 15,
                        ),

                        Spacer(),

                        SizedBox(
                          height: 35,
                          child: VerticalDivider()
                        ),


                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            CustomText(
                              'Answer Type',
                              fontWeight: FontWeight.w600,
                              textColor: Colors.grey.shade600,
                            ),

                            CustomText(
                              'Suggestion',
                              textColor: Colors.green.shade400,
                            )
                          ]
                        )
                      ],
                    ),

                    const SizedBox(height: 8),

                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,

                        children: List<Widget>.generate(
                          sentimentSummary.length,
                          (int index) {

                            String sentiment = sentimentSummary[index].sentiment;
                            int count = sentimentSummary[index].sentimentCount;
                            double percent = sentimentSummary[index].sentimentPercent;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    sentiment,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15
                                  ),
                                ),

                                Expanded(
                                  child: CustomText(
                                    count.toString(),
                                    fontSize: 15,
                                    textAlignment: TextAlign.center
                                  ),
                                ),

                                Expanded(
                                  child: CustomText(
                                    '$percent %',
                                    fontSize: 15,
                                    textAlignment: TextAlign.center,
                                  ),
                                )

                              ]
                            );
                          }
                        )
                      )
                    )

                  ]
                )
              ),
            )
          )

        ]
      ),
    );
  }
}





//todo: questionnaire visualisation card
class QuestionnaireCard extends StatefulWidget {

  final int questionNumber;
  final QuestionnaireEvaluation evaluation;

  const QuestionnaireCard({super.key, required this.questionNumber, required this.evaluation});

  @override
  State<QuestionnaireCard> createState() => _QuestionnaireCardState();
}


class _QuestionnaireCardState extends State<QuestionnaireCard> {


  final  List<String> visualNames = ['Pie Chart', 'Bar Chart'];
  final visualTypeController = DropdownController<String>();


  List<CustomPieSection> pieSections = [];
  List<CustomBarGroup> barGroups = [];

  @override
  void initState() {


    //todo: by default the dropdown button is set Pie Chart.
    visualTypeController.value = visualNames[0];

    // TODO: implement initState
    Map<String, dynamic> answerSummary = widget.evaluation.answerSummary;


    for(String answer in widget.evaluation.answerSummary.keys){

      double value = answerSummary[answer].toDouble();

      pieSections.add(CustomPieSection(value: value, title: answer));

      barGroups.add(CustomBarGroup(
        x: answerSummary.keys.toList().indexOf(answer),
        label: answer,
        rods: [Rod(y: value)]
      ));
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return FractionallySizedBox(
      widthFactor: 0.6,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300)
        ),

        child: Column(
          mainAxisSize:  MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200
                  ),

                  child: CustomText(
                      '${widget.questionNumber}',
                    textColor: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  )
                ),

                Expanded(
                  child: CustomText(
                    widget.evaluation.questionnaire.question,
                    fontSize: 17,
                  ),
                ),



                const SizedBox(height: 45, child: VerticalDivider(width: 0, thickness: 1.5,),),


                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      'Answer Type',
                      fontWeight: FontWeight.w600,
                      textColor: Colors.grey.shade600,
                    ),

                    CustomText(
                      widget.evaluation.questionnaire.answerType.toString(),
                      textColor: Colors.green.shade400,
                    )
                  ],
                )



              ],
            ),

            //todo: piechart or bar chart.


            Align(
              alignment: Alignment.centerRight,

              child: FractionallySizedBox(
                widthFactor: 0.45,
                child: CustomDropdownButton<String>(
                  icon: CupertinoIcons.chart_bar,
                  hint: 'Select Visualization type',
                  controller: visualTypeController,
                  items: visualNames,
                  onChanged: (newValue) => setState(() {})
                ),
              ),
            ),


            if(visualTypeController.value == visualNames[0])CustomPieChart(
              pieSections: pieSections,
              width: double.infinity,
              addKeySection: true,
              height: 300,
            )
            else CustomBarChart(
              width: double.infinity,
              height: 300,
              groups: barGroups,
              leftAxisTitle: 'Frequency',
              bottomAxisTitle: 'Answers',
            ),



            buildCardBottomSection()

          ]
        )
      ),
    );
  }


  Align buildCardBottomSection() {
    return Align(
      alignment: Alignment.bottomRight,
      child:FractionallySizedBox(
        widthFactor: 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [

            //todo: mean score

            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 8,
              children: [

                CustomText(
                  'Mean Score: ',
                  fontWeight: FontWeight.w600,
                  textColor: Colors.grey.shade600,
                ),


                Spacer(),


                CustomText(
                  widget.evaluation.meanScore.toStringAsFixed(3),
                ),

              ]
            ),

            //todo: percentage score

            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 8,
              children: [

                CustomText(
                  'Percentage Score(%): ',
                  fontWeight: FontWeight.w600,
                  textColor: Colors.grey.shade600,
                ),

                Spacer(),


                CustomText(
                  widget.evaluation.percentageScore.toStringAsFixed(3),
                ),

              ]
            ),


            //todo: remark

            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 8,
              children: [

                CustomText(
                  'Remark: ',
                  fontWeight: FontWeight.w600,
                  textColor: Colors.grey.shade600,
                ),


                Spacer(),


                CustomText(
                  widget.evaluation.remark,
                  fontWeight: FontWeight.w700,
                ),

              ]
            ),

          ],
        ),
      )
    );
  }
}




//todo: lecturer ratings card. (normally used with the questionnaire visualisation secction)
class LecturerRatingCard extends StatelessWidget {
  
  final double lecturerRating;
  final List<LecturerRatingSummary> ratingSummary;

  const LecturerRatingCard({super.key, required this.lecturerRating, required this.ratingSummary});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300)
        ),


        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 8,

          children: [

            //top row of the cell.
            Row(
              spacing: 8,
              children: [
                CustomText(
                  'Students sentiment level of lecturer',
                  fontSize: 15,
                ),

                Spacer(),

                SizedBox(
                  height: 45,
                  child: VerticalDivider(width: 0, thickness: 1.5,)
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    CustomText(
                      'AnswerType',
                      fontWeight: FontWeight.w600,
                      textColor: Colors.grey.shade600
                    ),

                    CustomText(
                        'Rating',
                        textColor: Colors.green.shade400
                    )
                  ]
                )
              ],
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: List.generate(
                        ratingSummary.length,
                        (index) => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 8,
                          children: [

                            Expanded(
                                child: buildStars(ratingSummary[index].rating)
                            ),

                            SizedBox(
                              width: 150,
                              child:  CustomText(
                                '${ratingSummary[index].percentage}%',
                                fontSize: 15,
                              ),
                            ),

                            SizedBox(
                              width: 150,
                              child:  CustomText(
                                  '${ratingSummary[index].ratingCount}',
                                fontSize: 15,
                              ),
                            )

                          ]
                        )
                      ),
                    )
                  ),
                ),


                SizedBox(
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.yellow,
                            size: 150,
                          ),

                          CustomText(
                            lecturerRating.toStringAsFixed(2),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            textColor: Colors.grey.shade700,
                          )
                        ]
                      ),


                      CustomText(
                        'Average rating of lecturer for this course',
                        textAlignment: TextAlign.center
                      )
                    ],
                  ),
                )
              ],
            )
          ]
        )
      )
    );
  }



  //build a specified number of stars in a row
  Widget buildStars(int n) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    spacing: 3,
    children: List<Widget>.generate(
      n,
      (index) => Icon(Icons.star_rounded, color: Colors.yellow, size: 28,)
    )
  );
}






//todo: evaluation suggestions sections
class SuggestionSection extends StatelessWidget {

  final CourseEvaluationSuggestion evalSuggestion;

  const SuggestionSection({super.key, required this.evalSuggestion});

  @override
  Widget build(BuildContext context) {
    return evalSuggestion.suggestionsMap.isEmpty ? buildNoSuggestionSection() : SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          FractionallySizedBox(
            widthFactor: 0.6,

            child: CustomBarChart(
              chartTitle: 'Students\' Suggestion Sentiment Summary',
              leftAxisTitle: 'Frequency',
              bottomAxisTitle: 'Sentiment',
              containerBackgroundColor: Colors.grey.shade50,
              width: double.infinity,

              groups: List<CustomBarGroup>.generate(
                evalSuggestion.sentimentSummary.length,
                (int index) {

                  String sentiment = evalSuggestion.sentimentSummary[index].sentiment;
                  int sentimentCount = evalSuggestion.sentimentSummary[index].sentimentCount;

                  return CustomBarGroup(
                    x: index,
                    label: sentiment,
                    rods: [Rod(y: sentimentCount.toDouble())]
                  );
                }
              )
            ),
          ),


          const SizedBox(height: 12,),


          FractionallySizedBox(
            widthFactor: 0.6,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              children: [

                Align(
                  alignment: Alignment.centerLeft,
                  child: HeaderText('Evaluations Suggestions'
                  )
                ),


                for(int i=0; i < evalSuggestion.suggestionsMap.length; i++) Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: ListTile(
                    leading: Icon(CupertinoIcons.person, size: 30, color: Colors.green.shade300,),
                    title: CustomText(
                      evalSuggestion.suggestionsMap[i]['suggestion'],
                      fontSize: 15,
                    ),
                  ),
                )


              ],
            ),
          )

        ]
      )
    );
  }


  Widget buildNoSuggestionSection(){
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.4,

        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            HeaderText('No Evaluation Suggestions'),

            CustomText(
              'All suggestions made by students for this course appear here.'
            )

          ],
        )
      )
    );
  }
}





