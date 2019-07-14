import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/cart_product.dart';

class CartTile extends StatelessWidget {
  final CartProduct product;

  CartTile(this.product);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      return Row(
        children: <Widget>[
          Container(
            width: 120,
            padding: EdgeInsets.all(8),
            child: Image.network(
              product.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    product.productData.title,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  Text(
                    'Tamanho: ${product.size}',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'R\$ ${product.productData.price.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme
                            .of(context)
                            .primaryColor,
                        onPressed: product.quantity > 1 ?  () {
                          CartModel.of(context).decProduct(product);
                        } : null,
                      ),
                      Text(
                        product.quantity.toString(),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme
                            .of(context)
                            .primaryColor,
                        onPressed: () {
                          CartModel.of(context).incProduct(product);
                        },
                      ),
                      FlatButton(
                        child: Text('Remover'),
                        textColor: Colors.grey[500],
                        onPressed: () {
                          CartModel.of(context).removeCartItem(product);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: product.productData == null
          ? FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance
            .collection('products')
            .document(product.category)
            .collection('items')
            .document(product.pid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            product.productData = ProductData.fromDocument(snapshot.data);

            return _buildContent();
          } else {
            return Container(
              height: 70,
              child: CircularProgressIndicator(),
              alignment: Alignment.center,
            );
          }
        },
      )
          : _buildContent(),
    );
  }
}
