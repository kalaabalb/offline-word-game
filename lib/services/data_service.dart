import '../models/game_set.dart';
import '../models/question.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final List<GameSet> _gameSets = [];

  List<GameSet> get gameSets => _gameSets;

  // Add a new game set
  void addGameSet(GameSet set) {
    _gameSets.add(set);
  }

  // Get a game set by ID
  GameSet? getGameSetById(int id) {
    try {
      return _gameSets.firstWhere((set) => set.id == id);
    } catch (_) {
      return null;
    }
  }

  // Initialize with example data for testing
  void loadInitialData() {
    if (_gameSets.isNotEmpty) return;

    _gameSets.add(
      GameSet(
        id: 1,
        questions: [
          QuestionData(
            word: 'Sister',
            question: 'What are the things that your sister owns?',
            answers: ['Brush', 'Skirt', 'Bikini', 'Bag', 'Shoes', 'Hat', 'Phone'],
          ),
          QuestionData(
            word: 'Brother',
            question: 'What are the things that your brother likes?',
            answers: ['Football', 'Games', 'Music', 'Shoes', 'Laptop', 'Watch', 'Cap'],
          ),
          QuestionData(
            word: 'Father',
            question: 'What are your father\'s favorite hobbies?',
            answers: ['Reading', 'Driving', 'Fishing', 'Walking', 'Watching TV', 'Gardening', 'Cooking'],
          ),
          QuestionData(
            word: 'Mother',
            question: 'What are your mother\'s favorite things?',
            answers: ['Cooking', 'Sewing', 'Singing', 'Shopping', 'Praying', 'Gardening', 'Knitting'],
          ),
          QuestionData(
            word: 'Friend',
            question: 'What are the things your friend usually carries?',
            answers: ['Bag', 'Phone', 'Wallet', 'Watch', 'Keys', 'Notebook', 'Glasses'],
          ),
          QuestionData(
            word: 'Teacher',
            question: 'What are the things your teacher uses?',
            answers: ['Chalk', 'Book', 'Pen', 'Laptop', 'Marker', 'Paper', 'Eraser'],
          ),
        ],
      ),
    );
  }
}
