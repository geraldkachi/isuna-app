import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LineManager extends ConsumerStatefulWidget {
  const LineManager({Key? key}) : super(key: key);

  @override
  _LineManagerState createState() => _LineManagerState();
}

class _LineManagerState extends ConsumerState<LineManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: Column(
          children: [
            InkWell(
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/back.svg',
                    height: 16,
                    color: const Color(0xff1B1C1E),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Line Manager",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
                  ),
                ],
              ),
              onTap: () {
                context.pop();
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Text(
                  'First Name: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 40.0,
                ),
                Text(
                  'Sandra',
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Text(
                  'Last Name: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 45.0,
                ),
                Text('James')
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Text(
                  'Email: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 80.0,
                ),
                Text('sandra@gmail.com')
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Text(
                  'Phone Number: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text('0903927800')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
