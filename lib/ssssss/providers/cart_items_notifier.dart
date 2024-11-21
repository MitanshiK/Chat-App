// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../shopping_cart_collection/shopping_riverpod/providers/shopping_model.dart';
//
//
// class CartItemsNotifier2 extends Notifier<Set<ProductsModel>>{
//   List<ProductsModel> cartItems3 = [];
 //
//   @override
//  Set<ProductsModel> build()  {
//  return {};
//  }
//
//   void addItem(ProductsModel item){
//     if(!state.contains(item)){
//       // state={...state,item};
//       addItem2(item);
//     }
//   }
// void addItem2(ProductsModel item) async{
//   try{
//   await  FirebaseFirestore.instance
//             .collection("Shopping")
//             .doc(item.id.toString())
//             .set(item.toMap())
//             .then((value) {
//           debugPrint("item added");
//         });
//   }catch(e){
//     debugPrint(" could no create shopping collection :$e");
//   }
//    initializee();
// }
//   void removeItem(ProductsModel item){
//      if(state.contains(item)){            // check if state contains the product
//    // state=state.where((e)=> e.id !=item.id).toSet();  // keep all products except the one with provided id
//  removeItem2(item);
//   }
//   }
// void removeItem2(ProductsModel item) {
//    FirebaseFirestore.instance
//             .collection("Shopping")
//              .doc(item.id.toString()).delete();
//               initializee();
//   }
// //////////////
//    List<ProductsModel> initializee() {
//     List<ProductsModel> cartItems = [];
//  FirebaseFirestore.instance
//         .collection("Shopping")
//         .snapshots()
//         .listen((event) {
//            List<ProductsModel> cartItems1 = [];
//       for (var i in event.docs) {
//         ProductsModel item = ProductsModel.fromMap(
//             i.data());
//         cartItems1.add(item);
//       }        
//       state.clear();
//      cartItems.addAll(cartItems1);
//      state.addAll(cartItems1);
//      debugPrint("state are ${state.length}");
//     });
//      return cartItems;
//   }
// }
// // provider
// final cartItemsNotifierProvider2=NotifierProvider<CartItemsNotifier2,Set<ProductsModel>>((){
//   CartItemsNotifier2().initializee();
//   return CartItemsNotifier2();
// });

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj/ssssss/providers/shopping_model.dart';


class CartItemsNotifier2 extends Notifier<Set<ProductsModel>> {
  @override
  Set<ProductsModel> build() {
    initializeCartItems();
    return {};
  }

  void addItem(ProductsModel item) async {
    if (!state.contains(item)) {
      try {
        await FirebaseFirestore.instance
            .collection("Shopping")
            .doc(item.id.toString())
            .set(item.toMap())
            .then((value) {
          debugPrint("Item added: ${item.title}");
           if (!state.contains(item)) {
          state = {...state, item};
           }
        });
         // Force notify listeners
      } catch (e) {
        debugPrint("Could not create shopping collection: $e");
      }
    }
  }

  void removeItem(ProductsModel item) async {
    if (state.contains(item)) {
      try {
        await FirebaseFirestore.instance
            .collection("Shopping")
            .doc(item.id.toString())
            .delete()
            .then((value) {
          debugPrint("Item removed: ${item.title}");
        state = state.where((e) => e.id != item.id).toSet();
        });
        // Force notify listeners
      } catch (e) {
        debugPrint("Could not remove item from shopping collection: $e");
      }
    }
  }

  void initializeCartItems() {
    FirebaseFirestore.instance.collection("Shopping").snapshots().listen((event) {
      final items = event.docs.map((e) => ProductsModel.fromMap(e.data())).toSet();
      state = items;
      debugPrint("Cart initialized with ${items.length} items");
    });
  }
}

final cartItemsNotifierProvider2 = NotifierProvider<CartItemsNotifier2, Set<ProductsModel>>(() {
  return CartItemsNotifier2();
});
