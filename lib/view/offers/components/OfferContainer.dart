import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../controller/offer/Offer.dart';

class OfferContainer extends StatefulWidget {
  const OfferContainer({Key? key}) : super(key: key);

  @override
  State<OfferContainer> createState() => _OfferContainerState();
}

class _OfferContainerState extends State<OfferContainer> {
  late Future<Offer> futureOffer;
  //late Future<int> amountOfDaysSinceUpload;

  @override
  void initState() {
    super.initState();
    futureOffer = Offer.fetchOfferInfo();
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
                offset: const Offset(0, 10), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 7),
                child: FutureBuilder<Offer>(
                  future: futureOffer,
                  builder: (context, snapshot) {
                    //TODO: snapshot.hasData return false je sais pas pk
                    if (snapshot.hasData) {
                      return RichText(
                        text: TextSpan(
                          text: snapshot.data!.description,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                          'Impossible de récupérer vos données. Veuillez réessayer plus tard.');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                  ),
                  child: FutureBuilder<Offer>(
                      future: futureOffer,
                      builder: (context, snapshot) {
                        //TODO: snapshot.hasData return false je sais pas pk
                        if (snapshot.hasData) {
                          return RichText(
                            text: TextSpan(
                              text: snapshot.data!.companyName,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Text(
                              'Impossible de récupérer vos données. Veuillez réessayer plus tard.');
                        }
                        return const CircularProgressIndicator();
                      })),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 5,
                  ),
                  child: FutureBuilder<Offer>(
                      future: futureOffer,
                      builder: (context, snapshot) {
                        //TODO: snapshot.hasData return false je sais pas pk
                        if (snapshot.hasData) {
                          return Row(
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
                          );
                        } else if (snapshot.hasError) {
                          return const Text(
                              'Impossible de récupérer vos données. Veuillez réessayer plus tard.');
                        }
                        return const CircularProgressIndicator();
                      })),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 3,
                    bottom: 10,
                  ),
                  child: FutureBuilder<Offer>(
                      future: futureOffer,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return RichText(
                            text: const TextSpan(
                              text: "Il y a 5 jours",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Text(
                              'Impossible de récupérer vos données. Veuillez réessayer plus tard.');
                        }
                        return const CircularProgressIndicator();
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
