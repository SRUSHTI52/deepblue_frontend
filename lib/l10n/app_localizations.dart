import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
    Locale('mr')
  ];

  /// No description provided for @splashBranding.
  ///
  /// In en, this message translates to:
  /// **'Indian Sign Language'**
  String get splashBranding;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navHomeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sign Detection Home'**
  String get navHomeTooltip;

  /// No description provided for @navLearnTooltip.
  ///
  /// In en, this message translates to:
  /// **'Educational Hub - ISL Categories'**
  String get navLearnTooltip;

  /// No description provided for @navChatTooltip.
  ///
  /// In en, this message translates to:
  /// **'ISL Chatbot Assistant'**
  String get navChatTooltip;

  /// No description provided for @homeCommunicate.
  ///
  /// In en, this message translates to:
  /// **'Communicate'**
  String get homeCommunicate;

  /// No description provided for @homeFreely.
  ///
  /// In en, this message translates to:
  /// **'Freely'**
  String get homeFreely;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Indian Sign Language made simple'**
  String get homeSubtitle;

  /// No description provided for @homeStartDetection.
  ///
  /// In en, this message translates to:
  /// **'Start Sign Detection'**
  String get homeStartDetection;

  /// No description provided for @homeStartDetectionHint.
  ///
  /// In en, this message translates to:
  /// **'Point camera at hands to begin'**
  String get homeStartDetectionHint;

  /// No description provided for @homeStartDetectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Sign Detection. Tap to open camera and begin detecting signs.'**
  String get homeStartDetectionLabel;

  /// No description provided for @homeQuickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get homeQuickAccess;

  /// No description provided for @homePracticeMode.
  ///
  /// In en, this message translates to:
  /// **'Practice Mode'**
  String get homePracticeMode;

  /// No description provided for @homeRecentSigns.
  ///
  /// In en, this message translates to:
  /// **'Recent Signs'**
  String get homeRecentSigns;

  /// No description provided for @homeTipTitle.
  ///
  /// In en, this message translates to:
  /// **'Tip of the Day'**
  String get homeTipTitle;

  /// No description provided for @homeTipBody.
  ///
  /// In en, this message translates to:
  /// **'Practice \"Hello\" sign: wave open palm side to side.'**
  String get homeTipBody;

  /// No description provided for @eduHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Educational Hub'**
  String get eduHubTitle;

  /// No description provided for @eduHubCategoriesToExplore.
  ///
  /// In en, this message translates to:
  /// **'{count} categories to explore'**
  String eduHubCategoriesToExplore(int count);

  /// No description provided for @eduHubInteractiveLearning.
  ///
  /// In en, this message translates to:
  /// **'INTERACTIVE LEARNING'**
  String get eduHubInteractiveLearning;

  /// No description provided for @eduHubLearnWith3D.
  ///
  /// In en, this message translates to:
  /// **'Learn with 3D Avatar'**
  String get eduHubLearnWith3D;

  /// No description provided for @eduHubAvatarDesc.
  ///
  /// In en, this message translates to:
  /// **'Watch an animated avatar demonstrate every ISL sign in full 3D. Rotate the camera, adjust playback speed, and explore signs at your own pace.'**
  String get eduHubAvatarDesc;

  /// No description provided for @eduHubOpen3DViewer.
  ///
  /// In en, this message translates to:
  /// **'Open 3D Viewer'**
  String get eduHubOpen3DViewer;

  /// No description provided for @eduHubSignCategories.
  ///
  /// In en, this message translates to:
  /// **'Sign Categories'**
  String get eduHubSignCategories;

  /// No description provided for @eduHubTopicsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} topics'**
  String eduHubTopicsCount(int count);

  /// No description provided for @eduHubAvatarSemantics.
  ///
  /// In en, this message translates to:
  /// **'Learn Indian Sign Language with an interactive 3D avatar. Tap to explore.'**
  String get eduHubAvatarSemantics;

  /// No description provided for @categoryAlphabets.
  ///
  /// In en, this message translates to:
  /// **'Alphabets'**
  String get categoryAlphabets;

  /// No description provided for @categoryAlphabetsDesc.
  ///
  /// In en, this message translates to:
  /// **'A to Z hand signs'**
  String get categoryAlphabetsDesc;

  /// No description provided for @categoryNumbers.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get categoryNumbers;

  /// No description provided for @categoryNumbersDesc.
  ///
  /// In en, this message translates to:
  /// **'0 to 100 signs'**
  String get categoryNumbersDesc;

  /// No description provided for @categoryDailyActions.
  ///
  /// In en, this message translates to:
  /// **'Daily Actions'**
  String get categoryDailyActions;

  /// No description provided for @categoryDailyActionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Eat, drink, go & more'**
  String get categoryDailyActionsDesc;

  /// No description provided for @categoryEmotions.
  ///
  /// In en, this message translates to:
  /// **'Emotions'**
  String get categoryEmotions;

  /// No description provided for @categoryEmotionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Happy, sad, angry...'**
  String get categoryEmotionsDesc;

  /// No description provided for @categoryEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get categoryEmergency;

  /// No description provided for @categoryEmergencyDesc.
  ///
  /// In en, this message translates to:
  /// **'Help, danger, stop'**
  String get categoryEmergencyDesc;

  /// No description provided for @categoryGreetings.
  ///
  /// In en, this message translates to:
  /// **'Greetings'**
  String get categoryGreetings;

  /// No description provided for @categoryGreetingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Hello, thanks, bye'**
  String get categoryGreetingsDesc;

  /// No description provided for @lessonComingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} Lessons'**
  String lessonComingSoonTitle(String title);

  /// No description provided for @lessonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon! Lesson content\nwill appear here.'**
  String get lessonComingSoon;

  /// No description provided for @lessonGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get lessonGoBack;

  /// No description provided for @chatbotTitle.
  ///
  /// In en, this message translates to:
  /// **'ISL Guide'**
  String get chatbotTitle;

  /// No description provided for @chatbotStatus.
  ///
  /// In en, this message translates to:
  /// **'Ask me in text or sign'**
  String get chatbotStatus;

  /// No description provided for @chatbotWelcome.
  ///
  /// In en, this message translates to:
  /// **'Namaste! I\'m your ISL guide. Ask me about any general, healthcare or support queries.'**
  String get chatbotWelcome;

  /// No description provided for @chatbotInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask anything…'**
  String get chatbotInputHint;

  /// No description provided for @chatbotCameraLabel.
  ///
  /// In en, this message translates to:
  /// **'Use camera to detect sign'**
  String get chatbotCameraLabel;

  /// No description provided for @chatbotSendLabel.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get chatbotSendLabel;

  /// No description provided for @chatbotLowConfidence.
  ///
  /// In en, this message translates to:
  /// **'Low confidence sign detection. Please try again.'**
  String get chatbotLowConfidence;

  /// No description provided for @chatbotDetectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign detection failed.'**
  String get chatbotDetectionFailed;

  /// No description provided for @chatbotBackendError.
  ///
  /// In en, this message translates to:
  /// **'Backend connection error.'**
  String get chatbotBackendError;

  /// No description provided for @recordTitle.
  ///
  /// In en, this message translates to:
  /// **'Record Sign'**
  String get recordTitle;

  /// No description provided for @recordGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get recordGoBack;

  /// No description provided for @recordSwitchCamera.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get recordSwitchCamera;

  /// No description provided for @recordPositionHint.
  ///
  /// In en, this message translates to:
  /// **'🤚  Position your hand in frame'**
  String get recordPositionHint;

  /// No description provided for @recordStatusIdle.
  ///
  /// In en, this message translates to:
  /// **'Tap to start recording'**
  String get recordStatusIdle;

  /// No description provided for @recordStatusRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording your sign…'**
  String get recordStatusRecording;

  /// No description provided for @recordStartBtn.
  ///
  /// In en, this message translates to:
  /// **'Start Recording'**
  String get recordStartBtn;

  /// No description provided for @recordStopBtn.
  ///
  /// In en, this message translates to:
  /// **'Stop Recording'**
  String get recordStopBtn;

  /// No description provided for @recordCameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable: {error}'**
  String recordCameraUnavailable(String error);

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview Sign'**
  String get previewTitle;

  /// No description provided for @previewRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get previewRetake;

  /// No description provided for @previewReplay.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get previewReplay;

  /// No description provided for @previewHint.
  ///
  /// In en, this message translates to:
  /// **'Review your sign before sending'**
  String get previewHint;

  /// No description provided for @previewUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload & Predict'**
  String get previewUpload;

  /// No description provided for @previewAnalysing.
  ///
  /// In en, this message translates to:
  /// **'Analysing Sign…'**
  String get previewAnalysing;

  /// No description provided for @previewSendingToModel.
  ///
  /// In en, this message translates to:
  /// **'Sending to ISL model'**
  String get previewSendingToModel;

  /// No description provided for @previewPredictionFailed.
  ///
  /// In en, this message translates to:
  /// **'Prediction failed: {error}'**
  String previewPredictionFailed(String error);

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Detection Result'**
  String get resultTitle;

  /// No description provided for @resultShare.
  ///
  /// In en, this message translates to:
  /// **'Share result'**
  String get resultShare;

  /// No description provided for @resultBackToPreview.
  ///
  /// In en, this message translates to:
  /// **'Back to preview'**
  String get resultBackToPreview;

  /// No description provided for @resultSignDetected.
  ///
  /// In en, this message translates to:
  /// **'Sign Successfully Detected'**
  String get resultSignDetected;

  /// No description provided for @resultPredictedSign.
  ///
  /// In en, this message translates to:
  /// **'Predicted Sign'**
  String get resultPredictedSign;

  /// No description provided for @resultConfidenceScore.
  ///
  /// In en, this message translates to:
  /// **'Confidence Score'**
  String get resultConfidenceScore;

  /// No description provided for @resultAccurate.
  ///
  /// In en, this message translates to:
  /// **'{pct}% accurate'**
  String resultAccurate(String pct);

  /// No description provided for @resultHighConfidence.
  ///
  /// In en, this message translates to:
  /// **'High confidence'**
  String get resultHighConfidence;

  /// No description provided for @resultMediumConfidence.
  ///
  /// In en, this message translates to:
  /// **'Medium confidence'**
  String get resultMediumConfidence;

  /// No description provided for @resultLowConfidence.
  ///
  /// In en, this message translates to:
  /// **'Low confidence'**
  String get resultLowConfidence;

  /// No description provided for @resultRecordAgain.
  ///
  /// In en, this message translates to:
  /// **'Record Again'**
  String get resultRecordAgain;

  /// No description provided for @resultFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Help Improve GESPY'**
  String get resultFeedbackTitle;

  /// No description provided for @resultFeedbackQuestion.
  ///
  /// In en, this message translates to:
  /// **'Was \"{label}\" correct?'**
  String resultFeedbackQuestion(String label);

  /// No description provided for @resultFeedbackYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, correct!'**
  String get resultFeedbackYes;

  /// No description provided for @resultFeedbackNo.
  ///
  /// In en, this message translates to:
  /// **'No, wrong'**
  String get resultFeedbackNo;

  /// No description provided for @resultFeedbackWhatCorrect.
  ///
  /// In en, this message translates to:
  /// **'What was the correct sign?'**
  String get resultFeedbackWhatCorrect;

  /// No description provided for @resultFeedbackSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Select the correct sign'**
  String get resultFeedbackSelectHint;

  /// No description provided for @resultFeedbackSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Correction'**
  String get resultFeedbackSubmit;

  /// No description provided for @resultFeedbackSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting feedback...'**
  String get resultFeedbackSubmitting;

  /// No description provided for @resultFeedbackThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for confirming! 🎉'**
  String get resultFeedbackThanks;

  /// No description provided for @resultFeedbackError.
  ///
  /// In en, this message translates to:
  /// **'Could not submit. Please try again.'**
  String get resultFeedbackError;

  /// No description provided for @categoryDetailProgress.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String categoryDetailProgress(int percent);

  /// No description provided for @quizTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quizTitle;

  /// No description provided for @quizCompleted.
  ///
  /// In en, this message translates to:
  /// **'Quiz Completed'**
  String get quizCompleted;

  /// No description provided for @quizScore.
  ///
  /// In en, this message translates to:
  /// **'Your score: {score} / {total}'**
  String quizScore(int score, int total);

  /// No description provided for @recentSignsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Signs'**
  String get recentSignsTitle;

  /// No description provided for @detectionScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Detection'**
  String get detectionScreenTitle;

  /// No description provided for @detectionToggleFlash.
  ///
  /// In en, this message translates to:
  /// **'Toggle flashlight'**
  String get detectionToggleFlash;

  /// No description provided for @detectionSwitchCamera.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get detectionSwitchCamera;

  /// No description provided for @detectionPositionHand.
  ///
  /// In en, this message translates to:
  /// **'Position your hand\nhere'**
  String get detectionPositionHand;

  /// No description provided for @detectionWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for sign…'**
  String get detectionWaiting;

  /// No description provided for @detectionPlaceholderLabel.
  ///
  /// In en, this message translates to:
  /// **'Detected sign appears here'**
  String get detectionPlaceholderLabel;

  /// No description provided for @genericBackendPending.
  ///
  /// In en, this message translates to:
  /// **'🚧 Backend integration pending'**
  String get genericBackendPending;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bn', 'en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'mr': return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
