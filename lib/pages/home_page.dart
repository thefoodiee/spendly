
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:spendly/services/line_chart.dart';
import 'package:spendly/pages/login_page.dart';

import 'package:spendly/services/sms_parsing.dart';

// Helper: Converts date strings like "04Apr25" into a DateTime object.

// ------------------ HOME PAGE CODE ------------------
class HomePage extends StatefulWidget {
  // final int budget;
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int primaryTextColor = 0xffffffff;
int bodyMediumColor = 0xffffffff;
int accent3Color = 0xff757575;
int secondaryTextColor = 0xff8b97a2;
int secondaryBackgroundColor = 0xff111417;
int errorColor = 0xffe21c3d;
int successColor = 0xff04a24c;

class _HomePageState extends State<HomePage> {
  int? budget;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  final args = ModalRoute.of(context)?.settings.arguments as Map?;
  budget ??= args?['budget']; // assign only once
}


  // ------------------ SMS Variables ------------------
  // MethodChannel to call native Android code.
  static const platform = MethodChannel('com.example.sms');
  List<TransactionInfo> _smsTransactions = [];
  bool _smsPermissionGranted = false;
  DateTime? _currentSmsMonth;

  @override
  void initState() {
    super.initState();
    _requestSmsPermissionAndFetch();
  }

  // ------------------ SMS Logic Methods ------------------
  Future<void> _requestSmsPermissionAndFetch() async {
    try {
      final bool permission =
          await platform.invokeMethod('requestSMSPermission');
      setState(() {
        _smsPermissionGranted = permission;
      });
      if (permission) {
        final List<dynamic> result = await platform.invokeMethod('getSMS');
        List<TransactionInfo> list = [];
        for (var item in result) {
          String body = item['body'] ?? "";
          list.add(parseSbiUpiMessage(body));
        }
        setState(() {
          _smsTransactions = list;
        });
        _setLatestSmsMonth();
      }
    } on PlatformException catch (e) {
      print("Failed to request SMS permission or fetch SMS: '${e.message}'.");
    }
  }

  // Determine the latest month from SMS transactions.
  void _setLatestSmsMonth() {
    DateTime? latest;
    for (var tx in _smsTransactions) {
      if (tx.dateTime != null) {
        if (latest == null || tx.dateTime!.isAfter(latest)) {
          latest = tx.dateTime;
        }
      }
    }
    if (latest != null) {
      setState(() {
        _currentSmsMonth = DateTime(latest!.year, latest.month);
      });
    } else {
      setState(() {
        _currentSmsMonth = DateTime.now();
      });
    }
  }

  // Get SMS transactions filtered by the selected month.
  List<TransactionInfo> get _filteredSmsTransactions {
    if (_currentSmsMonth == null) return _smsTransactions;
    return _smsTransactions.where((tx) {
      if (tx.dateTime == null) return false;
      return (tx.dateTime!.year == _currentSmsMonth!.year &&
          tx.dateTime!.month == _currentSmsMonth!.month);
    }).toList();
  }

