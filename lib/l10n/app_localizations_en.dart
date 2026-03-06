// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get splashBranding => 'Indian Sign Language';

  @override
  String get navHome => 'Home';

  @override
  String get navLearn => 'Learn';

  @override
  String get navChat => 'Chat';

  @override
  String get navHomeTooltip => 'Sign Detection Home';

  @override
  String get navLearnTooltip => 'Educational Hub - ISL Categories';

  @override
  String get navChatTooltip => 'ISL Chatbot Assistant';

  @override
  String get homeCommunicate => 'Communicate';

  @override
  String get homeFreely => 'Freely';

  @override
  String get homeSubtitle => 'Indian Sign Language made simple';

  @override
  String get homeStartDetection => 'Start Sign Detection';

  @override
  String get homeStartDetectionHint => 'Point camera at hands to begin';

  @override
  String get homeStartDetectionLabel => 'Start Sign Detection. Tap to open camera and begin detecting signs.';

  @override
  String get homeQuickAccess => 'Quick Access';

  @override
  String get homePracticeMode => 'Practice Mode';

  @override
  String get homeRecentSigns => 'Recent Signs';

  @override
  String get homeTipTitle => 'Tip of the Day';

  @override
  String get homeTipBody => 'Practice \"Hello\" sign: wave open palm side to side.';

  @override
  String get eduHubTitle => 'Educational Hub';

  @override
  String eduHubCategoriesToExplore(int count) {
    return '$count categories to explore';
  }

  @override
  String get eduHubInteractiveLearning => 'INTERACTIVE LEARNING';

  @override
  String get eduHubLearnWith3D => 'Learn with 3D Avatar';

  @override
  String get eduHubAvatarDesc => 'Watch an animated avatar demonstrate every ISL sign in full 3D. Rotate the camera, adjust playback speed, and explore signs at your own pace.';

  @override
  String get eduHubOpen3DViewer => 'Open 3D Viewer';

  @override
  String get eduHubSignCategories => 'Sign Categories';

  @override
  String eduHubTopicsCount(int count) {
    return '$count topics';
  }

  @override
  String get eduHubAvatarSemantics => 'Learn Indian Sign Language with an interactive 3D avatar. Tap to explore.';

  @override
  String get categoryAlphabets => 'Alphabets';

  @override
  String get categoryAlphabetsDesc => 'A to Z hand signs';

  @override
  String get categoryNumbers => 'Numbers';

  @override
  String get categoryNumbersDesc => '0 to 100 signs';

  @override
  String get categoryDailyActions => 'Daily Actions';

  @override
  String get categoryDailyActionsDesc => 'Eat, drink, go & more';

  @override
  String get categoryEmotions => 'Emotions';

  @override
  String get categoryEmotionsDesc => 'Happy, sad, angry...';

  @override
  String get categoryEmergency => 'Emergency';

  @override
  String get categoryEmergencyDesc => 'Help, danger, stop';

  @override
  String get categoryGreetings => 'Greetings';

  @override
  String get categoryGreetingsDesc => 'Hello, thanks, bye';

  @override
  String lessonComingSoonTitle(String title) {
    return '$title Lessons';
  }

  @override
  String get lessonComingSoon => 'Coming soon! Lesson content\nwill appear here.';

  @override
  String get lessonGoBack => 'Go back';

  @override
  String get chatbotTitle => 'ISL Guide';

  @override
  String get chatbotStatus => 'Ask me in text or sign';

  @override
  String get chatbotWelcome => 'Namaste! I\'m your ISL guide. Ask me about any general, healthcare or support queries.';

  @override
  String get chatbotInputHint => 'Ask anything…';

  @override
  String get chatbotCameraLabel => 'Use camera to detect sign';

  @override
  String get chatbotSendLabel => 'Send message';

  @override
  String get chatbotLowConfidence => 'Low confidence sign detection. Please try again.';

  @override
  String get chatbotDetectionFailed => 'Sign detection failed.';

  @override
  String get chatbotBackendError => 'Backend connection error.';

  @override
  String get recordTitle => 'Record Sign';

  @override
  String get recordGoBack => 'Go back';

  @override
  String get recordSwitchCamera => 'Switch camera';

  @override
  String get recordPositionHint => '🤚  Position your hand in frame';

  @override
  String get recordStatusIdle => 'Tap to start recording';

  @override
  String get recordStatusRecording => 'Recording your sign…';

  @override
  String get recordStartBtn => 'Start Recording';

  @override
  String get recordStopBtn => 'Stop Recording';

  @override
  String recordCameraUnavailable(String error) {
    return 'Camera unavailable: $error';
  }

  @override
  String get previewTitle => 'Preview Sign';

  @override
  String get previewRetake => 'Retake';

  @override
  String get previewReplay => 'Replay';

  @override
  String get previewHint => 'Review your sign before sending';

  @override
  String get previewUpload => 'Upload & Predict';

  @override
  String get previewAnalysing => 'Analysing Sign…';

  @override
  String get previewSendingToModel => 'Sending to ISL model';

  @override
  String previewPredictionFailed(String error) {
    return 'Prediction failed: $error';
  }

  @override
  String get resultTitle => 'Detection Result';

  @override
  String get resultShare => 'Share result';

  @override
  String get resultBackToPreview => 'Back to preview';

  @override
  String get resultSignDetected => 'Sign Successfully Detected';

  @override
  String get resultPredictedSign => 'Predicted Sign';

  @override
  String get resultConfidenceScore => 'Confidence Score';

  @override
  String resultAccurate(String pct) {
    return '$pct% accurate';
  }

  @override
  String get resultHighConfidence => 'High confidence';

  @override
  String get resultMediumConfidence => 'Medium confidence';

  @override
  String get resultLowConfidence => 'Low confidence';

  @override
  String get resultRecordAgain => 'Record Again';

  @override
  String get resultFeedbackTitle => 'Help Improve GESPY';

  @override
  String resultFeedbackQuestion(String label) {
    return 'Was \"$label\" correct?';
  }

  @override
  String get resultFeedbackYes => 'Yes, correct!';

  @override
  String get resultFeedbackNo => 'No, wrong';

  @override
  String get resultFeedbackWhatCorrect => 'What was the correct sign?';

  @override
  String get resultFeedbackSelectHint => 'Select the correct sign';

  @override
  String get resultFeedbackSubmit => 'Submit Correction';

  @override
  String get resultFeedbackSubmitting => 'Submitting feedback...';

  @override
  String get resultFeedbackThanks => 'Thanks for confirming! 🎉';

  @override
  String get resultFeedbackError => 'Could not submit. Please try again.';

  @override
  String categoryDetailProgress(int percent) {
    return '$percent%';
  }

  @override
  String get quizTitle => 'Quiz';

  @override
  String get quizCompleted => 'Quiz Completed';

  @override
  String quizScore(int score, int total) {
    return 'Your score: $score / $total';
  }

  @override
  String get recentSignsTitle => 'Recent Signs';

  @override
  String get detectionScreenTitle => 'Sign Detection';

  @override
  String get detectionToggleFlash => 'Toggle flashlight';

  @override
  String get detectionSwitchCamera => 'Switch camera';

  @override
  String get detectionPositionHand => 'Position your hand\nhere';

  @override
  String get detectionWaiting => 'Waiting for sign…';

  @override
  String get detectionPlaceholderLabel => 'Detected sign appears here';

  @override
  String get genericBackendPending => '🚧 Backend integration pending';
}
