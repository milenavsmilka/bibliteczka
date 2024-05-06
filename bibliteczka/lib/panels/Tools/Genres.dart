import '../../styles/strings.dart';

enum Genres {
  all(name: allG, nameEN: allGEN),
  romance(name: romanceG, nameEN: romanceGEN),
  children(name: childrenG, nameEN: childrenGEN),
  history(name: historyG, nameEN: historyGEN),
  science(name: scienceG, nameEN: scienceGEN),
  poetry(name: poetryG, nameEN: poetryGEN),
  youngAdult(name: youngAdultG, nameEN: youngAdultGEN),
  fantasy(name: fantasyG, nameEN: fantasyGEN),
  bio(name: bioG, nameEN: bioGEN),
  adventure(name: adventureG, nameEN: adventureGEN),
  comics(name: comicsG, nameEN: comicsGEN),
  thriller(name: thrillerG, nameEN: thrillerGEN);

  const Genres({
    required this.name,
    required this.nameEN,
  });

  final String name;
  final String nameEN;


}