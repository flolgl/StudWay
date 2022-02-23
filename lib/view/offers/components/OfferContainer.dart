import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OfferContainer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15,15,15,5),
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


        child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15,15,15,7),
                  child: RichText(
                    text: const TextSpan(
                      text: "Titre de l'emploi",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black, fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                  ),
                  child: RichText(
                    text: const TextSpan(
                      text: "Entreprise",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black, fontWeight: FontWeight.normal,
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
                      const Icon(Icons.room, color: Colors.grey,),
                      RichText(
                        text: const TextSpan(
                          text: "Lieu",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black, fontWeight: FontWeight.normal,
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
                text: const TextSpan(
                  text: "Il y a X jours",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey, fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}