import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './triangle.dart';
import '../Screens/bottom_navigation_screen.dart';
import '../provider/cart_pro_api.dart';

class AddAndBuyBundle extends StatefulWidget {
  final int bundleId;
  final dynamic bprice;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  AddAndBuyBundle(this.bundleId, this.bprice, this._scaffoldKey);
  @override
  _AddAndBuyBundleState createState() => _AddAndBuyBundleState();
}

class _AddAndBuyBundleState extends State<AddAndBuyBundle> {
  bool isloading = false;

  Widget triangeShape() {
    return CustomPaint(
      painter: TrianglePainter(
        strokeColor: Colors.white,
        strokeWidth: 4,
        paintingStyle: PaintingStyle.fill,
      ),
      child: Container(
        height: 20,
        //width: 20,
      ),
    );
  }

  Widget addToCartButton(bool inCart) {
    CartApiCall crt = new CartApiCall();
    return InkWell(
      onTap: () async {
        setState(() {
          this.isloading = true;
        });
        setState(() {});
        if (!inCart) {
          bool success =
              await crt.addToCartBundle(widget.bundleId.toString(), context);
          if (success)
            widget._scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text("تمت إضافة الحزمة إلى سلة التسوق!")));
          else
            widget._scaffoldKey.currentState.showSnackBar(
                SnackBar(content: Text("فشل إضافة الحزمة إلى عربة التسوق!")));
        } else
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyBottomNavigationBar(
                        pageInd: 3,
                      )));
        setState(() {
          this.isloading = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: 40.0,
        decoration: BoxDecoration(
            color: pink,
            border: Border.all(width: 1.0, color: pink),
            borderRadius: BorderRadius.circular(100.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: this.isloading
                  ? Container(
                height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                        // backgroundColor: Colors.white,
                      strokeWidth: 1.2,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white)),
                  )
                  : Text(
                      inCart ? "الذهاب الى السلة" : "إضافة الى السلة",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
            ),
            Container(
              margin: EdgeInsets.all(3.0),
              height: 20.0,
              width: 20.0,
              decoration: BoxDecoration(
                  // color: Colors.black12,
                  borderRadius: BorderRadius.circular(25.00)),
              child: Image.asset(
                "assets/icons/addtocart.png",
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  bool buynowLoading = false;
  Widget buyNowButton(bool inCart) {
    return InkWell(
      onTap: () async {
        setState(() {
          this.buynowLoading = true;
        });
        // setState(() {});
        if (!inCart) {
          bool success = await CartApiCall()
              .addToCartBundle(widget.bundleId.toString(), context);
          if (success) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyBottomNavigationBar(
                          pageInd: 3,
                        )));
          } else {
            widget._scaffoldKey.currentState.showSnackBar(
                SnackBar(content: Text("هناك خطأ ما!")));
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
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1.0, color: dark),
          borderRadius: BorderRadius.circular(1000.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: buynowLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    )
                  : Text(
                      "اشترك الآن",
                      style: TextStyle(
                          color: dark,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
            ),
            SizedBox(width: 10,),
            Container(
              margin: EdgeInsets.all(3.0),
              height: 30.0,
              width: 30.0,
              decoration: BoxDecoration(
                  // color: Colors.black12,
                  borderRadius: BorderRadius.circular(25.00)),
              child: Image.asset(
                "assets/icons/buynow.png",
                color: dark,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buttonContainer(bool inCart) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: addToCartButton(inCart)),
          SizedBox(
            width: 10.0,
          ),
          Expanded(child: buyNowButton(inCart)),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool inCart =
        Provider.of<CartProducts>(context).checkBundle(widget.bundleId);
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          children: [triangeShape(), buttonContainer(inCart)],
        ),
      ),
    );
  }
}
