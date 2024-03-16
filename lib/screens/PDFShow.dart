import 'package:ebook/models/Book.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFShow extends StatefulWidget {
  Book book;
  PDFShow({Key? key,required this.book}) : super(key: key);

  @override
  State<PDFShow> createState() => _PDFShowState();
}

class _PDFShowState extends State<PDFShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height/8,
        title: Text(widget.book.name.toString(),style: const TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SfPdfViewer.network(widget.book.bookLink.toString())
      ),
    );
  }
}