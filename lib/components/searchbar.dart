import 'package:flutter/material.dart';

class Searchbar extends StatefulWidget {
  const Searchbar({
    Key? key,
    this.label = '',
    this.caption = '',
    required this.controller,
    required this.onSubmitted,
    required this.onChanged,
    required this.onClear,
    required this.focusNode,
  }) : super(key: key);

  final String label;
  final String caption;
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String text) onSubmitted;
  final Function(String text) onChanged;
  final Function() onClear;

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Color focusColor = widget.focusColor ?? Theme.of(context).primaryColor;

    Color captionColor = Theme.of(context).hintColor;

    InputDecoration defaultDecoration = InputDecoration(
      border: InputBorder.none,
      // focusColor: focusColor,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintText: widget.caption,
      hintStyle: TextStyle(color: captionColor),
      isDense: true,
    );

    Widget result = Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: captionColor,
              size: 18,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Center(
                child: TextField(
                  focusNode: widget.focusNode,
                  textInputAction: TextInputAction.search,
                  controller: widget.controller,
                  decoration: defaultDecoration,
                  // cursorColor: focusColor,
                  style: const TextStyle(fontSize: 13),
                  onSubmitted: widget.onSubmitted,
                  onChanged: widget.onChanged,
                ),
              ),
            ),
            if (widget.controller.text.isNotEmpty)
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: captionColor,
                  size: 18,
                ),
                splashRadius: 20,
                onPressed: () {
                  widget.controller.clear();
                  widget.onClear();
                },
              ),
          ],
        ),
      ),
    );

    return Semantics(
      container: true,
      textField: true,
      child: result,
    );
  }
}
