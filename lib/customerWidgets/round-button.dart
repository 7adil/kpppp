
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:untitled/provider/backend-provider.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  final double?width;
  final double?height;
  final Color?textColor;
  final Color? bgColor;
  final double? btnTextSize;
  final bool? isLoad;
  const RoundButton({
    super.key,
    required this.title,
    required this.onTap,
    this.loading=false,
    this.isLoad=false,
    this.width,
    this.height,
    this.textColor,
    this.bgColor,
    this.btnTextSize
  });
  @override
  Widget build(BuildContext context) {
    return Consumer<BackendProvider>(builder: (context,statusProvider,child){
      return InkWell(
        onTap: onTap,
        child: Container(
          height:height?? 42,
          width:width?? 360,
          decoration: BoxDecoration(

              color:bgColor?? Colors.purple,

              borderRadius: BorderRadius.circular(11)
          ),
          child: Center(
            child: statusProvider.isLoading &&isLoad==true?const SpinKitFadingFour(color: Colors.white,size: 20,)
                : Text(
              title,
              style: TextStyle(
                  color: textColor??Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize:btnTextSize??14,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),

      );
    });
  }
}