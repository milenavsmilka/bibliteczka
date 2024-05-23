import 'package:biblioteczka/panels/Tools/Genres.dart';
import 'package:biblioteczka/panels/Tools/Search.dart';
import 'package:biblioteczka/panels/Tools/functions.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Tools/CustomPageRoute.dart';
import '../Tools/DefaultAppBar.dart';
import 'AllBooksFromCategory.dart';

class ChooseCategoryScreen extends StatefulWidget {
  const ChooseCategoryScreen({super.key});

  @override
  State<ChooseCategoryScreen> createState() => _ChooseCategoryScreenState();
}

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: const DefaultAppBar(
          title: category,
          automaticallyImplyLeading: true,
          turnSearch: SearchScreen.TURNBOOKS,
        ),
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Wrap(children: [
                SizedBox(height: heightScreen * 0.025, width: widthScreen * 0.18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: Genres.romance.name,
                      nameOfCategoryEN: Genres.romance.nameEN,
                      pathToImage: iconHeart,
                    ),
                    CategoryButton(
                      nameOfCategory: Genres.children.name,
                      nameOfCategoryEN: Genres.children.nameEN,
                      pathToImage: iconChild,
                    ),
                  ],
                ),
                SizedBox(height: heightScreen * 0.025, width: widthScreen * 0.18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: Genres.history.name,
                      nameOfCategoryEN: Genres.history.nameEN,
                      pathToImage: iconSwords,
                    ),
                    CategoryButton(
                      nameOfCategory: Genres.science.name,
                      nameOfCategoryEN: Genres.science.nameEN,
                      pathToImage: iconBrainstorming,
                    ),
                  ],
                ),
                SizedBox(height: heightScreen * 0.025, width: widthScreen * 0.18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: Genres.poetry.name,
                      nameOfCategoryEN: Genres.poetry.nameEN,
                      pathToImage: iconQuill,
                    ),
                    CategoryButton(
                      nameOfCategory: Genres.youngAdult.name,
                      nameOfCategoryEN: Genres.youngAdult.nameEN,
                      pathToImage: iconYoungAdults,
                    )
                  ],
                ),
                SizedBox(height: heightScreen * 0.025, width: widthScreen * 0.18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: Genres.fantasy.name,
                      nameOfCategoryEN: Genres.fantasy.nameEN,
                      pathToImage: iconDragon,
                    ),
                    CategoryButton(
                      nameOfCategory: Genres.bio.name,
                      nameOfCategoryEN: Genres.bio.nameEN,
                      pathToImage: iconContacts,
                    )
                  ],
                ),
                SizedBox(height: heightScreen * 0.025, width: widthScreen * 0.18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: Genres.adventure.name,
                      nameOfCategoryEN: Genres.adventure.nameEN,
                      pathToImage: iconAdventure,
                    ),
                    CategoryButton(
                      nameOfCategory: Genres.comics.name,
                      nameOfCategoryEN: Genres.comics.nameEN,
                      pathToImage: iconComic,
                    )
                  ],
                ),
                SizedBox(height: heightScreen * 0.025, width: widthScreen * 0.18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: Genres.thriller.name,
                      nameOfCategoryEN: Genres.thriller.nameEN,
                      pathToImage: iconDetective,
                    ),
                    CategoryButton(
                      nameOfCategory: Genres.other.name,
                      nameOfCategoryEN: Genres.other.nameEN,
                      pathToImage: iconOther,
                    )
                  ],
                ),
                SizedBox(height: heightScreen * 0.025, width: widthScreen * 0.18),
              ]),
            )
          ],
        ));
  }
}

class CategoryButton extends StatelessWidget {
  final String nameOfCategory;
  final String nameOfCategoryEN;
  final String pathToImage;

  const CategoryButton(
      {super.key,
      required this.nameOfCategory,
      required this.pathToImage,
      required this.nameOfCategoryEN});

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;

    return ElevatedButton(
        onPressed: () {
          checkIsTokenValid(
              context,
              Navigator.push(
                  context,
                  CustomPageRoute(
                      chooseAnimation: CustomPageRoute.SLIDE,
                      child: AllCategoryBooksScreen(
                        nameOfCategory: nameOfCategory,
                        nameOfCategoryEN: nameOfCategoryEN,
                      ))));
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(23.0)))),
        child: SizedBox(
          height: widthScreen * 0.3 + widthScreen * 0.1,
          width: widthScreen * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(pathToImage,
                  height: widthScreen * 0.3, color: Theme.of(context).textTheme.titleSmall?.color),
              Text(
                nameOfCategory,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ));
  }
}
