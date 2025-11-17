import 'package:digimon/pokemon_model.dart';
import 'pokemon_detail_page.dart';
import 'package:flutter/material.dart';


class DigimonCard extends StatefulWidget {
  final Digimon digimon;

  const DigimonCard(this.digimon, {super.key});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _DigimonCardState createState() => _DigimonCardState(digimon);
}

class _DigimonCardState extends State<DigimonCard> {
  Digimon digimon;
  String? renderUrl;

  _DigimonCardState(this.digimon);

  @override
  void initState() {
    super.initState();
    renderDigimonPic();
  }

  Widget get digimonImage {
    var digimonAvatar = Hero(
      tag: digimon,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration:
            BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(renderUrl ?? ''))),
      ),
    );

    var placeholder = Container(
      width: 100.0,
      height: 100.0,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient:
              LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black54, Colors.black, Color.fromARGB(255, 84, 110, 122)])),
      alignment: Alignment.center,
      child: const Text(
        'DIGI',
        textAlign: TextAlign.center,
      ),
    );

    var crossFade = AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: digimonAvatar,
      // ignore: unnecessary_null_comparison
      crossFadeState: renderUrl == null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 1000),
    );

    return crossFade;
  }

  void renderDigimonPic() async {
    await digimon.getImageUrl();
    if (mounted) {
      setState(() {
        renderUrl = digimon.imageUrl;
      });
    }
  }

  Widget get digimonCard {
    return Positioned(
      right: 0.0,
      child: SizedBox(
        width: 290,
        height: 115,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: const Color(0xFFF8F8F8),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  widget.digimon.name,
                  style: const TextStyle(color: Color(0xFF000600), fontSize: 27.0),
                ),
                Row(
                  children: <Widget>[
                    const Icon(Icons.star, color: Color(0xFF000600)),
                    Text(': ${widget.digimon.rating}/10', style: const TextStyle(color: Color(0xFF000600), fontSize: 14.0))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showDigimonDetailPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return DigimonDetailPage(digimon);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDigimonDetailPage(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SizedBox(
          height: 115.0,
          child: Stack(
            children: <Widget>[
              digimonCard,
              Positioned(top: 7.5, child: digimonImage),
            ],
          ),
        ),
      ),
    );
  }
}
