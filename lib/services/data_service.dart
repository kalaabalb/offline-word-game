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
  final String _versionKey = 'data_version';
  final int _currentVersion = 2; // Increment this whenever initial data changes

  List<GameSet> get gameSets => _gameSets;

  Future<void> loadGameSets() async {
    final prefs = await SharedPreferences.getInstance();
    final savedVersion = prefs.getInt(_versionKey) ?? 0;
    final jsonString = prefs.getString(_storageKey);

    if (savedVersion < _currentVersion) {
      // Version outdated, reload initial data
      loadInitialData();
      await _saveGameSets();
      await prefs.setInt(_versionKey, _currentVersion);
    } else if (jsonString != null) {
      try {
        final decoded = jsonDecode(jsonString) as List;
        _gameSets.clear();
        _gameSets.addAll(decoded.map((e) => GameSet.fromJson(e)));
        _gameSets.sort((a, b) => a.id.compareTo(b.id));
      } catch (e) {
        print('Error loading game sets: $e');
        loadInitialData();
        await _saveGameSets();
        await prefs.setInt(_versionKey, _currentVersion);
      }
    } else {
      // No data at all, load initial
      loadInitialData();
      await _saveGameSets();
      await prefs.setInt(_versionKey, _currentVersion);
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
    _gameSets.clear();

    // --- Set 1:  ---
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
            word: 'ወንድም',
            question: 'ወንድምህ የሚወዳቸው ነገሮች ምን ናቸው?',
            answers: ['እግር ኳስ', 'ጨዋታዎች', 'ሙዚቃ', 'ጫማ', 'ኮምፒዩተር', 'ሰአት', 'ኮፍያ'],
          ),
          QuestionData(
            word: 'አባት',
            question: 'አባትህ የሚወዳቸው ልማዶች ምን ናቸው?',
            answers: ['ንባብ', 'መንዳት', 'መስራት', 'መዝናናት', 'ቴሌቪዥን ማየት', 'አትክልት ማብቀል', 'ምግብ ማብሰል'],
          ),
          QuestionData(
            word: 'እናት',
            question: 'እናትህ የምትወዳቸው ነገሮች ምን ናቸው?',
            answers: ['ቡና', 'ማውራት', 'መዝናናት', 'መግዛት', 'ጸሎት', 'ድራማዎችን መመልከት', 'ጉብኝት'],
          ),
          QuestionData(
            word: 'ጓደኛ',
            question: 'ጓደኛህ ብዙ ጊዜ የሚይዛቸው ነገሮች ምን ናቸው?',
            answers: ['ብር', 'ስልክ', 'ዋሌት', 'ሰአት', 'መኪና', 'ፊልም', 'መዝናናት'],
          ),
          QuestionData(
            word: 'ሙያዎች',
            question: 'የተለመዱ ሙያዎች ማን ናቸው?',
            answers: ['ሐኪም', 'አስተማሪ', 'ኢንጅነር', 'ገበሬ', 'አብራሪ', 'ሼፍ', 'ፖሊስ'],
          ),
        ],
      ),
    );

    // --- Set 2:  ---
    _gameSets.add(
      GameSet(
        id: 2,
        questions: [
          QuestionData(
            word: 'ኪነ-ጥበብ',
            question: 'የኪነ-ጥበብ አይነቶች ምን ናቸው?',
            answers: ['ቅርጽ', 'ሙዚቃ', 'ዳንስ', 'ትወና', 'ሥነ-ጽሁፍ', 'ፊልም', 'ሰእል'],
          ),
          QuestionData(
            word: 'ስፖርት',
            question: 'በኢትዮጵያ ታወቁ ስፖርቶች ምን ናቸው?',
            answers: ['እግር ኳስ', 'አትሌቲክስ', 'ቅርጫት ኳስ', 'መረብ ኳስ', 'ገና', 'ሩጫ', 'ሳይክል'],
          ),
          QuestionData(
            word: 'ቋንቋዎች',
            question: 'በኢትዮጵያ የሚነገሩ ቋንቋዎች ምን ናቸው?',
            answers: ['አማርኛ', 'ኦሮምኛ', 'ትግርኛ', 'ሶማሊኛ', 'አፋርኛ', 'ሲዳማ', 'አፋር'],
          ),
          QuestionData(
            word: 'እህት',
            question: 'እህትህ ያላት ነገሮች ምን ናቸው?',
            answers: ['የፀጉር ሜዶ', 'ቀሚስ', 'ሜካፕ', 'ቦርሳ', 'ጫማ', 'ኮፍያ', 'ስልክ'],
          ),
          QuestionData(
            word: 'እንስሳት',
            question: 'የተለመዱ ዱር እንስሳት ማን ናቸው?',
            answers: ['አንበሳ', 'ነብር', 'ዝሆን', 'ቀጭኔ', 'የሜዳ አህያ', 'ነብር', 'ተኩላ'],
          ),
          QuestionData(
            word: 'መምህር',
            question: 'መምህርህ የሚጠቀሙት ነገሮች ምን ናቸው?',
            answers: ['ጠመኔ', 'መጽሐፍ', 'ብዕር', 'ኮምፒዩተር', 'ማርከር', 'ወረቀት', 'ጋዉን'],
          ),
        ],
      ),
    );

    // --- Set 3:  ---
    _gameSets.add(
      GameSet(
        id: 3,
        questions: [
          QuestionData(
            word: 'እቃዎች',
            question: 'በዕለት ተዕለት የምንጠቀባቸው እቃዎች ምን ናቸው?',
            answers: ['ሳሙና', 'ጫማ', 'ቀሚስ', 'ሻምፑ', 'ልብስ', 'መኪና', 'ስልክ'],
          ),
          QuestionData(
            word: 'ቤት',
            question: 'ቤት ውስጥ የሚገኙ ነገሮች ምን ናቸው?',
            answers: ['መኝታ', 'ቲቪ', 'ሳሎን', 'መታጠቢያ', 'ጠረጴዛ', 'መቀመጫ', 'መብራት'],
          ),
          QuestionData(
            word: 'ምግቦች',
            question: 'ከእንጀራ ጋር የሚቀርቡ ምን ናቸው?',
            answers: ['ስጋ ወጥ', 'ምስር ወጥ', 'ሽሮ', 'ጎመን ወጥ', 'ድንች ወጥ', 'አልጫ ወጥ', 'ዶሮ ወጥ'],
          ),
          QuestionData(
            word: 'መጠጦች',
            question: 'በኢትዮጵያ የታወቁ መጠጦች ምን ናቸው?',
            answers: ['ውሃ', 'ቡና', 'ሻይ', 'ጭማቂ', 'ቢራ', 'ጠጅ', 'ጠላ'],
          ),
          QuestionData(
            word: 'አትክልቶች',
            question: 'የተለመዱ አትክልቶች ምን ናቸው?',
            answers: ['ካሮት', 'ጎመን', 'ቲማቲም', 'ድንች', 'ሰላጥ', 'ዱባ', ' ጎመን'],
          ),
          QuestionData(
            word: 'በአገር ውስጥ',
            question: 'በኢትዮጵያ የሚገኙ የታወቁ ቦታዎች ምን ናቸው?',
            answers: ['ላሊበላ', 'አክሱም', 'ባህር ዳር', 'ጎንደር', 'አዲስ አበባ', 'ሃዋሳ', 'አፋር'],
          ),
        ],
      ),
    );

    // --- Set 4 ---
    _gameSets.add(
      GameSet(
        id: 4,
        questions: [
          QuestionData(
            word: 'ፍራፍሬዎች',
            question: 'የተለመዱ ፍራፍሬዎች ምን ናቸው?',
            answers: ['አፕል', 'ዘይቱን', 'ብርቱካን', 'ሙዝ', 'ማንጎ', 'አናናስ', 'አቩካዶ'],
          ),
          QuestionData(
            word: 'መጓጓዣ',
            question: 'የመጓጓዣ ዘዴዎች ምን ናቸው?',
            answers: ['አውሮፕላን', 'ባቡር', 'መኪና', 'ጀልባ', 'ብስክሌት', 'አውቶቡስ', 'በእግር'],
          ),
          QuestionData(
            word: 'መስህቦች',
            question: 'ታዋቂ ቦታዎች ምንድን ናቸው?',
            answers: ['አዲስ አበባ', 'አክሱም', 'አባይ ግድብ', 'ላሊበላ', 'ሐረር', 'ጣና ሀይቅ', 'ጎንደር'],
          ),
          QuestionData(
            word: 'ተግባራት',
            question: 'ምን ማድረግ የእረፍት ጊዜ ነገሮች ናቸው?',
            answers: ['ጉብኝት', 'መግዛት', 'የእግር ጉዞ', 'መዋኘት', 'ሙዚየሞች', 'ፎቶግራፍ ማንሳት', 'ግብዣ'],
          ),
          QuestionData(
            word: 'አስፈላጊ ነገሮች',
            question: 'በሚጓዙበት ጊዜ ምን እንደሚወስዱ?',
            answers: ['ፓስፖርት', 'ልብሶች', 'ጽዳት-እቃ', 'መድሃኒቶች', 'ስል', 'ካሜራ', 'ብር'],
          ),
          QuestionData(
            word: 'ዎቅቶች ',
            question: 'ምርጥ የጉዞ ወቅቶች መቼ ናቸው።?',
            answers: ['ጸደይ', 'በጋ', 'መኸር', 'ክረምት', 'በዓላት', 'እረፍት-ዎቅት', 'ቅዳሜና እሁድ'],
          ),
        ],
      ),
    );

    // --- Set 5 ---
    _gameSets.add(
      GameSet(
        id: 5,
        questions: [
          QuestionData(
            word: 'የአፍሪካ አገሮች',
            question: 'የአፍሪካ አገሮች ማን ናቸው?',
            answers: ['ኢትዮጵያ', 'ኬንያ', 'ናይጄሪያ', 'ግብጽ', 'ደቡብ አፍሪካ', 'ኤርትሪያ', 'ጂቡቲ'],
          ),
          QuestionData(
            word: 'ቀለሞች',
            question: 'የተለመዱ ቀለሞች ማን ናቸው?',
            answers: ['ቀይ', 'ሰማያዊ', 'አረንጓዴ', 'ቢጫ', 'ጥቁር', 'ነጭ', 'ቡኒ'],
          ),
          QuestionData(
            word: 'የሙዚቃ መሳሪያዎች',
            question: 'የተለመዱ የሙዚቃ መሳሪያዎች ማን ናቸው?',
            answers: ['ጊታር', 'ፒያኖ', 'ከበሮ', 'በገና', 'መለከት', 'ክራር', 'ዋሽንት'],
          ),
          QuestionData(
            word: 'ኤሌክትሮኒክ መሳሪያዎች',
            question: 'የተለመዱ ኤሌክትሮኒክ መሳሪያዎች ማን ናቸው?',
            answers: ['ስልክ', 'ላፕቶፕ', 'ታብሌት', 'ካሜራ', 'ቲቪ', 'ስማርትዎች', 'ፕሪንተር'],
          ),
          QuestionData(
            word: 'መኪና',
            question: 'የተለመዱ የመኪና እቃዎች ማን ናቸው?',
            answers: ['ሞተር', 'መሪ', 'የኋላ መብራት ', 'ብሎምበር', 'መብራት', 'መስተዋት', 'መቀመጫ'],
          ),
          QuestionData(
            word: 'ቤት',
            question: 'እነዚህ ቃላት በ"ቤት" ይጨምራሉ። ምሳሌ ምን ናቸው?',
            answers: ['መኝታ ቤት', 'ትምህርት ቤት', 'ስፖርት ቤት', 'መጠጥ ቤት', 'መናፈሻ ቤት', 'መጻሕፍት ቤት', 'ባኞ ቤት'],
          ),
        ],
      ),
    );
  }
}
