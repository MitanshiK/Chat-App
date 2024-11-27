import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

Future<void> _requestPermission() async {
  if (await Permission.contacts.request().isGranted) {
    debugPrint('Contact permission granted');
  } else {
    debugPrint('Contact permission denied');
  }
}


void _addContact() async {
  // Request permissions if not granted
  await _requestPermission();

  if (await Permission.contacts.isGranted) {
    // Create a new contact
    Contact newContact = Contact(
      name: Name(first: 'John', last: 'Doe'),
      phones: [Phone('1234567890', label: PhoneLabel.mobile)],
       
    );

    try {
      // Add the contact to the device's contact list
      await FlutterContacts.insertContact(newContact);
      debugPrint('Contact added successfully');
    } catch (e) {
      debugPrint('Failed to add contact: $e');
    }
  } else {
    debugPrint('Contact permission not granted');
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Add Contact Example'),
    ),
    body: Center(
      child: ElevatedButton(
        onPressed: _addContact,
        child: const Text('Add Contact'),
      ),
    ),
  );
}
}