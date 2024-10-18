import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math'; // Import to use the min function
import '../components/quiztype_button.dart';
import '../data/quiz_data.dart';
import 'globals.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'result_history_page.dart';

class HomePage extends StatefulWidget {
  dynamic listfromresult;

  HomePage({Key? key, this.listfromresult})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic listfromresult;
  bool isFirstAttempt = true;

  // Variables to store the last attempt data for each quiz
  int countingResult = 0;
  int coloringResult = 0;
  int calculationResult = 0;


  @override
  void initState() {
    super.initState();
    initializeApp(); // Initialize app to load UID and fetch quiz data
  }

  Future<void> initializeApp() async {
    await loadGlobalUid(); // Wait for global UID to be loaded
    fetchLastAttemptData(); // Fetch the last attempt data only after loading the UID
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch the latest data every time the HomePage is reloaded
    fetchLastAttemptData();
  }

  Future<void> submitQuizAttempt() async {
    // Submit the quiz attempt logic

    // After the attempt is successfully submitted, fetch the last attempt data again
    await fetchLastAttemptData();
  }


  Future<void> fetchLastAttemptData() async {
    if (globalUid == null) return; // Ensure UID is available
    String url = '$apiUrl/result_history';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"uid": globalUid}),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("User Results: $data");

        // Update state with the last attempt data
        setState(() {
          countingResult = data['counting_results'].isNotEmpty
              ? data['counting_results'].last
              : 0;
          coloringResult = data['coloring_results'].isNotEmpty
              ? data['coloring_results'].last
              : 0;
          calculationResult = data['calculation_results'].isNotEmpty
              ? data['calculation_results'].last
              : 0;
        });

      } else {
        print("Failed to load results from getresults.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }



  // Sign out method placeholder (replace this with your actual logout logic)
  void signUserOut(BuildContext context) async {
    await logout(context); // Use the global logout function
  }

  // Method to fetch user results when history button is clicked
  Future<void> getResults(BuildContext context) async {
    String url = '$apiUrl/result_history';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"uid": globalUid}),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("User Results: $data");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultHistoryPage(uid: globalUid),
          ),
        );
      } else {
        print("Failed to load results from getresults.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF6F6F6),
          image: DecorationImage(
            image: AssetImage('lib/images/background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.1),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(height: 45),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 180.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: Colors.black, width: 2.0),
                  ),
                  child: Center(
                    child: Text(
                      "Hi there!",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: AutofillHints.birthdayDay,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                PopupMenuButton(
                  child: ClipRRect(
                    child: Icon(
                      Icons.account_circle,
                      size: 80,
                    ),
                  ),
                  onSelected: (value) {
                    if (value == "profile") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    } else if (value == "settings") {
                      // add desired output
                    } else if (value == "logout") {
                      signUserOut(context);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      value: "profile",
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.account_circle),
                          ),
                          const Text(
                            'Profile',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "logout",
                      child: Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.logout)),
                          const Text(
                            'Logout',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            // Show CarouselSlider whether there is data or not
            CarouselSlider(
              items: [
                buildQuizResult("Counting", countingResult, 5),
                buildQuizResult("Coloring", coloringResult, 5),
                buildQuizResult("Calculation", calculationResult, 5),
              ],
              options: CarouselOptions(
                height: 200.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              child: Column(
                children: [
                  Text(
                    'Quizzes',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: AutofillHints.birthdayDay,
                        fontSize: 25.0,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Hey champ! Step into a world of wonder! Join our Quiz Wizards, where learning feels like play. Embrace fun challenges, and let your smiles light the way to knowledge and excitement!',
                    style: TextStyle(
                        fontFamily: AutofillHints.birthday,
                        fontSize: 12.0,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
                child: buildQuizButtons(context),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildQuizResult(String quizType, int? result, int totalQuestions) {
    int correct = ((result ?? 0) * 5 / 100).round(); // Convert the percentage to an integer value
    int incorrect = 5 - correct;


    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              const SizedBox(width: 15),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    buildQuizHeader(quizType),
                    const SizedBox(height: 12),
                    buildQuizStats(correct, incorrect, totalQuestions),
                  ],
                ),
              ),
              const SizedBox(width: 25),
              buildCircularPercentIndicator(correct*20, totalQuestions),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildQuizHeader(String quizType) {
    return Container(
      height: 26,
      width: 91,
      decoration: BoxDecoration(
        color: Color(0xFF373737),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          quizType,
          style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: AutofillHints.birthday),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildQuizStats(int correct, int incorrect, int totalQuestions) {
    return Container(
      height: 100,
      width: 90,
      decoration: BoxDecoration(
        color: Color(0xFFEBC272),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          " Total Questions: $totalQuestions \n \n Correct: $correct \nIncorrect: $incorrect",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildCircularPercentIndicator(int correct, int totalQuestions) {
    double percentage = totalQuestions > 0 ? min(correct / totalQuestions / 20, 1.0) : 0.0;

    return CircularPercentIndicator(
      radius: 70.0,
      lineWidth: 12.0,
      percent: percentage,  // Set the percentage divided by 20
      center: Text(
        "${(percentage * 100).toStringAsFixed(2)}%", // Display the percentage value correctly
        style: TextStyle(fontSize: 16.0),
      ),
      progressColor: Color(0xFFEBC272),
      backgroundColor: Color(0xFF373737),
    );
  }


  Widget buildQuizButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            QuizTypeButton(
              button_color: Color(0xFFCFFFDF),
              button_text: 'Counting',
              questions: questions_count,
              quizType: 'counting',
              buttonImage: 'lib/images/counting_button_img.png',
            ),
            QuizTypeButton(
              button_color: Color.fromARGB(255, 255, 213, 231),
              button_text: "Coloring",
              questions: questions_color,
              quizType: 'coloring',
              buttonImage: 'lib/images/coloring_button_img.png',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            QuizTypeButton(
              button_color: Color(0xFFD4DDFF),
              button_text: 'Calculation',
              questions: questions_calculation,
              quizType: 'calculate',
              buttonImage: 'lib/images/calculation_button_img.png',
            ),
            buildResultHistoryButton(context),
          ],
        ),
      ],
    );
  }

  Widget buildResultHistoryButton(BuildContext context) {
    return Container(
      width: 145,
      height: 145,
      decoration: BoxDecoration(
        color: Color(0xFF373737),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () async {
          await getResults(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 26,
              width: 110,
              decoration: BoxDecoration(
                color: Color(0xFFEBC272),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "Results History",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 25),
            Transform.scale(
              scale: 1.75,
              child: Image.asset(
                'lib/images/results_button_img.png',
                height: 40,
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
