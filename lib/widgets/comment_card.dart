import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/Widgets/rating_star.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final String image, name, comment;
  final Widget stars;
  String rate;

  CommentCard({this.image, this.name, this.comment, this.stars, this.rate});

  @override
  Widget build(BuildContext context) {
    print(image);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: dark.withOpacity(0.4))),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: "$image",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.3),
                            spreadRadius: 0.5,
                            blurRadius: 30,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.5),
                            spreadRadius: 0.5,
                            blurRadius: 30,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/icons/user_avatar.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.5),
                            spreadRadius: 0.5,
                            blurRadius: 30,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/icons/user_avatar.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        name ?? "User",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: pink,
                            fontSize: 18),
                      ),
                      StarRating(
                        rating: double.parse(this.rate),
                        starCount: 5,
                        color: dark,
                        size: 14,
                      )
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 70,
                  ),
                  Expanded(child: Text(comment,style: TextStyle(color: dark.withOpacity(0.8)),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
