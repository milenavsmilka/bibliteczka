import 'package:biblioteczka/panels/functions.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Tools/DefaultAppBar.dart';
import 'AllBooksFromCategoryScreen.dart';

class ChooseCategoryScreen extends StatefulWidget {
  const ChooseCategoryScreen({super.key});

  @override
  State<ChooseCategoryScreen> createState() => _ChooseCategoryScreenState();
}

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(
          title: 'Kategoria',
          automaticallyImplyLeading: true,
        ),
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Wrap(children: [
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: 'Romans',
                      nameOfCategoryEN: 'Romance',
                      pathToImage: iconHeart,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Dziecięce',
                      nameOfCategoryEN: "Children's",
                      pathToImage: iconChild,
                    ),
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: 'Historia',
                      nameOfCategoryEN: 'History',
                      pathToImage: iconSwords,
                    ),
                    // SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                    CategoryButton(
                      nameOfCategory: 'Nauka',
                      nameOfCategoryEN: 'Popular Science',
                      pathToImage: iconBrainstorming,
                    ),
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: 'Wiersze',
                      nameOfCategoryEN: 'Poetry, Plays',
                      pathToImage: iconQuill,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Młodzieżowe',
                      nameOfCategoryEN: 'Young Adult',
                      pathToImage: iconYoungAdults,
                    )
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: 'Fantasy',
                      nameOfCategoryEN: 'Fantasy, Science fiction',
                      pathToImage: iconDragon,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Biografie',
                      nameOfCategoryEN: 'Biography',
                      pathToImage: iconContacts,
                    )
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: 'Przygodowe',
                      nameOfCategoryEN: 'Adventure',
                      pathToImage: iconAdventure,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Komiksy',
                      nameOfCategoryEN: 'Comic books',
                      pathToImage: iconComic,
                    )
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: 'Thrillery',
                      nameOfCategoryEN: 'Thriller, Horror, Mystery and detective stories',
                      pathToImage: iconDetective,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Inne',
                      nameOfCategoryEN: 'Other',
                      pathToImage: iconOther,
                    )
                  ],
                ),
                SizedBox(height: 20, width: 20),
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
      {super.key, required this.nameOfCategory, required this.pathToImage, required this.nameOfCategoryEN});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          checkIsTokenValid(
              context, AllCategoryBooksScreen(nameOfCategory: nameOfCategory,nameOfCategoryEN: nameOfCategoryEN,));
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23.0)))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(pathToImage,
                height: MediaQuery.of(context).size.width * 0.3),
            Text(nameOfCategory)
          ],
        ));
  }
}
