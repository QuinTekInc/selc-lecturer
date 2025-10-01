

class Lecturer {

    final String username;
    String firstName;
    String lastName;
    String email;
    final String department;
    double rating;

    Lecturer({
        required this.username,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.department,
        this.rating = 0
    });

    factory Lecturer.fromJson(Map<String, dynamic> jsonMap){
        return Lecturer(
            username: jsonMap['username'],
            firstName: jsonMap['first_name'],
            lastName: jsonMap['last_name'],
            email: jsonMap['email'],
            department: jsonMap['department'],
            rating: jsonMap['rating']
        );
    }


    String fullName(){
        return '$firstName $lastName';
    }
}






class ClassCourse{

    final int classCourseId;
    final String courseCode;
    final String courseTitle;
    final int creditHours;
    final int semester;
    final int year;
    final bool hasOnline;
    double meanScore;
    String remark;
    final double ccLecturerRating;


    ClassCourse({
        required this.classCourseId,
        required this.courseCode,
        required this.courseTitle,
        required this.creditHours,
        required this.semester,
        required this.year,
        this.meanScore = 0,
        required this.remark,
        required this.hasOnline,
        required this.ccLecturerRating
    });



    factory ClassCourse.fromJson(Map<String, dynamic> jsonMap){
        return ClassCourse(
            classCourseId: jsonMap['cc_id'],
            courseCode: jsonMap['course']['course_code'],
            courseTitle: jsonMap['course']['course_title'],
            creditHours: jsonMap['credit_hours'],
            semester: jsonMap['semester'],
            year: jsonMap['year'],
            meanScore: jsonMap['grand_mean_score'].toDouble() ?? 0,
            remark: jsonMap['remark'] ?? '',
            hasOnline: jsonMap['has_online'] ?? false,
            ccLecturerRating: jsonMap['lecturer_course_rating'].toDouble() ?? 0
        );
    }


}





enum AnswerType{

    performance(typeString: 'performance', answers: ['Poor', 'Average', 'Good', 'Very Good', 'Excellent']),
    time(typeString: "time", answers: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always']),
    yes_no(typeString: 'yes_no', answers: ['Yes', 'No']);


    final String typeString;
    final List<String> answers;

    const AnswerType({required this.typeString, required this.answers});


    static AnswerType? fromTypeString(String typeString){

        for(AnswerType answerType in AnswerType.values){
            if(answerType.typeString == typeString){
                return answerType;
            }
        }

        return null;
    }

    @override String toString() => typeString;
}





class Questionnaire{
    final int? questionId;
    final String question;
    final AnswerType answerType;

    Questionnaire({
        required this.questionId,
        required this.question,
        required this.answerType
    });
    
    
    factory Questionnaire.fromJson(Map<String, dynamic> jsonMap){
        return Questionnaire(
            questionId: jsonMap['id'],
            question: jsonMap['question'],
            answerType: AnswerType.fromTypeString(jsonMap['answer_type'])!
        );
    }


    @override
    bool operator ==(Object other) {

        // TODO: implement ==

        if(other.runtimeType != this.runtimeType) return false;


        Questionnaire otherQuestionnaire = other as Questionnaire;

        return this.question == otherQuestionnaire.question;
    }
}





class CategorySummary{

    final String category;
    List<Questionnaire> questions;
    double meanScore;
    double percentageScore;
    String remark;


    CategorySummary({
        required this.category,
        this.questions = const [],
        this.meanScore = 0,
        this.percentageScore = 0,
        this.remark = ''
    });


    factory CategorySummary.fromJson(Map<String, dynamic> jsonMap){

        List<dynamic> questionsMap = jsonMap['questions'];

        return CategorySummary(
            category: jsonMap['category'],
            questions: questionsMap.map((questionMap) => Questionnaire.fromJson(questionMap)).toList(),
            meanScore: jsonMap['average_score'].toDouble() ?? 0,
            percentageScore: jsonMap['percentage_score'].toDouble() ?? 0,
            remark: jsonMap['remark']
        );
    }

}





class QuestionnaireEvaluation {
    
    final Questionnaire questionnaire;
    final double meanScore;
    final double percentageScore;
    final String remark;
    final Map<String, dynamic> answerSummary;
    
    QuestionnaireEvaluation({
        required this.questionnaire,
        this.meanScore = 0, 
        this.percentageScore = 0, 
        this.remark = '',
        required this.answerSummary
    });
    
    
    
    factory QuestionnaireEvaluation.fromJson(Map<String, dynamic> jsonMap){

        Questionnaire questionnaire = Questionnaire.fromJson(jsonMap);
        
        Map<String, dynamic> answerSummary = processAnswerMap(questionnaire.answerType, jsonMap['answer_summary']);
        
        return QuestionnaireEvaluation(  
            questionnaire: questionnaire,
            meanScore: jsonMap['average_score'].toDouble() ?? 0,
            percentageScore: jsonMap['percentage_score'].toDouble() ?? 0,
            remark: jsonMap['remark'],
            answerSummary: answerSummary
        );
    }
    
    
    static Map<String, dynamic> processAnswerMap(AnswerType answerType, Map<String, dynamic> answerMap){

        Map<String, int> newAnswerMap = {};

        for(String answer in answerType.answers){

            if(answerMap.containsKey(answer)){
                newAnswerMap.addAll({answer: answerMap[answer]});
            }else{
                newAnswerMap.addAll({answer: 0});
            }
        }

        return newAnswerMap;
    }

    
}




class LecturerRatingSummary{

    final int rating;
    final int ratingCount;
    final double percentage;

    LecturerRatingSummary({required this.rating, required this.ratingCount, required this.percentage});


    factory LecturerRatingSummary.fromJson(Map<String, dynamic> jsonMap){
        return LecturerRatingSummary(
            rating: jsonMap['rating'],
            ratingCount: jsonMap['rating_count'],
            percentage: jsonMap['percentage'].toDouble()
        );
    }

}





class SuggestionSentimentSummary{

    final String sentiment;
    final int sentimentCount;
    final double sentimentPercent;


    SuggestionSentimentSummary({
        required this.sentiment,
        required this.sentimentCount,
        required this.sentimentPercent
    });


    factory SuggestionSentimentSummary.fromJson(Map<String, dynamic> jsonMap){
        return SuggestionSentimentSummary(
            sentiment: jsonMap['sentiment'],
            sentimentCount: jsonMap['sentiment_count'],
            sentimentPercent: jsonMap['sentiment_percent'].toDouble())
        ;
    }

}


class CourseEvaluationSuggestion{
    final List<SuggestionSentimentSummary> sentimentSummary;
    final List<Map<String, dynamic>> suggestionsMap;

    CourseEvaluationSuggestion({required this.sentimentSummary, required this.suggestionsMap});


    factory CourseEvaluationSuggestion.fromJson(Map<String, dynamic> jsonMap){
        return CourseEvaluationSuggestion(

            sentimentSummary: List<Map<String, dynamic>>.from(
                jsonMap['sentiment_summary']).map(
                    (sentimentJson) => SuggestionSentimentSummary.fromJson(sentimentJson)).toList(),

            suggestionsMap: List<Map<String, dynamic>>.from(jsonMap['suggestions'])
        );
    }
}



