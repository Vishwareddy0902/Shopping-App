import 'dart:ui';

import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key key}) : super(key: key);
  static const IconData currency_rupee_sharp =
      IconData(0xf03ed, fontFamily: 'MaterialIcons');

  static final String routeName = 'EditProductScreen';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImage);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImage);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void updateImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
              child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  label: Text('Title'),
                  icon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text('Price'),
                  icon: Icon(EditProductScreen.currency_rupee_sharp),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text('Description'),
                  icon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.newline,
                maxLines: 3,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text('Image URL'),
                  icon: Icon(Icons.image),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                controller: _imageUrlController,
                focusNode: _imageUrlFocusNode,
                onFieldSubmitted: (value) => setState(() {}),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: double.infinity,
                  height: 300,
                  child: _imageUrlController.text.isEmpty
                      ? Icon(
                          Icons.image_outlined,
                          size: 300,
                          color: Colors.grey,
                        )
                      : Image.network(
                          _imageUrlController.text,
                          fit: BoxFit.contain,
                        )),
            ],
          )),
        ));
    ;
  }
}
