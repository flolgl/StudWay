import 'package:flutter/material.dart';

import '../../../controller/offer/Offer.dart';
import '../../../controller/user/User.dart';
import 'OfferFullView.dart';

class OfferContainer extends StatefulWidget {
  final int id;

  OfferContainer(this.id, {Key? key}) : super(key: key);

  @override
  State<OfferContainer> createState() => _OfferContainerState(id);
}

class _OfferContainerState extends State<OfferContainer> {
  late Future<Offer> futureOffer;
  final int id;

  Icon favoriteIcon = const Icon(
    Icons.favorite_border_outlined,
    color: Colors.grey,
  );

  _OfferContainerState(this.id); //late Future<int> amountOfDaysSinceUpload;

  @override
  void initState() {
    super.initState();
    futureOffer = Offer.fetchOfferInfoByID(id);
    //amountOfDaysSinceUpload = Offer.amountOfTimeSinceUpload();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
      child: GestureDetector(
        onTap: () {
          //Redirige vers une nouvelle page avec les détails de l'offre cliquée
        },
        child: FutureBuilder<Offer>(
          future: futureOffer,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          OfferFullView(User.currentUser!, snapshot.data!)));
                },
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: -7,
                        blurRadius: 15,
                        offset:
                            const Offset(0, 10), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 7),
                            child: RichText(
                              text: TextSpan(
                                text: snapshot.data!.titre,
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10, right: 12),
                              child: IconButton(
                                icon: favoriteIcon,
                                onPressed: () {
                                  if (favoriteIcon.color == Colors.grey) {
                                    setState(() {
                                      favoriteIcon = const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      );
                                    });
                                  } else {
                                    setState(() {
                                      favoriteIcon = const Icon(
                                        Icons.favorite_border_outlined,
                                        color: Colors.grey,
                                      );
                                    });
                                  }
                                },
                              )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: snapshot.data!.description,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 5,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.room,
                              color: Colors.grey,
                            ),
                            RichText(
                              text: TextSpan(
                                text: snapshot.data!.location,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 3,
                          bottom: 10,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: snapshot.data!
                                .timeSinceUploadInDays()
                                .toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Text(
                  'Impossible de récupérer vos données. Veuillez réessayer plus tard.');
            }
            return const Center();
          },
        ),
      ),
    );
  }
}
