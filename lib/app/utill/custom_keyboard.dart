import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';
import 'custom_keyboard_handler.dart';

enum KeyType {
  key000('000'),
  keydelate('<-'),
  key0('0'),
  key1('1'),
  key2('2'),
  key3('3'),
  key4('4'),
  key5('5'),
  key6('6'),
  key7('7'),
  key8('8'),
  key9('9');

  const KeyType(this.value);

  final String value;
}

class CustomKeyboard extends StatefulWidget {
  const CustomKeyboard({super.key});

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  final double _defaultKeyboardHeight = 300.h;
  bool _isKeyboardShowing = false;
  TextEditingController _controller = TextEditingController();
  final _keys = [
    KeyType.key1,
    KeyType.key2,
    KeyType.key3,
    KeyType.key4,
    KeyType.key5,
    KeyType.key6,
    KeyType.key7,
    KeyType.key8,
    KeyType.key9,
    KeyType.key000,
    KeyType.key0,
    KeyType.keydelate,
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
    if (keyType == KeyType.keydelate) {
      if (currentText.isNotEmpty && (_controller.selection.end > 0)) {
        final leftCursor =
            currentText.substring(0, _controller.selection.end - 1);
        final rightCursor = currentText.substring(_controller.selection.end);
        newText = '$leftCursor$rightCursor';
        cursorPosition = _controller.selection.end - 1;
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
      child: GestureDetector(
        onTap: () {
          dismissKeyboard(context);
        },
        child: Material(
          color: Colors.grey,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left :10.w, right:10.w,bottom: 10.h, top:10.h),
                    child: Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.spaceEvenly,
                      children: _keys.map((e) => _keyWidget(e)).toList(),
                    ),
                  ),
                ),
              ],
            ),
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
        width: 100.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(keysType.value),
      ),
    );
  }

  Widget bigKeyWidget(KeyType keysType) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _handleKeyPress(keysType);
      },
      child: Container(
        width: 100.w,
        height: 100.h,
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
