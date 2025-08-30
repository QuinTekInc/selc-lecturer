

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


    ClassCourse({
        required this.classCourseId,
        required this.courseCode,
        required this.courseTitle,
        required this.creditHours,
        required this.semester,
        required this.year,
        this.meanScore = 0,
        required this.remark,
        required this.hasOnline
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
            hasOnline: jsonMap['has_online'] ?? false
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


class Question{
    final int questionId;
    final String question;
    final AnswerType answerType;

    Question({
        required this.questionId,
        required this.question,
        required this.answerType
    });
}