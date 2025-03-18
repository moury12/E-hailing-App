import 'dart:io';

import 'package:flutter/material.dart';

const poppinsLight = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w300,
);

const poppinsExtraLight = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w200,
);

const poppinsThin = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w100,
);

const poppinsRegular = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w400,
);

const poppinsMedium = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w500,
);


const poppinsSemiBold = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w600,
);

const poppinsBold = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w700,
);

const poppinsExtraBold = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w800,
);

const poppinsBlack = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w900,
);

//==============custom text styles================
//------------------------------------------------

TextStyle regularText(double size, {Color color = Colors.black}) => TextStyle(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w400,
    );

TextStyle mediumText(double size, {Color color = Colors.black}) => TextStyle(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w500,
    );

TextStyle semiBoldText(double size, {Color color = Colors.black}) => TextStyle(
      fontSize: size,
      color: color,
      fontWeight: Platform.isIOS ? FontWeight.w500 : FontWeight.w600,
    );

TextStyle boldText(double size, {Color color = Colors.black}) => TextStyle(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w700,
    );

TextStyle extraBoldText(double size, {Color color = Colors.black}) => TextStyle(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w900,
    );
