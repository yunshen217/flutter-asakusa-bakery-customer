import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_client/common/custom_widget.dart';
import 'package:shopping_client/view/BaseScaffold.dart';

class A extends StatefulWidget {
  @override
  _AutoFillFormExampleState createState() => _AutoFillFormExampleState();
}

class _AutoFillFormExampleState extends State<A> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();




  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: customWidget.setAppBar(title: "data",isLeftShow: false),
      body:CalendarPage()

      //
      // AutofillGroup(
      //   child: Form(
      //     key: _formKey,
      //     autovalidateMode: AutovalidateMode.onUserInteraction,
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         TextFormField(
      //           controller: _emailController,
      //           decoration: const InputDecoration(
      //             labelText: 'Username',
      //           ),
      //           autofillHints: const [AutofillHints.username],
      //           validator: (value) {
      //             if (value == null || value.isEmpty) {
      //               return 'Please enter your username';
      //             }
      //             return null;
      //           },
      //         ),
      //         TextFormField(
      //           controller: _passwordController,
      //           decoration: const InputDecoration(
      //             labelText: 'Password',
      //           ),
      //           obscureText: true,
      //           autofillHints: const [AutofillHints.password],
      //           validator: (value) {
      //             if (value == null || value.isEmpty) {
      //               return 'Please enter your password';
      //             }
      //             return null;
      //           },
      //         ),
      //         TextFormField(
      //           controller: _emailController,
      //           decoration: const InputDecoration(
      //             labelText: 'Email',
      //           ),
      //           autofillHints: const [AutofillHints.email],
      //           validator: (value) {
      //             if (value == null || value.isEmpty) {
      //               return 'Please enter your email';
      //             }
      //             if (!RegExp(
      //                     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      //                 .hasMatch(value)) {
      //               return 'Please enter a valid email';
      //             }
      //             return null;
      //           },
      //         ),
      //         ElevatedButton(
      //           onPressed: () {
      //             if (_formKey.currentState!.validate()) {
      //               String username = _emailController.text;
      //               String password = _passwordController.text;
      //               String email = _emailController.text;
      //               print('Username: $username, Password: $password, Email: $email');
      //               // 这里可以添加实际的表单提交逻辑
      //             }
      //           },
      //           child: const Text('Submit'),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int currentYear = DateTime.now().year;
  final PageController _pageController = PageController(
    initialPage: DateTime.now().year - 2000,
  );

// 判断是否为闰年
  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

// 获取指定月份的天数
  int daysInMonth(int year, int month) {
    const List<int> days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && isLeapYear(year)) {
      return 29;
    }
    return days[month - 1];
  }

// 获取指定日期是星期几（0 表示星期日，1 - 6 分别表示星期一 - 星期六）
  int dayOfWeek(int year, int month, int day) {
    if (month < 3) {
      month += 12;
      year--;
    }
    int c = year ~/ 100;
    year %= 100;
    int w = (c ~/ 4 - 2 * c + year + year ~/ 4 + 13 * (month + 1) ~/ 5 + day - 1) % 7;
    return (w + 7) % 7;
  }
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          currentYear = index + 2000;
        });
      },
      itemBuilder: (context, index) {
        return buildYearCalendar(index + 2000);
      },
    );
  }
  // 构建一年的日历
  Widget buildYearCalendar(int year) {
    return Column(
      children: [
        Text(
          '$year',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: 150
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return buildMonthCalendar(year, index + 1);
            },
          ),
        ),
      ],
    );
  }
  // 构建一个月的日历
  Widget buildMonthCalendar(int year, int month) {
    const List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   '${monthNames[month - 1]} $year',
        //   style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        // ),
        // const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Su',style: TextStyle(fontSize: 8),),
            Text('Mo',style: TextStyle(fontSize: 8),),
            Text('Tu',style: TextStyle(fontSize: 8),),
            Text('We',style: TextStyle(fontSize: 8),),
            Text('Th',style: TextStyle(fontSize: 8),),
            Text('Fr',style: TextStyle(fontSize: 8),),
            Text('Sa',style: TextStyle(fontSize: 8),),
          ],
        ),
        const SizedBox(height: 4),
        Column(
          children: [
            for (int week = 0; week < 6; week++)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int dayOfWeekIndex = 0; dayOfWeekIndex < 7; dayOfWeekIndex++)
                    Builder(
                      builder: (context) {
                        int day = week * 7 + dayOfWeekIndex - dayOfWeek(year, month, 1) + 1;
                        if (day < 1 || day > daysInMonth(year, month)) {
                          return const Text('  ',style: TextStyle(fontSize: 8),);
                        }
                        return Text(day.toString(),style: TextStyle(fontSize: 8),);
                      },
                    ),
                ],
              ),
          ],
        ),
      ],
    );

  }
}
