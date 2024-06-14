import 'package:flutter/material.dart';

import '../../main.dart';
import 'custom_keyboard_handler.dart';

enum KeyType {
  key000('000'),
  key00('00'),
  key0('0'),
  key1('1'),
  key2('2'),
  key3('3'),
  key4('4'),
  key5('5'),
  key6('6'),
  key7('7'),
  key8('8'),
  key9('9'),
  keyDelete('Delete'),
  keyDone('Done');

  bool get isFunctionKey => (this == keyDelete) || (this == keyDone);

  const KeyType(this.value);

  final String value;
}

class CustomKeyboard extends StatefulWidget {
  const CustomKeyboard({super.key});

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  final double _defaultKeyboardHeight = 280;
  bool _isKeyboardShowing = false;
  TextEditingController _controller = TextEditingController();
  final _keys = [
    KeyType.key6,
    KeyType.key7,
    KeyType.key8,
    KeyType.key9,
    KeyType.key2,
    KeyType.key3,
    KeyType.key4,
    KeyType.key5,
    KeyType.key0,
    KeyType.key00,
    KeyType.key000,
    KeyType.key1,
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      CustomKeyboardHandler.customKeyboardStream.listen((event) {
        setState(() {
          _isKeyboardShowing = event.isKeyboardShowing;
          _controller = event.controller;
        });
      });
    });
    super.initState();
  }

  void _handleKeyPress(KeyType keyType) {
    final String currentText = _controller.text;
    String newText = currentText;
    final characterSelectedNum =
        _controller.selection.end - _controller.selection.start;
    int cursorPosition = _controller.selection.base.offset;
    if (keyType.isFunctionKey) {
      switch (keyType) {
        case KeyType.keyDelete:
          if (currentText.isNotEmpty && (_controller.selection.end > 0)) {
            int characterDeletedNum = characterSelectedNum;
            if (characterDeletedNum <= 1) {
              characterDeletedNum = 1;
            }
            final leftCursor = currentText.substring(
              0,
              _controller.selection.end - characterDeletedNum,
            );
            final rightCursor =
                currentText.substring(_controller.selection.end);
            newText = '$leftCursor$rightCursor';
            cursorPosition = _controller.selection.end - characterDeletedNum;
          }
          break;
        case KeyType.keyDone:
          dismissKeyboard(context);
          break;
        default:
          break;
      }
    } else {
      final String leftCursor = currentText.substring(
        0,
        _controller.selection.end - characterSelectedNum,
      );
      final addedWord = keyType.value;
      final rightCursor = currentText.substring(_controller.selection.end);
      cursorPosition = cursorPosition + addedWord.length - characterSelectedNum;
      newText = '$leftCursor$addedWord$rightCursor';
    }
    _controller
      ..text = newText
      ..selection = TextSelection.collapsed(
        offset: cursorPosition,
      );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isKeyboardShowing) {
      return const SizedBox.shrink();
    }
    double keyboardHeight =
        _defaultKeyboardHeight - MediaQuery.of(context).viewInsets.bottom;
    if (keyboardHeight < 0) {
      keyboardHeight = 0;
    }
    return SizedBox(
      height: keyboardHeight,
      child: Material(
        color: Colors.grey,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: _keys.map((e) => _keyWidget(e)).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    _bigKeyWidget(KeyType.keyDelete),
                    const SizedBox(height: 8),
                    _bigKeyWidget(KeyType.keyDone),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _keyWidget(KeyType keysType) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _handleKeyPress(keysType);
      },
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(keysType.value),
      ),
    );
  }

  Widget _bigKeyWidget(KeyType keysType) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _handleKeyPress(keysType);
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(keysType.value),
      ),
    );
  }
}
