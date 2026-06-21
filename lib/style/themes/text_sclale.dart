import 'package:flutter/material.dart';

double textScale(BuildContext context) {
  return switch(MediaQuery.widthOf(context)) {
    _ => 1.0
  };
}