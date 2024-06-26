import 'package:flutter/material.dart';
import 'package:yildiz_app/order_class.dart';
import 'package:yildiz_app/database_service.dart';
import 'package:yildiz_app/localization.dart';

DatabaseService dbService = DatabaseService();

// Create an order object from the text field controllers
Order createOrder(
    TextEditingController nameC,
    TextEditingController addressC,
    TextEditingController phoneC,
    TextEditingController milkC,
    TextEditingController eggC,
    TextEditingController otherC) {
  return Order(
    name: nameC.text,
    address: addressC.text,
    phone: phoneC.text,
    milk: int.tryParse(milkC.text) ?? 0,
    egg: int.tryParse(eggC.text) ?? 0,
    other: otherC.text,
  );
}

// Handle sending an order to the database while showing a snackbar
Future<void> handleSendOrder(
    Order order, Function(Order) handleUndoOrder, context) async {
  bool success = await dbService.sendOrder(context, order);
  if (context.mounted) {
    showSnackBarWithUndo(
      success,
      l('order_success', context),
      l('order_fail', context),
      () => handleUndoOrder(order),
      context,
    );
  }
}

Future<bool> checkDatabaseConnection(BuildContext context) async {
  try {
    await dbService.ensureConnected(context);
    return true;
  } catch (e) {
    // ignore: use_build_context_synchronously
    showConnectionErrorDialog(e.toString(), context);
    return false;
  }
}

// Show snackbar after deleting an order
void deleteSelectedSnackbar(bool success, String successMessage,
    String errorMessage, VoidCallback onUndo, context) {
  final snackBar = SnackBar(
    content: Text(success ? successMessage : errorMessage),
    action: SnackBarAction(
      label: l('undo', context),
      onPressed: onUndo,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showConnectionErrorDialog(String message, context) {
  if (ModalRoute.of(context)?.isCurrent ?? false) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l('connection_error', context)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(l('close', context)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Show a snackbar with a message
void showSnackBar(BuildContext context, bool success, String successMessage,
    String failureMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(success ? successMessage : failureMessage),
    ),
  );
}

// Show a snackbar with a message and an undo action
void showSnackBarWithUndo(bool success, String successMessage,
    String failureMessage, Future<void> Function() undoCallback, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(success ? successMessage : failureMessage),
      action: success
          ? SnackBarAction(
              label: l('undo', context),
              onPressed: () async {
                await undoCallback();
              },
            )
          : null,
    ),
  );
}


// Custom text field widget
Widget customTextField({
  required TextEditingController controller,
  required String labelText,
  required TextInputType keyboardType,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
          errorMaxLines: 5,
        ),
        validator: validator),
  );
}
