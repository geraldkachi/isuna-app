import 'package:flutter/material.dart';
import 'package:misau/app/theme/colors.dart';

class LoadingDialog extends StatefulWidget {
  LoadingDialog({Key? key}) : super(key: key);

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      // padding: EdgeInsets.all(40.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Spacer(),
          Center(
            child: Stack(
              children: [
                SizedBox(
                  height: 100.0,
                  width: 100.0,
                  child: FittedBox(
                      child: CircularProgressIndicator(
                    color: red,
                    strokeCap: StrokeCap.round,
                    strokeWidth: 2,
                  )),
                ),
                Positioned(
                  left: 23.0,
                  top: 23.0,
                  child: Image.asset(
                    'assets/png/logo.png',
                    scale: 1.5,
                  ),
                )
              ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}
