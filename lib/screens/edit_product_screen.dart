import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

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
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImage);
    super.initState();
  }

  bool _isInit = true;

  bool _isLoading = false;

  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final String productId =
          ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues['title'] = _editedProduct.title;
        _initValues['price'] = _editedProduct.price.toString();
        _initValues['description'] = _editedProduct.description;
        _initValues['imageUrl'] = _editedProduct.imageUrl;
      }
    }
    _imageUrlController.text = _initValues['imageUrl'];
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImage);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void updateImage() {
    if (_imageUrlController.text.isEmpty) {
      return;
    }
    if (!_imageUrlController.text.endsWith('.jpg') &&
        !_imageUrlController.text.endsWith('.pnj') &&
        !_imageUrlController.text.endsWith('.jpeg')) {
      return;
    }
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    bool isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id == null)
      Provider.of<Products>(context, listen: false)
          .addNewItem(_editedProduct)
          .catchError((error) {
        return showDialog<Null>(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('ERROR!'),
                  icon: Icon(Icons.error),
                  iconColor: Theme.of(context).errorColor,
                  content: Text('Something went wrong'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      });
    else
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct)
          .catchError((error) {
        return showDialog<Null>(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('ERROR!'),
                  icon: Icon(Icons.error),
                  iconColor: Theme.of(context).errorColor,
                  content: Text('Something went wrong'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
        ),
        body: (_isLoading)
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                    key: _form,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(
                            label: Text('Title'),
                            icon: Icon(Icons.title),
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                          onSaved: (newValue) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: newValue,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl,
                                isFavourite: _editedProduct.isFavourite);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the Title!';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(
                            label: Text('Price'),
                            icon: Icon(EditProductScreen.currency_rupee_sharp),
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onSaved: (newValue) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: double.parse(newValue),
                                imageUrl: _editedProduct.imageUrl,
                                isFavourite: _editedProduct.isFavourite);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the Price!';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number!';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please enter a value greater than 0!';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(
                            label: Text('Description'),
                            icon: Icon(Icons.description),
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.newline,
                          maxLines: 3,
                          onSaved: (newValue) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: newValue,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl,
                                isFavourite: _editedProduct.isFavourite);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the Description!';
                            }
                            if (value.length <= 20) {
                              return 'Despcription must be of length greater than 20';
                            }
                            return null;
                          },
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
                          onSaved: (newValue) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: newValue,
                                isFavourite: _editedProduct.isFavourite);
                          },
                          onFieldSubmitted: (value) => setState(() {}),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the URL!';
                            }
                            if (!value.endsWith('.jpg') &&
                                !value.endsWith('.pnj') &&
                                !value.endsWith('.jpeg')) {
                              return 'Please enter a valid Image URL';
                            }
                            return null;
                          },
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
