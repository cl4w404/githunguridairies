import 'dart:math';
import 'package:flutter/material.dart';

String generateTransactionID(int length) {
  String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  String string = '';
  for (int i = 0; i < length; i++) {
    string += chars[Random().nextInt(chars.length)];
  }
  return string;
}