const String apiURL = 'https://10.0.2.2:5000/api/';
// const String apiURL ='https://192.168.0.3:5000/api/';
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

const String yes = 'Tak';
const String no = 'Nie';
const String light = 'light';
const String dark = 'dark';
const String special = 'special';
const String daltonism = 'daltonism';
const String changeToLightTheme = 'Jasny';
const String changeToDarkTheme = 'Ciemny';
const String changeToSpecialTheme = 'Specjalny';
const String changeToDaltonismTheme = 'Daltonizm';
const String titleOfApp = 'Biblioteczka';
const String tokenIsValid = 'token_valid';
const String giveMeUserNameError = 'Podaj nazwę użytkownika';
const String giveMeUserName = 'Nazwa użytkownika';
const String giveMeEmail = 'Wpisz email';
const String giveMeEmailError = 'Podaj adres email';
const String wrongEmailError = 'Podano niepoprawny adres email';
const String giveMePassword = 'Podaj hasło';
const String passwordIsDifferentError = 'Hasła są różne';
const String giveMeRepeatPassword = 'Powtórz hasło';
const String clickToRegisterButton = 'Zarejestruj się';
const String clickToLoginButton = 'Zaloguj się';
const String clickToLogOutButton = 'Wyloguj';
const String haveAccountQuestion1 = 'Masz już konto? Zaloguj się ';
const String haveOrNotAccountQuestion2 = 'tutaj';
const String notHaveAccountYetQuestion1 = 'Lub zarejestruj się ';
const String validatePasswordError =
    'Hasło musi zawierać od 10 do 50 znaków, w tym małe i duże litery, cyfry oraz znaki specjalne';
const String validateUsernameError =
    'Nazwa użytkownika musi zawierać od 10 do 50 znaków, w tym małe i duże litery, cyfry oraz znaki specjalne';
const String exitFromAppQuestion = 'Czy chcesz opuścić aplikację?';
const String exitFromAppTitle = 'Wyjście';
const String loginSuccessful = 'Zalogowano poprawnie';
const String loginNoDataError = 'Nieudana próba logowania - brak danych w bazie';
const String loginEmailError = 'Niepoprawny adres email';
const String registerSuccessful = 'Zarejestrowano poprawnie';
const String tooMuchLoginAttemptsError = 'locked_user_login_attempts';
const String sorryForError = 'Przepraszamy, wystąpił błąd';
const String userAlreadyLoggedIn = 'Użytkownik już zalogowany';
const String userAlreadyExists = 'Użytkownik już istnieje';
const String changeTheme = 'Zmień motyw';
const String settings = 'Ustawienia';
const String loading = 'Ładowanie';
const String nothingHere = 'Nic tu nie ma :(';

//ShowAndHideMoreText
const String showLess = ' Wyświetl mniej';
const String showMore = ' Wyświetl więcej';
const int lengthToShow = 110;

//DetailsOfBookScreen
const String bookTitle = 'Tytuł:';
const String bookAuthor = 'Autor:';
const String bookPublishingHouse = 'Wydawnictwo:';
const String opinionsAndTalks = "Opinie i dyskusje";

//OpinionScreen
const String minLengthForComment = 'Min 2 znaki';
const String maxLengthForComment = 'Max 1000 znaków';
const String writeOwnOpinion = 'Napisz swoją opinię...';
const String rateBookByStars = 'Oceń książkę ilością gwiazdek!';

//NewBooksScreen
const String dateOfPremiere = 'Data premiery:';

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
