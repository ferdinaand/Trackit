import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:TrackIt/global_widgets/notification_snackbar.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
  VoidCallback? onFailure,
  required VoidCallback updateState,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 201:
      onSuccess();
      break;
    case 400:
      ShowNotificationSnack.showError(
          context, "Error", jsonDecode(response.body).toString());
      onFailure!();
      updateState();

      break;
    case 401:
      ShowNotificationSnack.showError(
          context, "Error", jsonDecode(response.body).toString());
      onFailure!();
      updateState();

      break;
    case 404:
      ShowNotificationSnack.showError(
          context, "Error", jsonDecode(response.body).toString());
      onFailure!();
      updateState();
      break;
    case 409:
      ShowNotificationSnack.showError(
          context, "Error", jsonDecode(response.body).toString());
      onFailure!();
      updateState();
      break;

    default:
      ShowNotificationSnack.showError(context, "Error", response.body);
  }
}

// void httpErrorHandleForBills({
//   required http.Response response,
//   required BuildContext context,
//   required VoidCallback onSuccess,
//   required VoidCallback updateState,
// }) {
//   switch (response.statusCode) {
//     case 200:
//       HapticFeedback.lightImpact();
//       onSuccess();
//       break;
//     case 400:
//       HapticFeedback.lightImpact();
//       bottomSheetError(context, jsonDecode(response.body)['message']);
//       updateState();
//       break;

//     case 401:
//       HapticFeedback.lightImpact();
//       bottomSheetError(context, jsonDecode(response.body)['message']);
//       updateState();
//       break;


//     case 409:
//       HapticFeedback.lightImpact();
//       bottomSheetError(context, jsonDecode(response.body)['message']);
//       updateState();
//       break;

//     case 500:
//       HapticFeedback.lightImpact();
//       bottomSheetError(context, jsonDecode(response.body)['message']);
//       updateState();
//       break;

//     default:
//       bottomSheetError(context, jsonDecode(response.body)['error']);
//       updateState();
//   }
// }

// void httpErrorHandleForBVN({
//   required http.Response response,
//   required BuildContext context,
//   required VoidCallback onSuccess,
//   required VoidCallback updateState,
// }) {
//   switch (response.statusCode) {
//     case 200:
//       HapticFeedback.lightImpact();
//       onSuccess();
//       updateState();
//       break;
//     case 400:
//       HapticFeedback.lightImpact();

//       bottomSheetError(context, jsonDecode(response.body)['message']);
//       break;
//     case 401:
//       HapticFeedback.lightImpact();
//       bottomSheetError(context, jsonDecode(response.body)['message']);
//       break;
//     case 404:
//       HapticFeedback.lightImpact();
//       bottomSheetError(context, jsonDecode(response.body)['error']);
//       updateState();
//       break;
//     case 409:
//       HapticFeedback.lightImpact();
//       bottomSheetError(context, jsonDecode(response.body)['error']);
//       updateState();
//       break;

//     default:
//       bottomSheetError(context, jsonDecode(response.body)['message']);
//   }
// }
