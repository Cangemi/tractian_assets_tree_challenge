import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String status;
  final String type;
  final List<Widget> children;
  bool isExpanded;
  bool hasChild;

  CustomExpansionTile(
      {required this.title,
      required this.children,
      required this.status,
      required this.isExpanded,
      required this.hasChild,
      required this.type});

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    if (widget.isExpanded) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isExpanded) {
      _controller.forward();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              widget.isExpanded = !widget.isExpanded;
              if (widget.isExpanded) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.hasChild
                  ? Icon(
                      widget.isExpanded ? Icons.expand_less : Icons.expand_more)
                  : const SizedBox.shrink(),
               const SizedBox(
                width: 2,
              ),
              Image.asset(
                widget.type == "location"
                    ? 'icons/location.png'
                    : widget.type == "asset"
                        ? "icons/asset.png"
                        : "icons/component.png",
                height: 22,
                width: 22,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff17192D),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              widget.status == "operating"
                  ? const Icon(
                      Icons.bolt,
                      color: Color(0xff52C41A),
                      size: 18,
                    )
                  : widget.status == "alert"
                      ? const Icon(
                          Icons.circle,
                          color: Color(0xffED3833),
                          size: 10,
                        )
                      : const SizedBox.shrink(),
            ],
          ),
        ),
        if (widget.isExpanded)
          SizeTransition(
            sizeFactor: _heightFactor,
            axisAlignment: -1.0,
            child: Container(
              margin: const EdgeInsets.only(left: 12),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 16),
                child: Container(
                  margin: const EdgeInsets.only(left: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.children,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
