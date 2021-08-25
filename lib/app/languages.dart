class Language {
  final String? language;
  final String? code;
  final List<dynamic>? text;

  Language({this.text, this.language, this.code});

  String? get getCode {
    switch (language) {
      case "English":
        return "ENG";

      case "हिन्दी":
        return "HIN";

      case "বাঙ্গালী":
        return "BAN";

      case "தமிழ்":
        return "TAM";

      case "తెలుగు":
        return "TEL";
    }
    return null;
  }

  String get getText {
    if(text!.isEmpty){
      return "";
    }
    switch (code) {
      case "ENG":
        return "${text![0]}";

      case "HIN":
        return "${text![1]}";

      case "BAN":
        return "${text![2]}";

      case "TAM":
        return "${text![3]}";

      case "TEL":
        return "${text![4]}";
    }
    return text![0];
  }

  String? get getLang {
    switch (code) {
      case "ENG":
        return "English";

      case "HIN":
        return "हिन्दी";

      case "BAN":
        return "বাঙ্গালী";

      case "TAM":
        return "தமிழ்";

      case "TEL":
        return "తెలుగు";
    }
    return null;
  }
}
