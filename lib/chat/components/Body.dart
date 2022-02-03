import 'package:flutter/material.dart';

/// Classe permettant d'afficher les conversations d'un user
class Body extends StatelessWidget{
  static const int _messageMax = 5;
  static const String _messageAuteur = "Jean Bernard";
  static const String _messageTime = "5 min";
  static const String _messageDebut  = "Logoden biniou degemer mat an penn ar bed homañ, brodañ warnañ, sellout diskenn kozh yod ennout Rosko outañ, stouiñ a Plouezoc’h giz c’hotoñs ilin amezeg. Mor fest glas rak sac’h vro brezhoneg mar nizez vilin fur izel ebet sizailh, kalz skrabañ burzhud siminal c’hoarvezout drezo tud torchañ war diskenn dremm. Here mil kazh c’hein stourm drezañ sec’h peoc’h asied, mat yenijenn kazeg krouiñ c’havr diskenn piv Gwikourvest gwengolo, plad disadorn chapel kroc’hen degemer oferenn e. Dremm yaouank sec’hed vouezh livet ganimp, ganeomp frouezh aour kaol, Mellag baner Skos karrezek tach benn kouezhañ abardaez mar, ma Penmarc’h wirionez kerzu oan echuiñ bugel. Melwenn lunedoù Plouha c’hontrol adarre avat ha c’hafe pakañ, lun ouzhimp vezañ taer nizez draonienn Gwaien graet bennak, garmiñ Mellag e se loa an da. Fentigelloù houarn chom heñvel eviti Entraven dindan  kezeg Breizh, c’heuz Tregastell dilhad kontañ deuet gwalc’hiñ munutenn volz ur, dihuniñ Pempoull fellout lezirek kreisteiz c’hreion stur. Menoz kement chadenn vuhez Arre strad muioc’h Gerveur houad, galon war gwinizh lun dant dit difenn korf banniel, lonkañ bruched hennont gant plijadur e c’hemener. Me e gasoni ni pomper trizek vuoc’h c’hezeg en, hini amann Santez-Anna-Wened Krouer kilhog c’hardeur pinvidik kreisteiz stank, biz paot eñ hervez  digant goañv broustañ. Penaos kegin hon Arre klouar graet keniterv ar vourc’h, Kermouster bemnoz sizailh gwern servijañ te azezañ tregas ur, perak breur diouzhtu digempenn hantereur prenañ lein. Muzilheg gwech ac'hanoc'h maen dindan  aozañ saveteiñ holen c’hwezek, e c’hroc’hen biskoazh c’houevr kegin montr biz tann yaou, lann vuiañ blot korf harzhal matezh leur.";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildListView(),
          ),
        ),
      ],
    );
  }


  /// Retourne une [ListView] correspond toutes les conversations d'une personne avec les détails tels que
  /// l'avatar du correspond, un début du texte ou depuis quand le message a été écrit
  ListView _buildListView() {
    return ListView.builder(
      itemCount: _messageMax,
      itemBuilder: (context, text) =>
      Row(
        children: [
          _buildCircleAvatar(),
          _buildMsgBody(),
          const Opacity(
            opacity: 0.65,
            child: Text(_messageTime),
          ),
        ],
      )
    );
  }

  /// Retourne un widget [Expanded] correspondant au nom du correspond et un début du dernier message de la conversation
  Expanded _buildMsgBody() {
    return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(_messageAuteur),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                Opacity(
                  opacity: 0.65,
                  child: Text(
                    _messageDebut,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              ],
            ),
          ),
        );
  }

  /// Retournant un [CircleAvatar] du correspondant
  CircleAvatar _buildCircleAvatar() {
    return const CircleAvatar(
      backgroundColor: Colors.amber,
      radius: 24.0,
    );
  }


}
