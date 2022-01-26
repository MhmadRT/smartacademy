import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/bottom_navigation_screen.dart';
import '../provider/cart_pro_api.dart';

class AddAndBuy extends StatefulWidget {
  final int courseId;
  final String cprice;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  AddAndBuy(this.courseId, this.cprice, this._scaffoldKey);
  @override
  _AddAndBuyState createState() => _AddAndBuyState();
}

class _AddAndBuyState extends State<AddAndBuy> {
  Widget addToCart(bool inCart) {
    return Material(
        color: pink,
        borderRadius: BorderRadius.circular(1000),
        child: InkWell(
          borderRadius: BorderRadius.circular(1000),
          onTap: () async {
            setState(() {
              this.isloading = true;
            });
            setState(() {});
            if (!inCart) {
              bool success =
                  await crt.addtocart(widget.courseId.toString(), context);
              if (success) {
                widget._scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text("تم إضافة الدورة إلى عربة التسوق الخاصة بك!")));
              } else {
                widget._scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text("الموافقة على الدفع معلقة !")));
              }

            } else
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyBottomNavigationBar(
                            pageInd: 3,
                          )));
            setState(() {
              this.isloading = false;
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                CartProvider cartProvider =
                Provider.of<CartProvider>(context, listen: false);
                await cartProvider.fetchCart(context).then((value){
                  print('DONE : ${value.cart.length}');
                  if(mounted)
                  setState(() {
                    cartLength.value = value.cart.length;
                  });
                });

              });
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 1.0, color: Colors.transparent),
                borderRadius: BorderRadius.circular(1000.0)),
            child: Row(
              children: [
                Center(
                  child: isloading
                      ? CircularProgressIndicator(
                          // backgroundColor: Colors.white,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white))
                      : Text(
                          inCart ? "الذهاب الى السلة" : "إضافة الى السلة",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                ),
                SizedBox(width: 10,),
                Icon(Icons.shopping_cart,color:Colors.white)

              ],
            ),
          ),
        ));
  }

  Widget buyNowButton(bool inCart) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          setState(() {
            this.buynowLoading = true;
          });
          // setState(() {});
          if (!inCart) {
            bool success =
                await crt.addtocart(widget.courseId.toString(), context);
            if (success) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyBottomNavigationBar(
                            pageInd: 3,
                          )));
            } else {
              widget._scaffoldKey.currentState.showSnackBar(
                  SnackBar(content: Text("الموافقة على الدفع معلقة !")));
            }
          } else
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyBottomNavigationBar(
                          pageInd: 3,
                        )));
          setState(() {
            this.buynowLoading = false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: dark),
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 4),
            child: Row(
              children: [
                Center(
                  child: buynowLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(dark),
                        )
                      : Text(
                          "أشترك الان",
                          style: TextStyle(
                              color: dark,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                ),
                SizedBox(width: 10,),
                Icon(Icons.check_circle,color:dark,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addandBuyBody(bool inCart) {
    return Container(
      child: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                addToCart(inCart),
                SizedBox(
                  height: 5.0,
                ),
                buyNowButton(inCart),
                SizedBox(
                  height: 5.0,
                ),
              ]),
          // Text(
          //   "30-day Money-Back Gurantee",
          //   textAlign: TextAlign.center,
          //   style: TextStyle(color: Colors.grey, fontSize: 12.0),
          // )
        ],
      ),
    );
  }

  CartApiCall crt = new CartApiCall();
  bool isloading = false;
  bool buynowLoading = false;
  @override
  Widget build(BuildContext context) {
    CartProducts carts = Provider.of<CartProducts>(context);
    bool inCart = carts.inCart(widget.courseId);
    return addandBuyBody(inCart);
  }
}
