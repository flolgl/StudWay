import 'package:flutter/material.dart';

class Body extends StatelessWidget{
  static const int _messageMax = 5;
  static const String _messageAuteur = "Jean Bernard";
  static const String _messageTime = "5 min";
  static const String _messageDebut  = "Lorem ipsum dolor sit amet. Sit mollitia quod eum neque dolorem sit porro atque! Aut nostrum voluptatum aut saepe iure non molestiae fugit ut totam nemo qui quia odio sed voluptatum quisquam et reprehenderit officia. Est Quis minima et saepe tempora ea pariatur omnis ut sint tempore quo velit nemo vel quia magni est labore autem!  Ab dolor dignissimos est veniam galisum ut dolorum molestias et aliquid dolores At explicabo voluptatum. In consequatur tempora et quam modi 33 dolorum aliquam aliquid molestiae et voluptatem officia. Nam velit vero ut blanditiis molestiae qui tempore quia rem quos earum in alias neque ea voluptas eveniet a itaque asperiores? Et nostrum quae est numquam laborum id necessitatibus galisum id harum autem.  Et accusamus accusamus sit dolorem omnis ab Quis optio ut fuga molestias. Non tenetur odit ut adipisci velit et vitae aliquid? ";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
                itemCount: _messageMax,
                itemBuilder: (context, text) =>
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 24.0,
                    ),
                    Expanded(
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
                    ),
                    const Opacity(
                      opacity: 0.65,
                      child: Text(_messageTime),
                    ),
                  ],
                )
            ),
          ),
        ),
      ],
    );
  }


}
