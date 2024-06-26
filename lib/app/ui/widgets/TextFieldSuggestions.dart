import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldSuggestions extends StatefulWidget {
  final List<String> list;
  final Function returnedValue;
  final Function onTap;
  final double height;
  final String labelText;
  final Color textSuggetionsColor;
  final Color suggetionsBackgroundColor;
  final Color outlineInputBorderColor;
  const TextFieldSuggestions(
      {Key? key,
      required this.list,
      required this.labelText,
      required this.textSuggetionsColor,
      required this.suggetionsBackgroundColor,
      required this.outlineInputBorderColor,
      required this.returnedValue,
      required this.onTap,
      required this.height})
      : super(key: key);

  @override
  _TextFieldSuggestionsState createState() => _TextFieldSuggestionsState();
}

class _TextFieldSuggestionsState extends State<TextFieldSuggestions> {
  int flag = 0;
  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
    flag = 0;
  }

  @override
  void dispose() {
    super.dispose();
    //widget.list.clear();
    flag = 0;
  }

  @override
  Widget build(BuildContext context){
    if (flag == 0){
      height = widget.height;
    }

    // double height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    var ExtraSmallScreenGrid = width < 460;
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        //widget.returnedValue(value.text.toLowerCase()); Retirado para garantir perfomance
        // When the field is empty
        if (value.text.isEmpty) {
          widget.returnedValue("");
          return [];
        }
        // The logic to find out which ones should appear
        return widget.list
            .where((suggestion) => suggestion.toLowerCase().contains(value.text.toLowerCase()));
      },
      // onSelected: (value) {
      //   setState(() {
      //     //_selectedAnimal = value;
      //   });
      // },
      fieldViewBuilder: (BuildContext context, textEditingController,
          FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return Container(
          height: 40.0,
          //width: width * (ExtraSmallScreenGrid ? 1 : 0.4),
          child: TextField(
            cursorColor: Colors.black,
            controller: textEditingController,
            focusNode: focusNode,
            textCapitalization: TextCapitalization.sentences,
            //scrollPadding: const EdgeInsets.only(bottom: 200),
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              prefixIcon: const Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 10.0,
                  bottom: 2.0,
                ),
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 16.0,
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFEEEEEEE),
              contentPadding: const EdgeInsets.only(left: 25.0, top: 30.0),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  borderSide: BorderSide.none),
              hintStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.grey,
                fontSize: 15.0,
              ),
              hintText: widget.labelText,
            ),
            onSubmitted: (String value) {
              if (value.isNotEmpty) {
                onFieldSubmitted();
                widget
                    .returnedValue(textEditingController.text.toLowerCase());
              }else{
                widget
                    .returnedValue("");
              }
              setState(() {
                flag = 1;
                height = 0;
              });
              FocusScope.of(context).unfocus();
            },
            onChanged: (text) {
              setState(() {
                flag = 0;
              });
            },
            onTap: () {
              widget.onTap();
            },
          ),
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected,
          Iterable<String> options) {
        return Container(
          width: width * (ExtraSmallScreenGrid ? 0.85 : 0.4),
          margin: const EdgeInsets.only(top: 5),
          child: Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 2,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              color: Colors.white,
              child: SizedBox(
                width: width * (ExtraSmallScreenGrid ? 0.85 : 0.4),
                height: options.length == 1
                    ? 85
                    : options.length == 2
                        ? 150
                        : 200,
                child: ListView.builder(
                    // shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                          widget.returnedValue(option.toLowerCase());
                          FocusScope.of(context).unfocus();
                          setState(() {
                            flag = 1;
                            height = 0;
                          });
                        },
                        child: ListTile(
                          title: Text(
                            option,
                            maxLines: 3,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontFamily: 'Quicksand',
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
        );
      },
    );
  }
}
