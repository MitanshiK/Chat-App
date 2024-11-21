import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj/ssssss/providers/cart_items_notifier.dart';
import 'package:proj/ssssss/screens/cart_screen.dart';


class CartIcon extends ConsumerWidget {
  const CartIcon({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var cartItem=ref.watch(cartItemsNotifierProvider2).length;
    // ref.read(cartItemsNotifierProvider2.notifier).initializee();
    
    return StreamBuilder(
      stream: FirebaseFirestore.instance
        .collection("Shopping").snapshots(),
     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {  
      return GestureDetector(
        onTap: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=> const CartScreen()));
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          child:  Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
                size: 30,
              ),
              Positioned(
                top: -5,
                left: -5,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.blue,
                  child: Text(snapshot.data!.docs.length.toString() ,style: const TextStyle(color: Colors.white,fontSize: 12),),
                ),
              )
            ],
          ),
        ),
      );
      }
    );
  }
}