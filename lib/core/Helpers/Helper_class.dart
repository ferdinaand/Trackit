import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String getFormattedTime(int seconds) {
  //the ~/ performs a truncation on the seconds, basically
  //if seconds is divisible by 60 it rounds the remainder of the fraction to 0
  //for instance 61 / 60 = 1 rem 1 this will return 1
  int minutes = seconds ~/ 60;

  //modulos here returns the remainder of a fraction
  //for instance 62 / 60 = 1 rem 2, this will return 2
  int remainingSeconds = seconds % 60;

  //this will return the truncated value of Minutes, hence we get the hours
  // int hours = minutes ~/ minutes;
// ${minutes >= 60 ? hours : ""}
  return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
}

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text =
        newValue.text.replaceAll(RegExp(r'[^0-9]'), ''); // Allow only digits

    if (text.length > 4) {
      text = text.substring(0, 4); // Limit to 4 characters
    }

    String formattedText = text;

    if (text.length >= 3) {
      formattedText = '${text.substring(0, 2)}:${text.substring(2)}';
    } else if (text.length >= 1) {
      formattedText = text;
    }

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class repsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text =
        newValue.text.replaceAll(RegExp(r'[^0-9]'), ''); // Allow only digits
    print(text.length);
    if (text.length > 2) {
      text = text.substring(0, 3); // Limit to 2 characters
    }

    String formattedText = text;

    if (text.length >= 3) {
      formattedText = '${text.substring(1)}${text.substring(3)}';
    } else if (text.length == 1) {
      formattedText = text;
    }

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove non-numeric characters
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Ensure the number starts with +234
    if (text.startsWith('234')) {
      text = text.substring(3); // Remove the leading '234' if typed manually
    }

    // Limit to 10 digits after +234
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    String formattedText = '+234$text';

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class IncomeInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,##0");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-digit characters
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Format number with commas
    String formattedText = _formatter.format(int.tryParse(text) ?? 0);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
