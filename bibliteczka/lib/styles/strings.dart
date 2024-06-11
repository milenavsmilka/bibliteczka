// const String apiURL = 'https://10.0.2.2:5000/api/';
const String apiURL ='https://192.168.1.108:5000/api/';
const String apiURLRegister = '${apiURL}account/register';
const String apiURLLogin = '${apiURL}account/login';
const String apiURLLogOut = '${apiURL}account/logout';
const String apiURLIsTokenValid = '${apiURL}account/check_if_logged_in';
const String apiURLDeleteAccount = '${apiURL}account/delete_account';
const String apiURLChangePassword = '${apiURL}account/change_password';
const String apiURLGetBooks = '${apiURL}data/book';
const String apiURLGetNewBooks = '${apiURL}data/new_book';
const String apiURLGetAuthor = '${apiURL}data/author';
const String apiURLGetOpinion = '${apiURL}data/opinion';
const String apiURLBookFromFav = '${apiURL}data/favourite_book';
const String apiURLBookFromRead = '${apiURL}data/read_book';
const String apiURLGetUser = '${apiURL}data/user';
const String apiURLChangeProfilePicture = '${apiURL}account/change_profile_picture';
const String apiURLChangeTheme = '${apiURL}account/change_theme';
const String apiURLFan = '${apiURL}data/fan';
const String apiURLQuote = '${apiURL}data/quotes';
const String apiURLSimilarBooks = '${apiURL}data/similar_books';

const String iconHeart = "assets/icons/hearts.svg";
const String iconBrainstorming = "assets/icons/brainstorming.svg";
const String iconChild = "assets/icons/child.svg";
const String iconContacts = "assets/icons/contacts.svg";
const String iconContactsBook = "assets/icons/contactsBook.svg";
const String iconDetective = "assets/icons/detective.svg";
const String iconDragon = "assets/icons/dragon.svg";
const String iconHeartsOneIsEmpty = "assets/icons/heartsOneIsEmpty.svg";
const String iconMailWithHeart = "assets/icons/mailWithHeart.svg";
const String iconQuill = "assets/icons/quill.svg";
const String iconSwords = "assets/icons/swords.svg";
const String iconSwordsWithEmblem = "assets/icons/swordsWithEmblem.svg";
const String iconWand = "assets/icons/wand.svg";
const String iconYoungAdults = "assets/icons/youngAdults.svg";
const String iconComic = "assets/icons/comic.svg";
const String iconOther = "assets/icons/other.svg";
const String iconAdventure = "assets/icons/adventure.svg";

const String search = 'Wyszukaj';
const String nothingHere = 'Nic tu nie ma :(';

const String library = "Biblioteczka";
const String light = 'light';
const String dark = 'dark';
const String special = 'special';
const String daltonism = 'daltonism';

const int lengthToShow = 110;

//Categories
const String romanceG = 'Romans';
const String childrenG = 'Dziecięce';
const String historyG = 'Historia';
const String scienceG = 'Nauka';
const String poetryG = 'Wiersze';
const String youngAdultG = 'Młodzieżowe';
const String fantasyG = 'Fantasy';
const String bioG = 'Biografie';
const String adventureG = 'Przygodowe';
const String comicsG = 'Komiksy';
const String thrillerG = 'Thrillery';
const String allG = 'Wszystko';
const String otherG = 'Inne';
const String allGEN = 'All';
const String romanceGEN = 'Romance';
const String childrenGEN = "Children's";
const String historyGEN = 'History';
const String scienceGEN = 'Popular Science';
const String poetryGEN = 'Poetry, Plays';
const String youngAdultGEN = 'Young Adult';
const String fantasyGEN = 'Fantasy, Science fiction';
const String bioGEN = 'Biography';
const String adventureGEN = 'Action & Adventure';
const String comicsGEN = 'Comic books';
const String thrillerGEN = 'Thriller, Horror, Mystery and detective stories';
const String otherGEN = 'Other';

const List<String> listOfPolishSpecialChars = ['Ą', 'Ć', 'Ę', 'Ł', 'Ń', 'Ó', 'Ś', 'Ź', 'Ż'];
const List<String> listOfCzechSpecialChars = [
  'Á',
  'Č',
  'Ď',
  'É',
  'Ě',
  'Í',
  'Ň',
  'Ó',
  'Ř',
  'Š',
  'Ť',
  'Ú',
  'Ů',
  'Ý',
  'Ž',
];
const List<String> listOfGermanySpecialChars = ['Ä', 'Ö', 'Ü', 'ß'];

const List<String> listOfAlphabet = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];
