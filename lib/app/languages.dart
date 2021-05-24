class Language {
  final String? language;
  final String? code;
  final List<String>? text;

  Language({this.text, this.language, this.code});

  String? get getCode {
    switch (language) {
      case "English":
        return "ENG";
        break;
      case "हिन्दी":
        return "HIN";
        break;
      case "বাঙ্গালী":
        return "BAN";
        break;
      case "தமிழ்":
        return "TAM";
        break;
      case "తెలుగు":
        return "TEL";
        break;
    }
    return null;
  }

  String get getText {
    switch (code) {
      case "ENG":
        return "${text![0]}";
        break;
      case "HIN":
        return "${text![1]}";
        break;
      case "BAN":
        return "${text![2]}";
        break;
      case "TAM":
        return "${text![3]}";
        break;
      case "TEL":
        return "${text![4]}";
        break;
    }
    return text![0];
  }

  String? get getLang {
    switch (code) {
      case "ENG":
        return "English";
        break;
      case "HIN":
        return "हिन्दी";
        break;
      case "BAN":
        return "বাঙ্গালী";
        break;
      case "TAM":
        return "தமிழ்";
        break;
      case "TEL":
        return "తెలుగు";
        break;
    }
    return null;
  }
}
