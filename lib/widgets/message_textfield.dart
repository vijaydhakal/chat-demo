import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;

  const MessageTextField(this.currentId, this.friendId, {super.key});

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "Type your Message..",
              fillColor: const Color.fromARGB(255, 225, 225, 225),
              filled: true,
              isDense: true,
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 0),
                gapPadding: 10,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          )),
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              _controller.clear();
              await FirebaseFirestore.instance
                  .collection('user')
                  .doc(widget.currentId)
                  .collection('messages')
                  .doc(widget.friendId)
                  .collection('chats')
                  .add({
                "senderId": widget.currentId,
                "receiverId": widget.friendId,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('user')
                    .doc(widget.currentId)
                    .collection('messages')
                    .doc(widget.friendId)
                    .set({'last_msg': message, "date": DateTime.now()});
              });

              await FirebaseFirestore.instance
                  .collection('user')
                  .doc(widget.friendId)
                  .collection('messages')
                  .doc(widget.currentId)
                  .collection("chats")
                  .add({
                "senderId": widget.currentId,
                "receiverId": widget.friendId,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('user')
                    .doc(widget.friendId)
                    .collection('messages')
                    .doc(widget.currentId)
                    .set({"last_msg": message, "date": DateTime.now()});
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.send,
                color: Colors.black,
                size: 25,
              ),
            ),
          )
        ],
      ),
    );
  }
}
