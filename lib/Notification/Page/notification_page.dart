import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static const route = "notification-screen";

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)?.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.notificationPage,
          style:
              getBoldStyle(color: ColorManager.white, fontSize: FontSize.s27),
        ),
        leading: IconButton(
          icon: Image.asset(ImageAssets.backButton),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Card(
            child: Container(
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: "title",
                      style: const TextStyle(color: Colors.red),
                      children: [
                        TextSpan(text: "${message.notification!.title}"),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Body",
                      style: const TextStyle(color: Colors.red),
                      children: [
                        TextSpan(text: "${message.notification!.body}"),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "title",
                      style: const TextStyle(color: Colors.red),
                      children: [
                        TextSpan(text: "${message.data}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
