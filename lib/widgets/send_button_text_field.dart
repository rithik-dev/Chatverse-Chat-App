import 'package:chatverse_chat_app/utilities/theme_handler.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SendButtonTextField extends StatefulWidget {
  final Function(String) onSend;

  SendButtonTextField({
    @required this.onSend,
  });

  @override
  _SendButtonTextFieldState createState() => _SendButtonTextFieldState();
}

class _SendButtonTextFieldState extends State<SendButtonTextField> {
  String _messageText;
  String _tempMessage;

  final TextEditingController _textEditingController = TextEditingController();

  stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      this._speech = stt.SpeechToText();
    });
  }

  @override
  void dispose() {
    super.dispose();
    this._textEditingController.dispose();
    this._speech.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      height: 70.0,
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: ThemeHandler.sendTextFieldBackgroundColor(context),
              ),
              child: TextField(
                controller: this._textEditingController,
                textCapitalization: TextCapitalization.sentences,
                textAlignVertical: TextAlignVertical.center,
                autofocus: true,
                onChanged: (String msg) {
                  setState(() {
                    this._messageText = msg;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Send a message ...",
                  border: InputBorder.none,
                  prefixIcon: IconButton(
                    icon: Icon(Icons.camera),
                    iconSize: 25.0,
                    onPressed: () {},
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.attach_file),
                    iconSize: 25.0,
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            radius: 25,
            backgroundColor: Theme.of(context).accentColor,
            child: AnimatedCrossFade(
              duration: Duration(milliseconds: 200),
              firstChild: IconButton(
                icon: Icon(this._isListening ? Icons.mic : Icons.mic_none),
                onPressed: this._listen,
              ),
              secondChild: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _tempMessage = this._messageText;
                  setState(() {
                    this._messageText = "";
                    this._textEditingController.clear();
                  });
                  return this.widget.onSend(_tempMessage);
                },
              ),
              crossFadeState: !this._isListening
                  ? (this._messageText == null ||
                          this._messageText.trim().length == 0)
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ),
        ],
      ),
    );
  }

  void _listen() async {
    if (!this._isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          setState(() {
            if (val == "listening") this._isListening = true;
            if (val == "notListening") this._isListening = false;
          });
        },
        onError: (val) {
          setState(() {
            this._isListening = false;
          });
        },
      );
      if (available) {
        setState(() => this._isListening = true);
        this._speech.listen(
              cancelOnError: true,
              onResult: (val) {
                setState(() {
                  this._messageText = val.recognizedWords;
                  this._textEditingController.text = val.recognizedWords;
                });
              },
            );
      }
    } else {
      setState(() => this._isListening = false);
      this._speech.stop();
    }
  }
}
