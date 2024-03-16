import 'package:flutter/material.dart';

class FilterAlert extends StatefulWidget {

  List<String> bookCategories;
  List<bool> chosenFilters;

  FilterAlert({Key? key,required this.chosenFilters,required this.bookCategories}) : super(key: key);

  @override
  State<FilterAlert> createState() => _FilterAlertState();
}

class _FilterAlertState extends State<FilterAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.of(context).pop(widget.chosenFilters);
        }, child: const Text("Apply filter"))
      ],
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/3,
        child: ListView(
          children: List.generate(widget.bookCategories.length, (categ){
            return ListTile(
              onTap: (){
                setState(() {
                  widget.chosenFilters[categ] = !widget.chosenFilters[categ];
                });
              },
              title: Text(widget.bookCategories[categ],style: const TextStyle(
                  color: Colors.black
              ),),
              leading: widget.chosenFilters[categ] ? const Icon(Icons.check,color: Colors.green,):const SizedBox.shrink(),
            );
          }),
        ),
      ),
    );
  }
}