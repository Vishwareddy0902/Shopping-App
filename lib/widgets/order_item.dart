import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderTile extends StatefulWidget {
  final OrderItem orderItem;
  OrderTile(this.orderItem);

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '₹${widget.orderItem.totalAmount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                .format(widget.orderItem.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              margin: EdgeInsets.symmetric(),
              child: Column(
                children: widget.orderItem.list
                    .map((prod) => Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(prod.title),
                                  Spacer(),
                                  Text(
                                      '${prod.quantity} X ₹${prod.price.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'),
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
