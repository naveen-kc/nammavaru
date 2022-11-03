import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'app_button.dart';

class NoInternet extends StatefulWidget {
  String header;
  String description;
  String? move;

  NoInternet({
    Key? key,
    required this.header,
    required this.description,
    this.move,
  }) : super(key: key);

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 0,
      backgroundColor: AppColors.white,
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
                alignment: Alignment.topLeft,
                child: Text(
                  widget.header,
                  style: TextStyle(
                      fontFamily: 'HindBold',
                      fontSize: 18.0,
                      color: AppColors.black),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.description,
                  style: TextStyle(
                      fontFamily: 'OpenRegular',
                      fontSize: 25.0,
                      color: AppColors.grey),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Button(
                elevation: 0.0,
                borderRadius: BorderRadius.circular(10),
                textColor: AppColors.white,
                backgroundColor: AppColors.soil,
                text: 'Okay',
                width: MediaQuery.of(context).size.width,
                height: 20,
                fontFamily: 'OpenMedium',
                onPressed: () {
                  widget.move == null
                      ? Navigator.of(context).pop()
                      : handleStack(widget.move.toString());
                },
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  void handleStack(String route) {
    Navigator.popUntil(context, (route) => route.settings.name == route);
    Navigator.pushNamed(context, route);
  }
}
