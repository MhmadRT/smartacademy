import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/apidata.dart';
import '../common/theme.dart' as T;
import '../model/about_us_model.dart';

class AboutUsView extends StatelessWidget {
  Widget containerOneImage(String oneImage, String oneHeading) {
    return Container(
        child: Column(
      children: [
        Container(
          child: CachedNetworkImage(
            height: 200,
            imageUrl: APIData.aboutUsImages + "$oneImage",
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            placeholder: (context, url) =>
                Image.asset("assets/images/loading.gif"),
            errorWidget: (context, url, error) =>
                Image.asset("assets/images/loading.gif"),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "$oneHeading",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: dark,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    ));
  }

  Widget conGradient(String txt, List<Color> gradientColors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        "$txt",
        textAlign: TextAlign.center,
        style: TextStyle(
          color:  dark,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget heading(String head, Color headingColor) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        "$head",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24.0,
          color: headingColor,
        ),
      ),
    );
  }

  Widget simpleText(String txt) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        "$txt",
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget showImage(String img) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Color(0x1c2464).withOpacity(0.30),
            blurRadius: 15.0,
            offset: Offset(0.0, 20.5),
            spreadRadius: -15.0,
          ),
        ],
      ),
      child: CachedNetworkImage(
        imageUrl: APIData.aboutUsImages + "$img",
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) =>
            Image.asset("assets/images/loading.gif"),
        errorWidget: (context, url, error) =>
            Image.asset("assets/images/loading.gif"),
      ),
    );
  }

  Widget numberRow(String counta, String countb, String txta, String txtb,
      BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          height: MediaQuery.of(context).size.width / 3.5,
          decoration: BoxDecoration(shape: BoxShape.circle, color: ice),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "$counta",
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 7,
                child: Text(
                  "$txta",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          height: MediaQuery.of(context).size.width / 3.5,
          decoration: BoxDecoration(shape: BoxShape.circle, color: ice),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "$countb",
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 5,
                child: Text(
                  "$txtb",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(),
            ],
          ),
        ),
      ],
    );
  }

  Widget gradientContainerChild(String head, String detail) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$head",
            style: TextStyle(
              color:  dark,
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: ice,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:30.0,horizontal: 13),
              child: Text(
                "$detail",
                style: TextStyle(
                    color:  dark.withOpacity(1), fontSize: 14.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget gradientContainer(List<About> aboutUs, int index) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: dark,
          ),
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 7),
              child: Text("${aboutUs[index].sixHeading}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24.0,
                    color: Colors.white,
                  )),
            ),
          ),
        ),
        gradientContainerChild(
            aboutUs[index].sixTxtone, aboutUs[index].sixDeatilone),
        gradientContainerChild(
            aboutUs[index].sixTxttwo, aboutUs[index].sixDeatiltwo),
        gradientContainerChild(
            aboutUs[index].sixTxtthree, aboutUs[index].sixDeatilthree),
      ],
    );
  }

  Widget detailPlusImageContainer(List<About> aboutUs, int index) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      height: 450,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (aboutUs[index].fiveEnable == '1')
            CachedNetworkImage(
              imageUrl:
                  APIData.aboutUsImages + "${aboutUs[index].fiveImageone}",
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) =>
                  Image.asset("assets/images/loading.gif"),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          Container(
            height: 450,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [
                    0.05,
                    0.9
                  ],
                  colors: [
                     dark,
                     dark.withOpacity(0.0),
                  ]),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Text(
                  "${aboutUs[index].fourHeading}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "${aboutUs[index].fourText}",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget scaffoldBody(List<About> aboutUs, T.Theme mode) {
    return ListView.builder(
        itemCount: aboutUs.length,
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        itemBuilder: (BuildContext context, int index) {
          print(aboutUs[index].oneEnable);
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              if (aboutUs[index].oneEnable == '1')
                Column(
                  children: [
                    containerOneImage(
                        aboutUs[index].oneImage, aboutUs[index].oneHeading),
                    conGradient(aboutUs[index].oneText, mode.gradientColors),
                    SizedBox(height: 30,),
                  ],
                ),
              if (aboutUs[index].twoEnable == '1')
                Column(
                  children: [
                    heading(aboutUs[index].twoHeading, mode.headingColor),
                    simpleText(aboutUs[index].twoText),
                    showImage(aboutUs[index].twoImageone),
                    conGradient(aboutUs[index].twoTxtone, mode.gradientColors),
                    simpleText(aboutUs[index].twoImagetext),
                  ],
                ),
              if (aboutUs[index].fiveEnable == '1')
                Column(
                  children: [
                    detailPlusImageContainer(aboutUs, index),
                  ],
                ),
              if (aboutUs[index].sixEnable == '1')
                gradientContainer(aboutUs, index),
              SizedBox(
                height: 25.0,
              ),
              if (aboutUs[index].threeEnable == '1')
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: dark,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10),
                        child: Text(
                          aboutUs[index].threeHeading,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    // simpleText(aboutUs[index].threeText),
                    SizedBox(
                      height: 30,
                    ),
                    numberRow(
                        aboutUs[index].threeCountone,
                        aboutUs[index].threeCounttwo,
                        aboutUs[index].threeTxtone,
                        aboutUs[index].threeTxttwo,
                        context),
                    SizedBox(
                      height: 20,
                    ),

                    numberRow(
                        aboutUs[index].threeCountthree,
                        aboutUs[index].threeCountfour,
                        aboutUs[index].threeTxtthree,
                        aboutUs[index].threeTxtfour,
                        context),
                    SizedBox(
                      height: 20,
                    ),
                    numberRow(
                        aboutUs[index].threeCountfive,
                        aboutUs[index].threeCountsix,
                        aboutUs[index].threeTxtfive,
                        aboutUs[index].threeTxtsix,
                        context),
                  ],
                ),
              SizedBox(
                height: 100,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);

    List<About> aboutUs = Provider.of<List<About>>(context);
    return (aboutUs == null)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: mode.bgcolor,
            body: scaffoldBody(aboutUs, mode),
          );
  }
}
