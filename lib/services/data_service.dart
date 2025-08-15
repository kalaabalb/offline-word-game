import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_set.dart';
import '../models/question.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final List<GameSet> _gameSets = [];
  final String _storageKey = 'game_sets';

  List<GameSet> get gameSets => _gameSets;

  Future<void> loadGameSets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      try {
        final decoded = jsonDecode(jsonString) as List;
        _gameSets.clear();
        _gameSets.addAll(decoded.map((e) => GameSet.fromJson(e)));
        _gameSets.sort((a, b) => a.id.compareTo(b.id));
      } catch (e) {
        print('Error loading game sets: $e');
        loadInitialData();
      }
    } else {
      loadInitialData();
    }
  }

  Future<void> addGameSet(GameSet set) async {
    _gameSets.add(set);
    _gameSets.sort((a, b) => a.id.compareTo(b.id));
    await _saveGameSets();
  }

  Future<void> _saveGameSets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_gameSets.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  GameSet? getGameSetById(int id) {
    try {
      return _gameSets.firstWhere((set) => set.id == id);
    } catch (_) {
      return null;
    }
  }

  int getNextId() {
    if (_gameSets.isEmpty) return 1;
    return _gameSets.last.id + 1;
  }

  void loadInitialData() {
    if (_gameSets.isNotEmpty) return;

    // Set 1 - Family
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

    // Set 2 - School
    _gameSets.add(
      GameSet(
        id: 2,
        questions: [
          QuestionData(
            word: 'Math',
            question: 'What are common math terms?',
            answers: ['Algebra', 'Geometry', 'Calculus', 'Equation', 'Fraction', 'Theorem', 'Formula'],
          ),
          QuestionData(
            word: 'Science',
            question: 'What are branches of science?',
            answers: ['Biology', 'Chemistry', 'Physics', 'Astronomy', 'Geology', 'Botany', 'Zoology'],
          ),
          QuestionData(
            word: 'History',
            question: 'What are important historical periods?',
            answers: ['Ancient', 'Medieval', 'Renaissance', 'Industrial', 'Modern', 'Colonial', 'Digital'],
          ),
          QuestionData(
            word: 'Art',
            question: 'What are different art forms?',
            answers: ['Painting', 'Sculpture', 'Music', 'Dance', 'Theater', 'Literature', 'Film'],
          ),
          QuestionData(
            word: 'Sports',
            question: 'What are popular sports?',
            answers: ['Soccer', 'Basketball', 'Tennis', 'Swimming', 'Golf', 'Baseball', 'Volleyball'],
          ),
          QuestionData(
            word: 'Languages',
            question: 'What are widely spoken languages?',
            answers: ['English', 'Spanish', 'French', 'Mandarin', 'Arabic', 'Hindi', 'Russian'],
          ),
        ],
      ),
    );

    // Set 3 - Technology
    _gameSets.add(
      GameSet(
        id: 3,
        questions: [
          QuestionData(
            word: 'Phone',
            question: 'What are smartphone features?',
            answers: ['Camera', 'GPS', 'Bluetooth', 'Touchscreen', 'App Store', 'Fingerprint', 'Voice Assistant'],
          ),
          QuestionData(
            word: 'Computer',
            question: 'What are computer components?',
            answers: ['CPU', 'RAM', 'Hard Drive', 'Motherboard', 'GPU', 'Keyboard', 'Monitor'],
          ),
          QuestionData(
            word: 'Internet',
            question: 'What are internet services?',
            answers: ['Email', 'Streaming', 'Social Media', 'Cloud', 'E-commerce', 'Search', 'VPN'],
          ),
          QuestionData(
            word: 'Apps',
            question: 'What are popular app categories?',
            answers: ['Social', 'Productivity', 'Games', 'Health', 'Finance', 'Education', 'Entertainment'],
          ),
          QuestionData(
            word: 'Gadgets',
            question: 'What are modern gadgets?',
            answers: ['Smartwatch', 'Tablet', 'E-reader', 'Drone', 'VR Headset', 'Smart Speaker', 'Fitness Tracker'],
          ),
          QuestionData(
            word: 'Coding',
            question: 'What are programming languages?',
            answers: ['Python', 'Java', 'JavaScript', 'C++', 'Swift', 'Ruby', 'Go'],
          ),
        ],
      ),
    );

    // Set 4 - Food
    _gameSets.add(
      GameSet(
        id: 4,
        questions: [
          QuestionData(
            word: 'Fruits',
            question: 'What are common fruits?',
            answers: ['Apple', 'Banana', 'Orange', 'Grapes', 'Mango', 'Strawberry', 'Pineapple'],
          ),
          QuestionData(
            word: 'Vegetables',
            question: 'What are common vegetables?',
            answers: ['Carrot', 'Broccoli', 'Tomato', 'Potato', 'Spinach', 'Onion', 'Cucumber'],
          ),
          QuestionData(
            word: 'Drinks',
            question: 'What are popular beverages?',
            answers: ['Water', 'Coffee', 'Tea', 'Juice', 'Soda', 'Milk', 'Beer'],
          ),
          QuestionData(
            word: 'Desserts',
            question: 'What are sweet desserts?',
            answers: ['Cake', 'Ice Cream', 'Cookies', 'Pie', 'Pudding', 'Donuts', 'Brownies'],
          ),
          QuestionData(
            word: 'Fast Food',
            question: 'What are fast food items?',
            answers: ['Burger', 'Pizza', 'Fries', 'Hot Dog', 'Taco', 'Sandwich', 'Fried Chicken'],
          ),
          QuestionData(
            word: 'Breakfast',
            question: 'What are breakfast foods?',
            answers: ['Eggs', 'Pancakes', 'Cereal', 'Toast', 'Bacon', 'Yogurt', 'Oatmeal'],
          ),
        ],
      ),
    );

    // Set 5 - Travel
    _gameSets.add(
      GameSet(
        id: 5,
        questions: [
          QuestionData(
            word: 'Countries',
            question: 'What are popular travel destinations?',
            answers: ['France', 'Japan', 'USA', 'Italy', 'Spain', 'Thailand', 'Australia'],
          ),
          QuestionData(
            word: 'Transport',
            question: 'What are modes of transportation?',
            answers: ['Airplane', 'Train', 'Car', 'Boat', 'Bicycle', 'Bus', 'Subway'],
          ),
          QuestionData(
            word: 'Attractions',
            question: 'What are famous landmarks?',
            answers: ['Eiffel Tower', 'Pyramids', 'Great Wall', 'Colosseum', 'Statue of Liberty', 'Taj Mahal', 'Big Ben'],
          ),
          QuestionData(
            word: 'Activities',
            question: 'What are vacation activities?',
            answers: ['Sightseeing', 'Shopping', 'Hiking', 'Swimming', 'Museums', 'Photography', 'Dining'],
          ),
          QuestionData(
            word: 'Essentials',
            question: 'What to pack for travel?',
            answers: ['Passport', 'Clothes', 'Toiletries', 'Medicines', 'Charger', 'Camera', 'Money'],
          ),
          QuestionData(
            word: 'Seasons',
            question: 'When are best travel seasons?',
            answers: ['Spring', 'Summer', 'Fall', 'Winter', 'Holidays', 'Off-season', 'Weekends'],
          ),
        ],
      ),
    );
  }
}