import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _controller = TextEditingController();

  void _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'szjlbaby2030@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Subject',
        'body': _controller.text,
      }),
    );

    try {
      bool launched = await launchUrl(emailLaunchUri);
      if (!launched) {
        throw 'Could not launch $emailLaunchUri';
      }
    } catch (e) {
      Logger.log(e.toString());
    }
  }

  String encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text("settings_feedback".localized),
          actions: [
            Container(
              padding: const EdgeInsets.only(right: 15),
              height: 36,
              child: ElevatedButton(
                onPressed: _sendEmail,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  fixedSize: const Size.fromHeight(30.0),
                ),
                child: Text(
                  'Submit'.localized,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
          child: TextField(
            controller: _controller,
            maxLines: null,
            maxLength: 1000,
            decoration: InputDecoration(
              hintText: 'Feedback_PlaceHolder'.localized,
            ),
            style: const TextStyle(
              fontSize: 16,
            ),
            keyboardType: TextInputType.multiline,
          ),
        ),
      ),
    );
  }
}
