import 'package:flutter/material.dart';
import 'package:studway_project/controller/conversation/Conversation.dart';
import 'package:studway_project/view/chat/components/ConversationView.dart';

import '../../../controller/offer/Offer.dart';
import '../../../controller/user/User.dart';
import 'OfferFullView.dart';

class OfferContainer extends StatefulWidget {
  final int id;

  const OfferContainer(this.id, {Key? key}) : super(key: key);

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
  late List<Offer> allFavOffers;
  bool offerIsFav = false;
  bool isFetched = false;

  _OfferContainerState(this.id); //late Future<int> amountOfDaysSinceUpload;

  @override
  void initState() {
    super.initState();
    futureOffer = Offer.fetchOfferInfoByID(id);
    isOfferFav();
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
            if (snapshot.hasData && isFetched) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          OfferFullView(User.currentUser!, snapshot.data!)));
                },
                child: Container(
                  height: 200,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 15, 7),
                              child: RichText(
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
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
                              padding: const EdgeInsets.only(
                                left: 15,
                              ),
                              child: RichText(
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
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
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
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
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
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
                      Column(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 10, right: 12),
                            child: IconButton(
                              icon: Icon(Icons.favorite_border_outlined,
                                  color: containsFav(snapshot.data!)
                                      ? Colors.red
                                      : Colors.grey),
                              onPressed: () async {
                                if (containsFav(snapshot.data!)) {
                                  var deleted =
                                  await User.currentUser!.deleteFav(id);
                                  if (deleted) {
                                    setState(() {
                                      allFavOffers.removeWhere((item) =>
                                      item.id == snapshot.data!.id);
                                    });
                                  }
                                } else {
                                  var added = await User.currentUser!.addFav(id);
                                  if(added) {
                                    setState(() {
                                      allFavOffers.add(snapshot.data!);
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 10, right: 12),
                            child: IconButton(
                              icon: const Icon(Icons.message_outlined, color: Colors.grey),
                              onPressed: () {
                                getConv(context, snapshot.data!);
                              },
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Text(
                  'Impossible de récupérer vos données. Veuillez réessayer plus tard.');
            }
            return const Center();
          },
        ),
      ),
    );
  }

  void getConv(BuildContext context, Offer data) async{
    if (data.entrepriseId == User.currentUser!.id){
      return;
    }
    var user = await User.fetchStrictUserInfo(data.entrepriseId);
    var convs = await User.currentUser!.getUpdatedConversations();
    Conversation conv;
    try {
      conv = convs.firstWhere((element) => (element.members[0].id == user.id || element.members[1].id == user.id));
    }
    catch(e){
      conv = await Conversation.createConversation(User.currentUser!,user, data.id, data.titre);
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConversationView(conv)));
  }

  void isOfferFav() async {
    var favList = await User.currentUser!.fetchCandidatFav();
    setState(() {
      allFavOffers = favList;
      isFetched = true;
    });
  }

  bool containsFav(Offer offer) {
    for (var offre in allFavOffers) {
      if (offre.id == offer.id) {
        return true;
      }
    }
    return false;
  }

}
