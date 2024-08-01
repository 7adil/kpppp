import 'package:flutter/material.dart';

class AccountWidget extends StatelessWidget {
  final String title;
  final String amount;
  final Color bgColor;
  const AccountWidget({super.key,required this.title,required this.amount,required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(title,style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.black
        ),),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: 50,
          width: 180,
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10)
          ),
          child:  Center(
            child: Text(amount,style: const TextStyle(
                color: Colors.white,fontSize: 16,
                fontWeight: FontWeight.w700
            ),),
          ),
        )
      ],
    );
  }
}
