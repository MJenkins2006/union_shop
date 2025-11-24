import 'package:flutter/material.dart';

Widget buildFooter(BuildContext context) {
  void placeholderCallbackForButtons() {}

  return Container(
    padding: const EdgeInsets.all(16),
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(children: [
          Text("""
Opening Hours
❄️ Winter Break Closure Dates ❄️
Closing 4pm 19/12/2025
Reopening 10am 05/01/2026
Last post date: 12pm on 18/12/2025
------------------------
(Term Time)
Monday - Friday 10am - 4pm
(Outside of Term Time / Consolidation Weeks)
Monday - Friday 10am - 3pm
Purchase online 24/7
"""),
        ]),
        const Column(children: [
          Text("""
Search

Terms & Conditions of Sale Policy
""")
        ]),
        Column(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Latest Offers'),
              const SizedBox(
                width: 150,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email Address',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: placeholderCallbackForButtons,
                child: const Text('SUBSCRIBE'),
              ),
            ],
          )
        ]),
      ],
    ),
  );
}
