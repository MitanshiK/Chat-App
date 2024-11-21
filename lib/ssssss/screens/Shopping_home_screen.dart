import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj/ssssss/providers/api_service.dart';
import 'package:proj/ssssss/providers/cart_items_notifier.dart';
import 'package:proj/ssssss/providers/shopping_model.dart';
import 'package:proj/ssssss/screens/cart_icon.dart';


class ShoppingHome2 extends ConsumerWidget {
  const ShoppingHome2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var products = ref.watch(productsProvider);
    var cartItems=ref.watch(cartItemsNotifierProvider2);   
  //  ref.read(cartItemsNotifierProvider2.notifier).initializee();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Home page"),
        actions: const [
          CartIcon()
        ],
      ),
      body: products.when(data: (List<ProductsModel>? data) {
        return ListView(
          children: [
            ...data!.map((e) => ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10,right: 5 ,top: 5,bottom: 5),
                    color: Colors.white,
                margin: const EdgeInsets.only(top: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.title! ),
                            const SizedBox(height: 5,),
                            Text(" \$${e.price}",style: const TextStyle(fontSize: 15),),
                             const SizedBox(height: 10,),
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Container(
                                                         decoration: BoxDecoration(
                                                           borderRadius: BorderRadius.circular(5),
                                                           color: Colors.amber,
                                                         ),
                                                         padding: const EdgeInsets.all(5),
                                                         child: Row(
                                                           children: [
                                  Text(
                                    "${e.stock} in Stock",
                                    style: const TextStyle(color: Colors.white),
                                  )
                                                           ],
                                                         ),
                                                       ),
                                  if(!cartItems.contains(e))
                                  TextButton(
                                    onPressed: (){
                                ref.read(cartItemsNotifierProvider2.notifier).addItem(e);
                              
                                  }, 
                                  child: const Text("Add to Cart"))
                                  else
                                  TextButton(
                                    onPressed: (){
                                 ref.read(cartItemsNotifierProvider2.notifier).removeItem(e);
                            
                                  }, 
                                  child: const Text("Remove"))
                               ],
                             ),
                          ],
                        ),
                      ),                    
                      Expanded(
                        flex: 1,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 150,
                          maxWidth: 150),
                          child: Image(
                            image: NetworkImage(e.thumbnail!),
                          ),
                        ),
                      )
                    ],
                  ),
                )
                ))
          ],
        );
      }, error: (Object error, StackTrace stackTrace) {
        debugPrint(stackTrace.toString());
        return Center(
          child: Text(stackTrace.toString()),
        );
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}