  double get _totalDebit {
    return _filteredSmsTransactions
        .where((tx) => !tx.isCredit)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double get _totalCredit {
    return _filteredSmsTransactions
        .where((tx) => tx.isCredit)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  // double calcPercentage = budget

  // Change the currently selected month by delta (+1 for next, -1 for previous)

  // Build the floating buttons for month navigation.

  void _attemptChangeSmsMonth(int delta) {
    if (_currentSmsMonth == null) return;
    int newMonth = _currentSmsMonth!.month + delta;
    int newYear = _currentSmsMonth!.year;
    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }
    DateTime candidate = DateTime(newYear, newMonth);
    // Filter transactions for the candidate month.
    List<TransactionInfo> candidateTx = _smsTransactions.where((tx) {
      if (tx.dateTime == null) return false;
      return (tx.dateTime!.year == candidate.year &&
          tx.dateTime!.month == candidate.month);
    }).toList();
    if (candidateTx.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "No transactions found for ${candidate.month}/${candidate.year}"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        _currentSmsMonth = candidate;
      });
    }
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return "Unknown Date";
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = months[dateTime.month - 1];
    String year = dateTime.year.toString().substring(2); // last 2 digits
    return "$day $month $year";
  }

  @override
  Widget build(BuildContext context) {
    // Format the current SMS month for display (e.g., "3/2025")
    String monthYear = _currentSmsMonth != null
        ? "${_currentSmsMonth!.month}/${_currentSmsMonth!.year}"
        : "N/A";

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.light, // White icons
    ));

    return Scaffold(
      backgroundColor: Color(0xff1a1f24),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: Color(0xFF041322),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ––––– HEADER SECTION –––––
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 40, 16, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Logout",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.grey[850],
                                  content: Text(
                                      "Are you sure you want to logout?",
                                      style: TextStyle(color: Colors.white)),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text("Cancel",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // final GoogleSignIn googleSignIn =
                                        //     GoogleSignIn();
                                        // await googleSignIn.signOut();
                                        await FirebaseAuth.instance.signOut();

                                        await Future.delayed(
                                            const Duration(seconds: 1));
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const LoginAccount(),
                                          ),
                                        );
                                      },
                                      child: Text("Logout",
                                          style: TextStyle(
                                              color: Colors.red[700])),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Color(primaryTextColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: Container(
                                width: 50,
                                height: 50,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                    'assets/images/defualt-avatar.jpg'),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Welcome",
                                    style: TextStyle(
                                      fontFamily: 'Lexend',
                                      fontSize: 20,
                                      color: Color(primaryTextColor),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // ––––– SPENDS & INCOME SECTION –––––
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Spends",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(primaryTextColor),
                            fontFamily: 'Lexend',
                          ),
                        ),
                        Text(
                          "Income",
                          style: TextStyle(
                            fontFamily: 'Lexend',
                            color: Color(primaryTextColor),
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${_totalDebit.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'Lexend',
                            color: Color(primaryTextColor),
                          ),
                        ),
                        Text(
                          "₹${_totalCredit.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: 32,
                            color: Color(primaryTextColor),
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 5),
                      child: Text(
                        budget != null
                            ? "${((_totalDebit / budget!) * 100).toStringAsFixed(2)}% Budget Reached"
                            : "${((_totalDebit / 10000) * 100).toStringAsFixed(2)}% Budget Reached",
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w300,
                          color: Color(primaryTextColor),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 355,
                    child: Divider(
                      thickness: 1,
                      color: Color(0xffeeeeee),
                    ),
                  ),
                  // ––––– BUDGET SECTION –––––
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Overall Budget Set",
                          style: TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: 16,
                            color: Color(primaryTextColor),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "₹${budget ?? 10000}",
                              style: TextStyle(
                                fontFamily: 'Lexend',
                                fontSize: 14,
                                color: Color(primaryTextColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final updatedBudget = await Navigator.pushNamed(
                                    context, '/editBudget');
                                if (updatedBudget != null && mounted) {
                                  setState(() {
                                    budget = updatedBudget as int;
                                  });
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                "edit",
                                style: TextStyle(
                                  color: Color(secondaryTextColor),
                                  fontFamily: 'Lexend',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // ––––– CATEGORIES & CHARTS SECTION –––––
                  Container(
                      width: 350,
                      // height: 250,
                      child: _currentSmsMonth != null
      ? WeeklySpendChart(
          transactions: _smsTransactions,
          currentMonth: _currentSmsMonth!,
        )
      : SizedBox.shrink(),),

                  // ––––– TRANSACTION HISTORY SECTION (SMS Data) –––––
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF041322), Color(0xFF0D3B66)],
                            stops: [0.14, 0.9],
                            begin: AlignmentDirectional(0, -1),
                            end: AlignmentDirectional(0, 1),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display current SMS month in header.
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Transaction History ($monthYear)",
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: 14,
                                        color: Color(primaryTextColor),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              _attemptChangeSmsMonth(-1),
                                          child: Text(
                                            "Prev",
                                            style: TextStyle(
                                              fontFamily: 'Lexend',
                                              fontSize: 14,
                                              color: Color(primaryTextColor),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              _attemptChangeSmsMonth(1),
                                          child: Text(
                                            "Next",
                                            style: TextStyle(
                                              fontFamily: 'Lexend',
                                              fontSize: 14,
                                              color: Color(primaryTextColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // SMS Transactions List
                              _smsPermissionGranted
                                  ? ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          _filteredSmsTransactions.length,
                                      itemBuilder: (context, index) {
                                        final tx =
                                            _filteredSmsTransactions[index];
                                        return GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  title: Text(
                                                    'SMS Content',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor:
                                                      Colors.grey[850],
                                                  content: Text(
                                                    tx.raw,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: Text(
                                                        'Close',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .purple[50]),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 48,
                                                  height: 48,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .monetization_on_rounded,
                                                    size: 30,
                                                    color: tx.isCredit
                                                        ? Color(0xFF04A24C)
                                                        : Color(0xFFE21C3D),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              tx.name,
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              formatDate(
                                                                  tx.dateTime),
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Lexend',
                                                                color: Colors
                                                                    .white70,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        (tx.isCredit
                                                                ? "+\u{20B9}"
                                                                : "-\u{20B9}") +
                                                            tx.amount
                                                                .toStringAsFixed(
                                                                    2),
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color: tx.isCredit
                                                              ? Color(
                                                                  0xFF04A24C)
                                                              : Color(
                                                                  0xFFE21C3D),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Center(
                                        child: Text(
                                          'SMS Permission not granted.',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontFamily: 'Lexend',
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ SUPPORTING CLASSES ------------------
class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData({required this.x, required this.y, required this.color});
}
