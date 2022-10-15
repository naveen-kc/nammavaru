import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'app_button.dart';

class AlertBox extends StatefulWidget {
  String header;
  String description;
  String? yes;
  String? no;
  final VoidCallback okay;
  final VoidCallback? cancel;

  Color? backgroundColor;
  Color? textColor;

  AlertBox({
    Key? key,
    required this.header,
    required this.description,
    required this.okay,
    this.cancel,
    this.no,
    this.yes,
    this.backgroundColor,
    this.textColor

  }) : super(key: key);

  @override
  State<AlertBox> createState() => _AppDialogState();
}

class _AppDialogState extends State<AlertBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 0,
      backgroundColor:widget.backgroundColor==null?AppColors.white:widget.backgroundColor,
      child: contentBox(context),
    );
  }

  Stack contentBox(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding:
          const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  widget.header,
                  style: TextStyle(
                      fontFamily: 'OpenBold',
                      fontSize: 18.0,
                      color: widget.textColor==null? AppColors.black:widget.textColor),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  widget.description,
                  style: TextStyle(
                      fontFamily: 'OpenRegular',
                      fontSize: 25.0,
                      color: widget.textColor==null? AppColors.grey:widget.textColor),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                children: [
                  Button(
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(10),
                    textColor: AppColors.white,
                    backgroundColor: AppColors.black,
                    text:widget.no==null? 'No': widget.no!,
                    width: 120,
                    height: 15,
                    fontFamily: 'OpenMedium',
                    onPressed: () {
                      Navigator.pop(context, true);
                      widget.cancel!();
                    },
                  ),
                  Spacer(),
                  Button(
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(10),
                    textColor: AppColors.white,
                    backgroundColor: AppColors.black,
                    text: widget.yes==null? 'Yes': widget.yes!,
                    width: 120,
                    height: 15,
                    fontFamily: 'OpenMedium',
                    onPressed: () {
                      Navigator.pop(context, true);
                      widget.okay();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  void handleStack(String route) {
    Navigator.pop(context, true);
    Navigator.pushNamed(context, route);
  }
}
