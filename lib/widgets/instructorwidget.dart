import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

import '../common/apidata.dart';
import '../common/theme.dart' as T;
import '../model/instructor_model.dart';

class InstructorWidget extends StatelessWidget {
  final Instructor details;

  InstructorWidget(this.details);

  Widget showImage() {
    return Container(
      width: 70,
      height: 70,
      child: Stack(
        children: [
          Positioned(
            right: 5,
            top: 0,
            bottom: 0,
            child: Container(
              height: 60,
              width: 60,
              margin: EdgeInsets.only(top: 2.0),
              alignment: Alignment.topLeft,
              child: CachedNetworkImage(
                imageUrl: "${APIData.userImage}${details.user.userImg}",
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Image.asset(
                  "assets/icons/user_avatar.png",
                  width: 120,
                  height: 120,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  "assets/icons/user_avatar.png",
                  width: 120,
                  height: 120,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  Widget showDetails(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context, listen: false);
    return Container(
      height: 80,
      decoration:BoxDecoration(borderRadius: BorderRadius.circular(17), color: ice),
      child: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10),
                  child: showImage(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                       "${details.user.fname??""}  ${details.user.lname??""}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: pink,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        details.user.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: mode.titleTextColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 9.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                details.user.detail!=null?    Expanded(
                  child: Container(
                    height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: pink),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20),
                        child: Text(
                          _parseHtmlString(details.user.detail??""),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ice,
                            fontWeight: FontWeight.w400,
                            fontSize: 11.0,
                          ),
                        ),
                      )),
                ):Expanded(child: Container(),)
              ],
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/InstructorScreen', arguments: details.user.id);
      },
      child: showDetails(context),
    );
  }
}
