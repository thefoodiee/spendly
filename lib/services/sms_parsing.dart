// ------------------ SMS TRANSACTION MODEL & PARSING ------------------
class TransactionInfo {
  final String date; // Raw date string (e.g., "04Apr25")
  final String name;
  final double amount;
  final bool isCredit;
  final DateTime? dateTime; // Parsed DateTime object
  final String raw;

  TransactionInfo({
    required this.date,
    required this.name,
    required this.amount,
    required this.isCredit,
    required this.dateTime,
    required this.raw
  });
}

DateTime? parseDate(String dateStr) {
  if (dateStr.length >= 7) {
    try {
      String dayStr = dateStr.substring(0, 2);
      String monStr = dateStr.substring(2, 5);
      String yrStr = dateStr.substring(5);
      int day = int.parse(dayStr);
      Map<String, int> monthMap = {
        "Jan": 1,
        "Feb": 2,
        "Mar": 3,
        "Apr": 4,
        "May": 5,
        "Jun": 6,
        "Jul": 7,
        "Aug": 8,
        "Sep": 9,
        "Oct": 10,
        "Nov": 11,
        "Dec": 12,
      };
      int month = monthMap[monStr] ?? 1;
      int year = int.parse(yrStr) + 2000;
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }
  return null;
}

/// Parses an SBI UPI SMS message to extract transaction info.
TransactionInfo parseSbiUpiMessage(String body) {
  bool isCredit = body.toLowerCase().contains('credited');
  bool isDebit = body.toLowerCase().contains('debited');

  double amount = 0.0;
  // Regex: makes optional the "Rs." prefix for both credit and debit.
  RegExp amountRegex = RegExp(
    r'(?:credited by\s?(?:Rs\.?)?|debited by\s?(?:Rs\.?)?)(\d+(\.\d+)?)',
    caseSensitive: false,
  );
  Match? amountMatch = amountRegex.firstMatch(body);
  if (amountMatch != null) {
    amount = double.tryParse(amountMatch.group(1)!) ?? 0.0;
  }

  String date = "";
  // Matches both "on date 04Apr25" and "on 26Dec24"
  RegExp dateRegex =
      RegExp(r'(?:on date |on )(\d+\w+\d+)', caseSensitive: false);
  Match? dateMatch = dateRegex.firstMatch(body);
  if (dateMatch != null) {
    date = dateMatch.group(1) ?? "";
  }
  DateTime? dt = parseDate(date);

  String name = "";
  RegExp nameRegexDebit = RegExp(r'trf to ([\w\s]+) Ref', caseSensitive: false);
  RegExp nameRegexCredit =
      RegExp(r'transfer from ([\w\s]+) Ref', caseSensitive: false);

  if (isDebit) {
    Match? match = nameRegexDebit.firstMatch(body);
    if (match != null) {
      name = match.group(1)?.trim() ?? "";
    }
  } else if (isCredit) {
    Match? match = nameRegexCredit.firstMatch(body);
    if (match != null) {
      name = match.group(1)?.trim() ?? "";
    }
  }
  if (name.isEmpty) {
    name = isCredit ? "Credit from Unknown" : "Debit to Unknown";
  }

  return TransactionInfo(
    date: date.isEmpty ? "Unknown Date" : date,
    name: name,
    amount: amount,
    isCredit: isCredit,
    dateTime: dt,
    raw: body
  );
}

class DailySpendData {
  final String day;
  final double amount;

  DailySpendData(this.day, this.amount);
}

List<DailySpendData> getDailySpendThisWeek(List<TransactionInfo> transactions) {
  DateTime now = DateTime.now();
  // Get start of the current week (Monday)
  DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

  List<TransactionInfo> thisWeekTransactions = transactions.where((tx) {
    if (tx.dateTime == null || tx.isCredit) return false; // ignore credits
    return tx.dateTime!.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
           tx.dateTime!.isBefore(endOfWeek.add(Duration(days: 1)));
  }).toList();

  // Init daily totals
  Map<int, double> dailyTotals = {
    1: 0, // Monday
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0, // Sunday
  };

  for (var tx in thisWeekTransactions) {
    int weekday = tx.dateTime!.weekday;
    dailyTotals[weekday] = (dailyTotals[weekday] ?? 0) + tx.amount;
  }

  const weekDayNames = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };

  return dailyTotals.entries
    .map((entry) => DailySpendData(weekDayNames[entry.key]!, entry.value))
    .toList();
}

