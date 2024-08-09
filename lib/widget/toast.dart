import 'package:flutter/material.dart';

class Toast extends StatelessWidget {
  final String title;
  final String subTitle;

  const Toast({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(14.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                // style: context.textTheme.bodyLarge?.copyWith(
                //   fontWeight: FontWeight.w600,
                //   color: Colors.white,
                // )
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: 200.0,
                child: Text(
                  subTitle,
                  // style: context.textTheme.bodySmall?.copyWith(
                  //   fontWeight: FontWeight.w600,
                  //   color: Colors.white,
                  // ),
                ),
              ),
            ],
          ),
          const Icon(Icons.close)
        ],
      ),
    );
  }
}
