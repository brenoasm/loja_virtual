import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'cart_product.dart';

class CartModel extends Model {
  UserModel user;

  List<CartProduct> products = [];

  CartModel(this.user);

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct product) {
    products.add(product);

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .add(product.toMap())
        .then((doc) {
      product.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct product) {
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(product.cid)
        .delete();

    products.remove(product);

    notifyListeners();
  }
}
