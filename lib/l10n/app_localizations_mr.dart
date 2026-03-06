// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get splashBranding => 'भारतीय सांकेतिक भाषा';

  @override
  String get navHome => 'मुख्यपृष्ठ';

  @override
  String get navLearn => 'शिका';

  @override
  String get navChat => 'चॅट';

  @override
  String get navHomeTooltip => 'सांकेतिक ओळख मुख्यपृष्ठ';

  @override
  String get navLearnTooltip => 'शैक्षणिक केंद्र - ISL श्रेणी';

  @override
  String get navChatTooltip => 'ISL चॅटबॉट सहाय्यक';

  @override
  String get homeCommunicate => 'संवाद साधा';

  @override
  String get homeFreely => 'मोकळेपणाने';

  @override
  String get homeSubtitle => 'भारतीय सांकेतिक भाषा सोपी केली';

  @override
  String get homeStartDetection => 'सांकेतिक ओळख सुरू करा';

  @override
  String get homeStartDetectionHint => 'सुरू करण्यासाठी कॅमेरा हातांकडे वळवा';

  @override
  String get homeStartDetectionLabel => 'सांकेतिक ओळख सुरू करा. कॅमेरा उघडण्यासाठी आणि चिन्हे ओळखण्यास प्रारंभ करण्यासाठी टॅप करा.';

  @override
  String get homeQuickAccess => 'त्वरित प्रवेश';

  @override
  String get homePracticeMode => 'सराव मोड';

  @override
  String get homeRecentSigns => 'अलीकडील चिन्हे';

  @override
  String get homeTipTitle => 'आजचा सल्ला';

  @override
  String get homeTipBody => '\"हॅलो\" चिन्हाचा सराव करा: उघडलेली तळहात बाजूला हलवा.';

  @override
  String get eduHubTitle => 'शैक्षणिक केंद्र';

  @override
  String eduHubCategoriesToExplore(int count) {
    return '$count श्रेण्या अन्वेषणासाठी';
  }

  @override
  String get eduHubInteractiveLearning => 'परस्परसंवादी शिक्षण';

  @override
  String get eduHubLearnWith3D => '3D अवतारासह शिका';

  @override
  String get eduHubAvatarDesc => 'प्रत्येक ISL चिन्ह पूर्ण 3D मध्ये दाखवणारा अॅनिमेटेड अवतार पहा. कॅमेरा फिरवा, प्लेबॅक गती समायोजित करा आणि आपल्या गतीने चिन्हे अन्वेषण करा.';

  @override
  String get eduHubOpen3DViewer => '3D दर्शक उघडा';

  @override
  String get eduHubSignCategories => 'चिन्ह श्रेण्या';

  @override
  String eduHubTopicsCount(int count) {
    return '$count विषय';
  }

  @override
  String get eduHubAvatarSemantics => 'परस्परसंवादी 3D अवतारासह भारतीय सांकेतिक भाषा शिका. अन्वेषणासाठी टॅप करा.';

  @override
  String get categoryAlphabets => 'अक्षरे';

  @override
  String get categoryAlphabetsDesc => 'A ते Z हात चिन्हे';

  @override
  String get categoryNumbers => 'संख्या';

  @override
  String get categoryNumbersDesc => '० ते १०० चिन्हे';

  @override
  String get categoryDailyActions => 'दैनंदिन क्रिया';

  @override
  String get categoryDailyActionsDesc => 'खाणे, पिणे, जाणे आणि अधिक';

  @override
  String get categoryEmotions => 'भावना';

  @override
  String get categoryEmotionsDesc => 'आनंदी, दु:खी, रागावलेला...';

  @override
  String get categoryEmergency => 'आपत्कालीन';

  @override
  String get categoryEmergencyDesc => 'मदत, धोका, थांबा';

  @override
  String get categoryGreetings => 'शुभेच्छा';

  @override
  String get categoryGreetingsDesc => 'नमस्कार, धन्यवाद, अलविदा';

  @override
  String lessonComingSoonTitle(String title) {
    return '$title धडे';
  }

  @override
  String get lessonComingSoon => 'लवकरच येत आहे! धड्याची सामग्री\nइथे दिसेल.';

  @override
  String get lessonGoBack => 'परत जा';

  @override
  String get chatbotTitle => 'ISL मार्गदर्शक';

  @override
  String get chatbotStatus => 'माझ्याशी मजकूर किंवा चिन्हात विचारा';

  @override
  String get chatbotWelcome => 'नमस्ते! मी तुमचा ISL मार्गदर्शक आहे. कोणत्याही सामान्य, आरोग्य किंवा समर्थन प्रश्नांसाठी मला विचारा.';

  @override
  String get chatbotInputHint => 'काहीही विचारा…';

  @override
  String get chatbotCameraLabel => 'संकेत ओळखण्यासाठी कॅमेरा वापरा';

  @override
  String get chatbotSendLabel => 'संदेश पाठवा';

  @override
  String get chatbotLowConfidence => 'कमी आत्मविश्वासाची संकेत ओळख. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get chatbotDetectionFailed => 'संकेत ओळख अयशस्वी.';

  @override
  String get chatbotBackendError => 'बॅकएंड कनेक्शन त्रुटी.';

  @override
  String get recordTitle => 'संकेत रेकॉर्ड करा';

  @override
  String get recordGoBack => 'मागे जा';

  @override
  String get recordSwitchCamera => 'कॅमेरा बदला';

  @override
  String get recordPositionHint => '🤚  तुमचा हात फ्रेममध्ये ठेवा';

  @override
  String get recordStatusIdle => 'रेकॉर्डिंग सुरू करण्यासाठी टॅप करा';

  @override
  String get recordStatusRecording => 'तुमचा संकेत रेकॉर्ड करत आहे…';

  @override
  String get recordStartBtn => 'रेकॉर्डिंग सुरू करा';

  @override
  String get recordStopBtn => 'रेकॉर्डिंग थांबवा';

  @override
  String recordCameraUnavailable(String error) {
    return 'कॅमेरा उपलब्ध नाही: $error';
  }

  @override
  String get previewTitle => 'संकेत पूर्वावलोकन';

  @override
  String get previewRetake => 'पुन्हा घ्या';

  @override
  String get previewReplay => 'पुन्हा प्ले करा';

  @override
  String get previewHint => 'पाठवण्यापूर्वी तुमचा संकेत पुनरावलोकन करा';

  @override
  String get previewUpload => 'अपलोड करा आणि भाकीत करा';

  @override
  String get previewAnalysing => 'संकेत विश्लेषण करत आहे…';

  @override
  String get previewSendingToModel => 'ISL मॉडेलकडे पाठवत आहे';

  @override
  String previewPredictionFailed(String error) {
    return 'भाकीत अयशस्वी: $error';
  }

  @override
  String get resultTitle => 'शोध परिणाम';

  @override
  String get resultShare => 'परिणाम शेअर करा';

  @override
  String get resultBackToPreview => 'पूर्वावलोकनाकडे परत';

  @override
  String get resultSignDetected => 'संकेत यशस्वीरित्या शोधला';

  @override
  String get resultPredictedSign => 'भाकीत केलेला संकेत';

  @override
  String get resultConfidenceScore => 'विश्वास गुण';

  @override
  String resultAccurate(String pct) {
    return '$pct% अचूक';
  }

  @override
  String get resultHighConfidence => 'उच्च आत्मविश्वास';

  @override
  String get resultMediumConfidence => 'मध्यम आत्मविश्वास';

  @override
  String get resultLowConfidence => 'कमी आत्मविश्वास';

  @override
  String get resultRecordAgain => 'पुन्हा रेकॉर्ड करा';

  @override
  String get resultFeedbackTitle => 'GESPY सुधारण्यास मदत करा';

  @override
  String resultFeedbackQuestion(String label) {
    return '\"$label\" बरोबर होते का?';
  }

  @override
  String get resultFeedbackYes => 'होय, बरोबर!';

  @override
  String get resultFeedbackNo => 'नाही, चुकीचे';

  @override
  String get resultFeedbackWhatCorrect => 'योग्य चिन्ह काय होते?';

  @override
  String get resultFeedbackSelectHint => 'योग्य चिन्ह निवडा';

  @override
  String get resultFeedbackSubmit => 'सुधारणा सबमिट करा';

  @override
  String get resultFeedbackSubmitting => 'प्रतिसाद सबमिट करत आहे...';

  @override
  String get resultFeedbackThanks => 'पुष्टीसाठी धन्यवाद! 🎉';

  @override
  String get resultFeedbackError => 'सबमिट करू शकलो नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String categoryDetailProgress(int percent) {
    return '$percent%';
  }

  @override
  String get quizTitle => 'क्विझ';

  @override
  String get quizCompleted => 'क्विझ पूर्ण';

  @override
  String quizScore(int score, int total) {
    return 'तुमचा स्कोअर: $score / $total';
  }

  @override
  String get recentSignsTitle => 'अलीकडील चिन्हे';

  @override
  String get detectionScreenTitle => 'चिन्ह ओळख';

  @override
  String get detectionToggleFlash => 'फ्लॅशलाइट चालू/बंद करा';

  @override
  String get detectionSwitchCamera => 'कॅमेरा बदला';

  @override
  String get detectionPositionHand => 'तुमचा हात\nइथे ठेवा';

  @override
  String get detectionWaiting => 'चिन्हाची प्रतीक्षा…';

  @override
  String get detectionPlaceholderLabel => 'ओळखलेले चिन्ह इथे दिसेल';

  @override
  String get genericBackendPending => '🚧 बॅकएंड एकत्रीकरण प्रलंबित';
}
