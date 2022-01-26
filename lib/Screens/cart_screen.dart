import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/model/course.dart';
import 'package:eclass/provider/cart_provider.dart';
import 'package:eclass/provider/user_profile.dart';
import 'package:eclass/widgets/awseom_loader.dart';
import 'package:eclass/widgets/success_ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../common/apidata.dart';
import '../common/global.dart';
import '../common/theme.dart' as T;
import '../model/bundle_courses_model.dart';
import '../model/cart_model.dart';
import '../model/coupon_model.dart';
import '../provider/cart_pro_api.dart';
import '../provider/home_data_provider.dart';
import '../widgets/utils.dart';
import 'bottom_navigation_screen.dart';
import 'home_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isCouponApplied = false;
  var totalAmount, discountedAmount;
  bool _visible = false;
  String price = '0';
  bool showHint = true;

  @override
  void initState() {
    user = Provider.of<UserProfile>(context, listen: false);
    print(user.profileInstance.email);
    Future.delayed(Duration(seconds: 4)).then((value) {
      showHint = false;
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      CartProvider cartProvider =
          Provider.of<CartProvider>(context, listen: false);
      await cartProvider.fetchCart(context).then((value) {
        cartLength.value = value.cart.length;
      });
      if (mounted)
        setState(() {
          _visible = true;
        });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  int getDiscount(String type, String amount, String minAmount, String maxUsage,
      int tPrice) {
    if (tPrice < int.parse(minAmount)) return -1;
    if (type == "fix") {
      return tPrice - int.parse(amount) > int.parse(maxUsage)
          ? int.parse(maxUsage)
          : tPrice - int.parse(amount);
    } else {
      int dis = ((tPrice * int.parse(amount)) ~/ 100).toInt();

      return dis > int.parse(maxUsage) ? int.parse(maxUsage) : dis;
    }
  }

  bool couponApplyLoading = false;
  TextEditingController couponCtrl = new TextEditingController();
  int couponDis = 0;
  String couponName = "";
  var cart1;
  String who = '';

  int loading = 0;
  bool error = false;
  Map<dynamic, dynamic> tapSDKResult;
  String responseID = "";
  String sdkStatus = "";
  String sdkErrorCode;
  String sdkErrorMessage;
  String sdkErrorDescription;
  AwesomeLoaderController loaderController = AwesomeLoaderController();
  Color _buttonColor = pink;
  String hint = '';
  String orderRef = '';
  bool isBooked = false;
  String invalidCouponSnackBar = ("تفاصيل القسيمة غير صالحة");

  // SnackBar validCouponSnackBar = SnackBar(
  //   content: Text("تم تطبيق القسيمة"),
  //   duration: Duration(seconds: 1),
  // );
  String validCouponSnackBar = "تم تطبيق القسيمة";

  int getIdxFromCouponList(List<CouponModel> allCoupons, String couponName) {
    int ansIdx = -1, i = 0;
    allCoupons.forEach((element) {
      if (element.linkBy == "cart" && element.code == couponName) ansIdx = i;
      i++;
    });
    return ansIdx;
  }

  void deleteCoupon() {
    setState(() {
      couponCtrl.text = "";
      couponDis = 0;
      couponName = "";
      isCouponApplied = false;
    });
  }

  applyCoupon(coupon) async {
    setState(() {
      couponApplyLoading = true;
    });
    final res =
        await http.post("${APIData.applyCoupon}${APIData.secretKey}", body: {
      "coupon": "$coupon",
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken"
    });
    if (res.statusCode == 200) {
      var response = json.decode(res.body);
      setState(() {
        couponApplyLoading = false;
        couponDis = response['discount_amount'];
        couponName = couponCtrl.text;
        isCouponApplied = true;
      });
      Fluttertoast.showToast(msg: validCouponSnackBar);
    } else {
      setState(() {
        couponApplyLoading = false;
      });
      Fluttertoast.showToast(msg: invalidCouponSnackBar);
    }
  }

  removeCoupon() async {
    final res = await http.post("${APIData.removeCoupon}${APIData.secretKey}",
        headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
    if (res.statusCode == 200) {
      setState(() {
        couponCtrl.text = "";
        couponDis = 0;
        couponName = "";
        isCouponApplied = false;
      });
    }
  }

  SnackBar addMoreDetailsSnackBar = SnackBar(
    content: Text("أضف المزيد من الدورات لاستخدام هذه القسيمة"),
    duration: Duration(seconds: 1),
  );

  Widget afterCouponApply() {
    return Container(
        width: 100,
        height: 40,
        padding: EdgeInsets.symmetric(
            horizontal: couponApplyLoading ? 35 : 0,
            vertical: couponApplyLoading ? 10 : 0),
        decoration: BoxDecoration(
            color: dark,
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(100.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(FontAwesomeIcons.checkCircle, color: ice, size: 17),
            Text(
              "تم التطابق",
              style: TextStyle(
                  color: ice, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  CouponModel desiredCoupon;

  Widget couponSection() {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: ice,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.transparent)),
            child: TextField(
              controller: couponCtrl,
              maxLines: 1,
              cursorColor: dark,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "لديك رمز خصم اوقسيمة هدية؟",
                  hintStyle: TextStyle(color: dark.withOpacity(0.5)),
                  prefixIcon: Icon(
                    Icons.card_giftcard,
                    color: dark.withOpacity(0.5),
                  )),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        isCouponApplied
            ? afterCouponApply()
            : InkWell(
                onTap: () {
                  if (couponCtrl.text.length > 0) applyCoupon(couponCtrl.text);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                      color: dark,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(100.0)),
                  child: Center(
                    child: couponApplyLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          )
                        : Text(
                            "تطبيق",
                            style: TextStyle(
                                color: ice,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                  ),
                ))
      ]),
    );
  }

  Widget calculationSection(int cartTotal) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Text(
            "السعر الكلي:\t${cartTotal}",
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff686F7A),
                fontWeight: FontWeight.w600),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text("أسم القسيمة: \t${couponName ?? "_"}",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff686F7A),
                        fontWeight: FontWeight.w600)),
              ),
              IconButton(
                onPressed: deleteCoupon,
                icon: Icon(FontAwesomeIcons.timesCircle,
                    color: Color(0xFFF44A4A), size: 20),
              )
            ],
          ),
          Container(
              child: Text(
            "قيمة القسيمة : " + couponDis.toString(),
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff686F7A),
                fontWeight: FontWeight.w600),
          ))
        ],
      ),
    );
  }

  Widget totalPay(BuildContext context, String cur) {
    var cart = Provider.of<CartProvider>(context);

    setState(() {
      price = "${cart.cartTotal - couponDis}";
      cart1 = cart;
    });
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 20,
          ),
          couponSection(),
          if (couponDis > 0)
            calculationSection(cart.cartTotal)
          else
            SizedBox.shrink(),
          SizedBox(
            height: 20,
          ),
          Divider(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: ice, borderRadius: BorderRadius.circular(1000.0)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "النهائي : ${(cart.cartTotal - couponDis).toString()} ${cur}",
                        style: TextStyle(
                            color: dark,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),

              Expanded(
                child: Container(
                    height: 45,
                    child: InkWell(
                      onTap: () {
                        configureSDK().then((value) {
                          startSDK(context);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: pink,
                            borderRadius: BorderRadius.circular(25)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 3),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Text(
                                    'التقدم لإتمام الطلب',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  child: AwesomeLoader(
                                    outerColor: Colors.white,
                                    innerColor: Colors.white,
                                    strokeWidth: 2.0,
                                    controller: loaderController,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    )),
              ),
              // InkWell(
              //   onTap: () {
              //     if (isCouponApplied == true) {
              //       var disCountedAmount = cart.cartTotal - couponDis;
              //       Navigator.push(
              //         context,
              //         PageTransition(
              //           type: PageTransitionType.rightToLeft,
              //           child: PaymentGateway(cart.cartTotal, disCountedAmount),
              //         ),
              //       );
              //     } else {
              //       Navigator.push(
              //         context,
              //         PageTransition(
              //           type: PageTransitionType.rightToLeft,
              //           child: PaymentGateway(cart.cartTotal, cart.cartTotal),
              //         ),
              //       );
              //     }
              //   },
              //   child: Container(
              //     height: 50,
              //     decoration: BoxDecoration(
              //         color: pink, borderRadius: BorderRadius.circular(1000.0)),
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 20.0, vertical: 5),
              //       child: Center(
              //         child: Text(
              //           "التقدم لإتمام الطللب",
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontWeight: FontWeight.bold,
              //               fontSize: 16),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                    height: 45,
                    child: InkWell(
                      onTap: () {
                        _sendPaymentDetailsToServer(
                            paymentMethod: 'COD', isCod: true);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: dark,
                            borderRadius: BorderRadius.circular(25)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 3),
                          child: Center(
                            child: Text(
                              'الدفع في مقر الأكاديمية',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int isLoadingDelItemId = -1;

  Widget cartItemTab(CartModel detail, BuildContext context, String currency) {
    CartApiCall crt = new CartApiCall();
    return Container(
      height: 125,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
                color: Color(0x1c2464).withOpacity(0.30),
                blurRadius: 15.0,
                offset: Offset(0.0, 20.5),
                spreadRadius: -15.0)
          ],
          color: Colors.white),
      margin: EdgeInsets.only(
        bottom: 25.0,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(15.0),
          onTap: () {
            // bool useAsInt = false;
            // if (detail.courseId is int) useAsInt = true;
            // Navigator.of(context).pushNamed("/courseDetails",
            //     arguments: DataSend(
            //         detail.userId,
            //         false,
            //         useAsInt ? detail.courseId : int.parse(detail.courseId),
            //         detail.categoryId,
            //         detail.type));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: CachedNetworkImage(
                    imageUrl: "${APIData.courseImages}${detail.cimage}",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Image.asset(
                      "assets/placeholder/exp_course_placeholder.png",
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/placeholder/exp_course_placeholder.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 17.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$currency ${detail.cprice}",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.3),
                                    fontSize: 13,
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "$currency ${detail.cdisprice} ",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          InkWell(
                              onTap: () async {
                                setState(() {
                                  isLoadingDelItemId = detail.id;
                                });
                                bool val = await crt.removeFromCart(
                                    detail.courseId, context);
                                if (val) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "تم حذف العنصر من عربة التسوق الخاصة بك!");
                                }
                                setState(() {
                                  isLoadingDelItemId = -1;
                                  deleteCoupon();
                                });
                              },
                              child: Container(
                                padding: isLoadingDelItemId == detail.id
                                    ? EdgeInsets.all(10)
                                    : EdgeInsets.all(0),
                                height: 40,
                                width: 40,
                                child: isLoadingDelItemId == detail.id
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xffF44A4A)),
                                      )
                                    : Icon(
                                        FontAwesomeIcons.trashAlt,
                                        size: 22,
                                        color: Colors.red,
                                      ),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget whenEmpty(mode) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset(
          "assets/images/empty_cart.png",
          height: 200,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "السلة فارغة",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 4.0,
        ),
        Container(
          width: 200,
          child: Text(
            "لا تملك اي دورة داخل السلة",
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.7)),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        FlatButton(
          color: pink,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyBottomNavigationBar(
                          pageInd: 1,
                        )));
          },
          child: Text(
            "تصفح في الدورات",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget getCartItems(
      List<Course> cartCourseList, List<BundleCourses> cartBundleList) {
    String currency =
        Provider.of<HomeDataProvider>(context).homeModel.currency.currency;
    T.Theme mode = Provider.of<T.Theme>(context);
    List<Widget> list1 = new List<Widget>();
    CartApiCall crt = new CartApiCall();
    for (int i = 0; i < cartCourseList.length; i++) {
      list1.add(Dismissible(
        key: UniqueKey(),
        background: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
        ),
        onDismissed: (v) async {
          bool val = await crt.removeFromCart(cartCourseList[i].id, context);
          if (val) {
            cartCourseList
                .removeWhere((element) => element.id == cartCourseList[i].id);
            Fluttertoast.showToast(
                msg: "تم حذف العنصر من عربة التسوق الخاصة بك!");
          }
          setState(() {
            isLoadingDelItemId = -1;
            deleteCoupon();
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              CartProvider cartProvider =
                  Provider.of<CartProvider>(context, listen: false);
              await cartProvider.fetchCart(context).then((value) {
                // print('DONE : ${value.cart.length}');

                cartLength.value = value.cart.length;
              });
            });
          });
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: InkWell(
            onTap: () {
              bool useAsInt = false;
              if (cartCourseList[i].id is int) useAsInt = true;
              Navigator.of(context).pushNamed("/courseDetails",
                  arguments: DataSend(
                      cartCourseList[i].userId,
                      false,
                      useAsInt ? cartCourseList[i].id : cartCourseList[i].id,
                      cartCourseList[i].categoryId,
                      cartCourseList[i].type));
            },
            child: Container(
              height: 125,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 125,
                    width: 125,
                    child: CachedNetworkImage(
                      imageUrl:
                          "${APIData.courseImages}${cartCourseList[i].previewImage}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Image.asset(
                        "assets/placeholder/exp_course_placeholder.png",
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/placeholder/exp_course_placeholder.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: dark,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartCourseList[i].title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "$currency ${cartCourseList[i].price}",
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 13,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${currency} ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: pink,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "${cartCourseList[i].discountPrice} ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: pink,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Container(
                            //   padding:
                            //       isLoadingDelItemId == cartCourseList[i].id
                            //           ? EdgeInsets.all(10)
                            //           : EdgeInsets.all(0),
                            //   height: 40,
                            //   width: 40,
                            //   child: isLoadingDelItemId == cartCourseList[i].id
                            //       ? CircularProgressIndicator(
                            //           valueColor:
                            //               AlwaysStoppedAnimation<Color>(pink),
                            //         )
                            //       : Icon(
                            //           FontAwesomeIcons.trashAlt,
                            //           size: 15,
                            //           color: pink,
                            //         ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }
    List<Widget> list2 = new List<Widget>();
    for (int i = 0; i < cartBundleList.length; i++) {
      list2.add(Dismissible(
        key: UniqueKey(),
        background: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
        ),
        onDismissed: (v) async {
          bool val = await crt.removeBundleFromCart(
              cartBundleList[i].id.toString(), context, cartBundleList[i]);
          if (val) {
            cartBundleList
                .removeWhere((element) => element.id == cartBundleList[i].id);
            mainscaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("تم حذف العنصر من عربة التسوق الخاصة بك!")));
          }
          setState(() {
            isLoadingDelItemId = -1;
            deleteCoupon();
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              CartProvider cartProvider =
                  Provider.of<CartProvider>(context, listen: false);
              await cartProvider.fetchCart(context).then((value) {
                // print('DONE : ${value.cart.length}');

                cartLength.value = value.cart.length;
              });
            });
          });
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: InkWell(
            onTap: () {
              bool useAsInt = false;
              if (cartBundleList[i].id is int) useAsInt = true;
              Navigator.of(context).pushNamed("/bundleCourseDetail",
                  arguments: cartBundleList[i]);
            },
            child: Container(
              height: 125,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 125,
                    width: 125,
                    child: CachedNetworkImage(
                      imageUrl:
                          "${APIData.bundleImages}${cartBundleList[i].previewImage}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Image.asset(
                        "assets/placeholder/exp_course_placeholder.png",
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/placeholder/exp_course_placeholder.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: dark,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartBundleList[i].title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "$currency ${cartBundleList[i].price}",
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 13,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${currency} ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: pink,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "${cartBundleList[i].discountPrice} ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: pink,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Container(
                            //   padding:
                            //       isLoadingDelItemId == cartCourseList[i].id
                            //           ? EdgeInsets.all(10)
                            //           : EdgeInsets.all(0),
                            //   height: 40,
                            //   width: 40,
                            //   child: isLoadingDelItemId == cartCourseList[i].id
                            //       ? CircularProgressIndicator(
                            //           valueColor:
                            //               AlwaysStoppedAnimation<Color>(pink),
                            //         )
                            //       : Icon(
                            //           FontAwesomeIcons.trashAlt,
                            //           size: 15,
                            //           color: pink,
                            //         ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }

    return cartCourseList.length == 0 && cartBundleList.length == 0
        ? Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Center(child: whenEmpty(mode)),
          )
        : Column(
            children: [
              Column(
                children: [
                  Opacity(
                    opacity: .2,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17,
                            ),
                            Text('مرر الدورة لليمين ولليسار للحذف '),
                            Icon(
                              Icons.arrow_back_ios_sharp,
                              size: 17,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Column(
                children: list1 + list2,
              ),
            ],
          );
  }

  UserProfile user;
  BuildContext ct;

  @override
  Widget build(BuildContext context) {
    ct = context;
    String curr =
        Provider.of<HomeDataProvider>(context).homeModel.currency.currency;
    T.Theme mode = Provider.of<T.Theme>(context);
    List<CartModel> cartCourses =
        Provider.of<CartProducts>(context).cartContentsCourses;
    var cartCourseList = Provider.of<CartProvider>(context).cartCourseList;
    var cartBundleList = Provider.of<CartProvider>(context).cartBundleList;
    return Scaffold(
      backgroundColor: mode.bgcolor,
      body: _visible == false
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  getCartItems(cartCourseList, cartBundleList),
                  cartCourseList.length == 0 ? Container() : Divider(),
                  _visible == false
                      ? SizedBox.shrink()
                      : cartCourseList.length == 0 && cartBundleList.length == 0
                          ? SizedBox.shrink()
                          : Container(
                              child: totalPay(context, curr),
                            ),
                ],
              ),
            ),
    );
  }

  Future<void> configureSDK() async {
    configureApp();
    setupSDKSession();
  }

  Future<void> configureApp() async {
    GoSellSdkFlutter.configureApp(
      bundleId: 'com.smartmediajo.academy',
      productionSecreteKey: 'sk_live_82PopuIHwAenh1Y6CaBKGOk9',
      sandBoxsecretKey: 'sk_live_82PopuIHwAenh1Y6CaBKGOk9',
      lang: "ar",
    );
    print('Configer');
  }

  Future<void> setupSDKSession() async {
    try {
      Random random = new Random();
      int randomNumber = random.nextInt(9999) + 1000;

      int now = DateTime.now().microsecond;
      print("SetUP SDK");
      setState(() {
        orderRef = 'Tap_$now$randomNumber';
      });
      GoSellSdkFlutter.sessionConfigurations(
        trxMode: TransactionMode.PURCHASE,
        transactionCurrency: "SAR",
        amount: '${cart1.cartTotal - couponDis}',
        customer: Customer(
          customerId: '',
          email: '${'user@example.com'}',
          isdNumber: "",
          number: "00",
          firstName: "${user.profileInstance.fname ?? "First name"}",
          middleName: "",
          lastName: "${user.profileInstance.lname ?? "Last name"}",
          metaData: null,
        ),
        postURL: "https://tap.company",
        // Payment description
        paymentDescription: "paymentDescription",
        // Payment Metadata
        paymentMetaData: {
          "a": "a meta",
          "b": "b meta",
        },
        // Payment Reference
        paymentReference: Reference(
            acquirer: "acquirer",
            gateway: "gateway",
            payment: "payment",
            track: "track",
            transaction: "trans_910101",
            order: orderRef),
        // payment Descriptor
        paymentStatementDescriptor: "paymentStatementDescriptor",
        // Save Card Switch
        isUserAllowedToSaveCard: true,
        // Enable/Disable 3DSecure
        isRequires3DSecure: true,
        // Receipt SMS/Email
        receipt: Receipt(false, false),
        // Authorize Action [Capture - Void]
        authorizeAction:
            AuthorizeAction(type: AuthorizeActionType.CAPTURE, timeInHours: 10),
        // Destinations
        destinations: null,
        // merchant id
        merchantID: "",
        // Allowed cards
        allowedCadTypes: CardType.DEBIT,
        applePayMerchantID: "applePayMerchantID",
        allowsToSaveSameCardMoreThanOnce: false,
        // pass the card holder name to the SDK
        cardHolderName: "",
        // disable changing the card holder name by the user
        allowsToEditCardHolderName: true,
        // select payments you need to show [Default is all, and you can choose between WEB-CARD-APPLEPAY ]
        paymentType: PaymentType.ALL,

        // Transaction mode
        sdkMode: SDKMode.Production,
      );
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
      print('error');
    }
  }

  Future<void> startSDK(BuildContext c) async {
    print('START SDK');
    setState(() {
      loaderController.start();
      print('START LOADER');
    });
    tapSDKResult = await GoSellSdkFlutter.startPaymentSDK;
    print('START RESULT');
    loaderController.stopWhenFull();
    print('START STOP WHRN FULL');
    print('>>>> ${tapSDKResult['sdk_result']}');
    setState(() {
      switch (tapSDKResult['sdk_result']) {
        case "SUCCESS":
          sdkStatus = "SUCCESS";
          _sendPaymentDetailsToServer(
              paymentMethod: 'Tap Company',
              saleId: '${user.profileInstance.id}',
              transactionId: orderRef);
          print('AWS1 Charge');
          break;
        case "FAILED":
          sdkStatus = "FAILED";
          handleSDKResult();
          break;
        case "SDK_ERROR":
          print('sdk error............');
          print(tapSDKResult['sdk_error_code']);
          print(tapSDKResult['sdk_error_message']);
          print(tapSDKResult['sdk_error_description']);
          print('sdk error........!!....');
          sdkErrorCode = tapSDKResult['sdk_error_code'].toString();
          sdkErrorMessage = tapSDKResult['sdk_error_message'];
          sdkErrorDescription = tapSDKResult['sdk_error_description'];
          break;
        case "NOT_IMPLEMENTED":
          sdkStatus = "NOT_IMPLEMENTED";
          break;
      }
    });
  }

  progressDialogue(BuildContext context) {
    //set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    showDialog(
      //prevent outside touch
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        //prevent Back button press
        return WillPopScope(onWillPop: () {}, child: alert);
      },
    );
  }

  goToDialog(purDate, time, msgRes, {bool isCOD}) {
    setState(() {
      // isDataAvailable = true;
    });
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => new GestureDetector(
        child: Container(
          color: Colors.black.withOpacity(0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SuccessTicket(
                msgResponse: "$msgRes",
                transactionAmount: "$totalAmount",
                purchaseDate: purDate,
                time: time,
                isCOD: isCOD,
              ),
              SizedBox(
                height: 10.0,
              ),
              FloatingActionButton(
                backgroundColor: yellow,
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  var router = new MaterialPageRoute(
                      builder: (BuildContext context) => MyBottomNavigationBar(
                            pageInd: 0,
                          ));
                  Navigator.of(context).push(router);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  var createdDate;
  var createdTime;

  _sendPaymentDetailsToServer(
      {transactionId, saleId, paymentMethod, isCod = false}) async {
    progressDialogue(context);
    final sendResponse =
        await http.post("${APIData.payStore}${APIData.secretKey}", body: {
      "transaction_id": "$transactionId",
      "payment_method": "$paymentMethod",
      "pay_status": "1",
      "sale_id": "$saleId",
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken"
    });
    print("Server : ${sendResponse.statusCode}");
    print(sendResponse.body);
    if (sendResponse.statusCode == 200) {
      var date = DateTime.now();
      var time = DateTime.now();
      createdDate = DateFormat('d MMM y').format(date);
      createdTime = DateFormat('HH:mm a').format(time);
      var res = json.decode(sendResponse.body);
      var msgRes;
      setState(() {
        // isShowing = false;
        msgRes = res;
      });
      goToDialog(createdDate, createdTime, msgRes, isCOD: isCod);
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyBottomNavigationBar(),), (route) => false);
    } else {
      Fluttertoast.showToast(msg: "فشلت معاملتك.");
      Navigator.pop(context);
    }
  }

  void handleSDKResult({BuildContext c}) {
    switch (tapSDKResult['trx_mode']) {
      case "CHARGE":
        try {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actions: [
                    CircularProgressIndicator(),
                  ],
                );
              });
          _sendPaymentDetailsToServer(
              paymentMethod: 'Tap Company',
              saleId: '${user.profileInstance.id}',
              transactionId: orderRef);
          print('AWS1 Charge');
        } catch (e) {
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text('حدثت مشكلة'),
                  children: [Text('ألرجاء المحاولة مرة اخرى')],
                );
              });
        }
        break;
      case "AUTHORIZE":
        printSDKResult('Authorize');
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text('حدثت مشكلة'),
                children: [Text('الرجاء التاكد من صحة البيانات')],
              );
            });
        print('AWS2 Authorize');
        break;
      case "SAVE_CARD":
        printSDKResult('Save Card');
        print('AWS3 SAVE_CARD');
        break;
      case "TOKENIZE":
        print('AWS TOKENIZE');
        print('TOKENIZE token : ${tapSDKResult['token']}');
        print('TOKENIZE token_currency  : ${tapSDKResult['token_currency']}');
        print('TOKENIZE card_first_six : ${tapSDKResult['card_first_six']}');
        print('TOKENIZE card_last_four : ${tapSDKResult['card_last_four']}');
        print('TOKENIZE card_object  : ${tapSDKResult['card_object']}');
        print('TOKENIZE card_exp_month : ${tapSDKResult['card_exp_month']}');
        print('TOKENIZE card_exp_year    : ${tapSDKResult['card_exp_year']}');
        responseID = tapSDKResult['token'];
        break;
    }
  }

  void printSDKResult(String trx_mode, {BuildContext context}) async {
    print('$trx_mode status                : ${tapSDKResult['status']}');
    if (tapSDKResult['status'] == 'CAPTURED') {
      {
        try {
          ///send order
          showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
          _sendPaymentDetailsToServer(
              paymentMethod: 'Tap Company',
              saleId: '${user.profileInstance.id}',
              transactionId: orderRef);
        } catch (e) {
          ///exeption
          print("ERROR WHEN GO PAYMENT ${e.toString()}");
        }
      }
      // orderBook(orderRef);
    } else {}
    print('$trx_mode id               : ${tapSDKResult['charge_id']}');
    print('$trx_mode  description        : ${tapSDKResult['description']}');
    print('$trx_mode  message           : ${tapSDKResult['message']}');
    print('$trx_mode  card_first_six : ${tapSDKResult['card_first_six']}');
    print('$trx_mode  card_last_four   : ${tapSDKResult['card_last_four']}');
    print('$trx_mode  card_object         : ${tapSDKResult['card_object']}');
    print('$trx_mode  card_brand          : ${tapSDKResult['card_brand']}');
    print('$trx_mode  card_exp_month  : ${tapSDKResult['card_exp_month']}');
    print('$trx_mode  card_exp_year: ${tapSDKResult['card_exp_year']}');
    print('$trx_mode  acquirer_id  : ${tapSDKResult['acquirer_id']}');
    print(
        '$trx_mode  acquirer_response_code : ${tapSDKResult['acquirer_response_code']}');
    print(
        '$trx_mode  acquirer_response_message: ${tapSDKResult['acquirer_response_message']}');
    print('$trx_mode  source_id: ${tapSDKResult['source_id']}');
    print('$trx_mode  source_channel     : ${tapSDKResult['source_channel']}');
    print('$trx_mode  source_object      : ${tapSDKResult['source_object']}');
    print(
        '$trx_mode source_payment_type : ${tapSDKResult['source_payment_type']}');
    responseID = tapSDKResult['charge_id'];
  }
}
