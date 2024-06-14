import 'custom_keyboard_handler.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? inputType;
  final bool isUseCustomKeyBoard;
  final String? hintText;
  final String? labelText;

  const CustomTextField({
    this.controller,
    this.focusNode,
    this.inputType,
    this.isUseCustomKeyBoard = false,
    this.hintText,
    this.labelText,
    super.key,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _handleCustomKeyboard();
    super.initState();
  }

  void _handleCustomKeyboard() {
    if (widget.isUseCustomKeyBoard) {
      _focusNode.addListener(() {
        CustomKeyboardHandler.onFocusChangeHandler(
          CustomKeyboardHandlerData(
            isKeyboardShowing: _focusNode.hasFocus,
            controller: _controller,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.clear();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.isUseCustomKeyBoard ? true : false,
      controller: _controller,
      focusNode: _focusNode,
      keyboardType:
          widget.isUseCustomKeyBoard ? TextInputType.none : widget.inputType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12)
      ),
    );
  }
}