// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get splashBranding => 'भारतीय सांकेतिक भाषा';

  @override
  String get navHome => 'होम';

  @override
  String get navLearn => 'सीखें';

  @override
  String get navChat => 'चैट';

  @override
  String get navHomeTooltip => 'साइन डिटेक्शन होम';

  @override
  String get navLearnTooltip => 'शैक्षिक केंद्र - ISL श्रेणियाँ';

  @override
  String get navChatTooltip => 'ISL चैटबॉट सहायक';

  @override
  String get homeCommunicate => 'संचार करें';

  @override
  String get homeFreely => 'स्वतंत्रता से';

  @override
  String get homeSubtitle => 'भारतीय सांकेतिक भाषा को सरल बनाएं';

  @override
  String get homeStartDetection => 'साइन डिटेक्शन शुरू करें';

  @override
  String get homeStartDetectionHint => 'शुरू करने के लिए कैमरा हाथों पर इंगित करें';

  @override
  String get homeStartDetectionLabel => 'साइन डिटेक्शन शुरू करें। कैमरा खोलने और संकेतों का पता लगाने के लिए टैप करें।';

  @override
  String get homeQuickAccess => 'त्वरित पहुँच';

  @override
  String get homePracticeMode => 'अभ्यास मोड';

  @override
  String get homeRecentSigns => 'हाल के संकेत';

  @override
  String get homeTipTitle => 'आज की टिप';

  @override
  String get homeTipBody => '\"नमस्ते\" संकेत का अभ्यास करें: खुली हथेली को साइड से साइड तक लहराएं।';

  @override
  String get eduHubTitle => 'शैक्षिक केंद्र';

  @override
  String eduHubCategoriesToExplore(int count) {
    return '$count श्रेणियाँ खोजने के लिए';
  }

  @override
  String get eduHubInteractiveLearning => 'इंटरएक्टिव लर्निंग';

  @override
  String get eduHubLearnWith3D => '3D अवतार के साथ सीखें';

  @override
  String get eduHubAvatarDesc => 'हर ISL संकेत को पूर्ण 3D में एक एनिमेटेड अवतार द्वारा देखें। कैमरा घुमाएं, प्लेबैक गति समायोजित करें, और अपने अनुसार संकेतों का अन्वेषण करें।';

  @override
  String get eduHubOpen3DViewer => '3D व्यूअर खोलें';

  @override
  String get eduHubSignCategories => 'संकेत श्रेणियाँ';

  @override
  String eduHubTopicsCount(int count) {
    return '$count विषय';
  }

  @override
  String get eduHubAvatarSemantics => 'इंटरएक्टिव 3D अवतार के साथ भारतीय सांकेतिक भाषा सीखें। अन्वेषण के लिए टैप करें।';

  @override
  String get categoryAlphabets => 'वर्णमाला';

  @override
  String get categoryAlphabetsDesc => 'A से Z हाथ के संकेत';

  @override
  String get categoryNumbers => 'संख्याएँ';

  @override
  String get categoryNumbersDesc => '0 से 100 संकेत';

  @override
  String get categoryDailyActions => 'दैनिक क्रियाएँ';

  @override
  String get categoryDailyActionsDesc => 'खाना, पीना, जाना और अधिक';

  @override
  String get categoryEmotions => 'भावनाएँ';

  @override
  String get categoryEmotionsDesc => 'खुश, उदास, गुस्सा...';

  @override
  String get categoryEmergency => 'आपातकाल';

  @override
  String get categoryEmergencyDesc => 'मदद, खतरा, रुकें';

  @override
  String get categoryGreetings => 'अभिवादन';

  @override
  String get categoryGreetingsDesc => 'नमस्ते, धन्यवाद, अलविदा';

  @override
  String lessonComingSoonTitle(String title) {
    return '$title पाठ';
  }

  @override
  String get lessonComingSoon => 'जल्द आ रहा है! पाठ सामग्री\nयहाँ दिखाई देगी।';

  @override
  String get lessonGoBack => 'वापस जाएँ';

  @override
  String get chatbotTitle => 'ISL गाइड';

  @override
  String get chatbotStatus => 'मुझसे टेक्स्ट या संकेत में पूछें';

  @override
  String get chatbotWelcome => 'नमस्ते! मैं आपका ISL गाइड हूँ। मुझसे किसी भी सामान्य, स्वास्थ्य या समर्थन प्रश्न पूछें।';

  @override
  String get chatbotInputHint => 'कुछ भी पूछें…';

  @override
  String get chatbotCameraLabel => 'संकेत पहचानने के लिए कैमरा उपयोग करें';

  @override
  String get chatbotSendLabel => 'संदेश भेजें';

  @override
  String get chatbotLowConfidence => 'कम आत्मविश्वास संकेत पहचान। कृपया पुनः प्रयास करें।';

  @override
  String get chatbotDetectionFailed => 'संकेत पहचान विफल।';

  @override
  String get chatbotBackendError => 'बैकेंड कनेक्शन त्रुटि।';

  @override
  String get recordTitle => 'संकेत रिकॉर्ड करें';

  @override
  String get recordGoBack => 'वापस जाएं';

  @override
  String get recordSwitchCamera => 'कैमरा बदलें';

  @override
  String get recordPositionHint => '🤚  अपने हाथ को फ्रेम में रखें';

  @override
  String get recordStatusIdle => 'रिकॉर्डिंग शुरू करने के लिए टैप करें';

  @override
  String get recordStatusRecording => 'आपका संकेत रिकॉर्ड हो रहा है…';

  @override
  String get recordStartBtn => 'रिकॉर्डिंग शुरू करें';

  @override
  String get recordStopBtn => 'रिकॉर्डिंग रोकें';

  @override
  String recordCameraUnavailable(String error) {
    return 'कैमरा उपलब्ध नहीं: $error';
  }

  @override
  String get previewTitle => 'संकेत पूर्वावलोकन';

  @override
  String get previewRetake => 'फिर से लें';

  @override
  String get previewReplay => 'फिर से चलाएं';

  @override
  String get previewHint => 'भेजने से पहले अपने संकेत की समीक्षा करें';

  @override
  String get previewUpload => 'अपलोड करें और भविष्यवाणी करें';

  @override
  String get previewAnalysing => 'संकेत का विश्लेषण कर रहे हैं…';

  @override
  String get previewSendingToModel => 'ISL मॉडल को भेज रहे हैं';

  @override
  String previewPredictionFailed(String error) {
    return 'भविष्यवाणी विफल: $error';
  }

  @override
  String get resultTitle => 'पता लगाने का परिणाम';

  @override
  String get resultShare => 'परिणाम साझा करें';

  @override
  String get resultBackToPreview => 'पूर्वावलोकन पर वापस जाएं';

  @override
  String get resultSignDetected => 'संकेत सफलतापूर्वक पहचाना गया';

  @override
  String get resultPredictedSign => 'अनुमानित संकेत';

  @override
  String get resultConfidenceScore => 'विश्वास स्कोर';

  @override
  String resultAccurate(String pct) {
    return '$pct% सटीक';
  }

  @override
  String get resultHighConfidence => 'उच्च विश्वास';

  @override
  String get resultMediumConfidence => 'मध्यम विश्वास';

  @override
  String get resultLowConfidence => 'कम विश्वास';

  @override
  String get resultRecordAgain => 'फिर से रिकॉर्ड करें';

  @override
  String get resultFeedbackTitle => 'GESPY को बेहतर बनाने में मदद करें';

  @override
  String resultFeedbackQuestion(String label) {
    return 'क्या \"$label\" सही था?';
  }

  @override
  String get resultFeedbackYes => 'हाँ, सही!';

  @override
  String get resultFeedbackNo => 'नहीं, गलत';

  @override
  String get resultFeedbackWhatCorrect => 'सही संकेत क्या था?';

  @override
  String get resultFeedbackSelectHint => 'सही संकेत चुनें';

  @override
  String get resultFeedbackSubmit => 'सुधार सबमिट करें';

  @override
  String get resultFeedbackSubmitting => 'प्रतिक्रिया सबमिट कर रहे हैं...';

  @override
  String get resultFeedbackThanks => 'पुष्टि करने के लिए धन्यवाद! 🎉';

  @override
  String get resultFeedbackError => 'सबमिट नहीं कर सके। कृपया पुनः प्रयास करें।';

  @override
  String categoryDetailProgress(int percent) {
    return '$percent%';
  }

  @override
  String get quizTitle => 'प्रश्नोत्तरी';

  @override
  String get quizCompleted => 'प्रश्नोत्तरी पूरी हुई';

  @override
  String quizScore(int score, int total) {
    return 'आपका स्कोर: $score / $total';
  }

  @override
  String get recentSignsTitle => 'हाल के संकेत';

  @override
  String get detectionScreenTitle => 'संकेत पहचान';

  @override
  String get detectionToggleFlash => 'फ्लैशलाइट चालू/बंद करें';

  @override
  String get detectionSwitchCamera => 'कैमरा बदलें';

  @override
  String get detectionPositionHand => 'अपना हाथ यहाँ रखें\n';

  @override
  String get detectionWaiting => 'संकेत की प्रतीक्षा…';

  @override
  String get detectionPlaceholderLabel => 'पहचाना गया संकेत यहाँ दिखाई देगा';

  @override
  String get genericBackendPending => '🚧 बैकएंड एकीकरण लंबित';
}
