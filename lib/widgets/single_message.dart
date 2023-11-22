import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';

class SingleMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;

  const SingleMessage(
      {super.key,
      required this.message,
      required this.isMe,
      required this.time});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 200),
          decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                message,
                style: textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 0.0,
                ),
                child: Text(
                  Utils.timeDiff(time: time),
                  style: textTheme.labelSmall!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
