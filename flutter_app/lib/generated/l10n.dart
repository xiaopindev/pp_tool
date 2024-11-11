// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Continue`
  String get Continue {
    return Intl.message(
      'Continue',
      name: 'Continue',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get Edit {
    return Intl.message(
      'Edit',
      name: 'Edit',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get Done {
    return Intl.message(
      'Done',
      name: 'Done',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get Delete {
    return Intl.message(
      'Delete',
      name: 'Delete',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get Save {
    return Intl.message(
      'Save',
      name: 'Save',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get Send {
    return Intl.message(
      'Send',
      name: 'Send',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get Favorites {
    return Intl.message(
      'Favorites',
      name: 'Favorites',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get Submit {
    return Intl.message(
      'Submit',
      name: 'Submit',
      desc: '',
      args: [],
    );
  }

  /// `Install`
  String get Install {
    return Intl.message(
      'Install',
      name: 'Install',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get Preview {
    return Intl.message(
      'Preview',
      name: 'Preview',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get Download {
    return Intl.message(
      'Download',
      name: 'Download',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get Share {
    return Intl.message(
      'Share',
      name: 'Share',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get Upload {
    return Intl.message(
      'Upload',
      name: 'Upload',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get Feedback {
    return Intl.message(
      'Feedback',
      name: 'Feedback',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message(
      'Settings',
      name: 'Settings',
      desc: '',
      args: [],
    );
  }

  /// `Unlock`
  String get Unlock {
    return Intl.message(
      'Unlock',
      name: 'Unlock',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get Success {
    return Intl.message(
      'Success',
      name: 'Success',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get Failed {
    return Intl.message(
      'Failed',
      name: 'Failed',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get Add {
    return Intl.message(
      'Add',
      name: 'Add',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get OK {
    return Intl.message(
      'OK',
      name: 'OK',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get NO {
    return Intl.message(
      'No',
      name: 'NO',
      desc: '',
      args: [],
    );
  }

  /// `Copied`
  String get Copied {
    return Intl.message(
      'Copied',
      name: 'Copied',
      desc: '',
      args: [],
    );
  }

  /// `Options`
  String get Options {
    return Intl.message(
      'Options',
      name: 'Options',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message(
      'Cancel',
      name: 'Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get Finish {
    return Intl.message(
      'Finish',
      name: 'Finish',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get NextStep {
    return Intl.message(
      'Next',
      name: 'NextStep',
      desc: '',
      args: [],
    );
  }

  /// `Refuse`
  String get Refuse {
    return Intl.message(
      'Refuse',
      name: 'Refuse',
      desc: '',
      args: [],
    );
  }

  /// `Reload`
  String get Reload {
    return Intl.message(
      'Reload',
      name: 'Reload',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get Reply {
    return Intl.message(
      'Reply',
      name: 'Reply',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get More {
    return Intl.message(
      'More',
      name: 'More',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get All {
    return Intl.message(
      'All',
      name: 'All',
      desc: '',
      args: [],
    );
  }

  /// `Tips`
  String get Tips {
    return Intl.message(
      'Tips',
      name: 'Tips',
      desc: '',
      args: [],
    );
  }

  /// `Backup`
  String get Backup {
    return Intl.message(
      'Backup',
      name: 'Backup',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get Restore {
    return Intl.message(
      'Restore',
      name: 'Restore',
      desc: '',
      args: [],
    );
  }

  /// `Pick image`
  String get PickImage {
    return Intl.message(
      'Pick image',
      name: 'PickImage',
      desc: '',
      args: [],
    );
  }

  /// `Cropper`
  String get Cropper {
    return Intl.message(
      'Cropper',
      name: 'Cropper',
      desc: '',
      args: [],
    );
  }

  /// `Waiting`
  String get Waiting {
    return Intl.message(
      'Waiting',
      name: 'Waiting',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get Search {
    return Intl.message(
      'Search',
      name: 'Search',
      desc: '',
      args: [],
    );
  }

  /// `No data available~`
  String get NoData {
    return Intl.message(
      'No data available~',
      name: 'NoData',
      desc: '',
      args: [],
    );
  }

  /// `No favorite content~`
  String get NoFavorites {
    return Intl.message(
      'No favorite content~',
      name: 'NoFavorites',
      desc: '',
      args: [],
    );
  }

  /// `No network was detected~`
  String get NoNetwork {
    return Intl.message(
      'No network was detected~',
      name: 'NoNetwork',
      desc: '',
      args: [],
    );
  }

  /// `No related content searched~`
  String get NoSearchResult {
    return Intl.message(
      'No related content searched~',
      name: 'NoSearchResult',
      desc: '',
      args: [],
    );
  }

  /// `Not yet clear`
  String get NotYetClear {
    return Intl.message(
      'Not yet clear',
      name: 'NotYetClear',
      desc: '',
      args: [],
    );
  }

  /// `Pull down to refresh`
  String get Refresh_Idle {
    return Intl.message(
      'Pull down to refresh',
      name: 'Refresh_Idle',
      desc: '',
      args: [],
    );
  }

  /// `Loaded`
  String get Refresh_LoadCompleted {
    return Intl.message(
      'Loaded',
      name: 'Refresh_LoadCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get Refresh_Loading {
    return Intl.message(
      'Loading',
      name: 'Refresh_Loading',
      desc: '',
      args: [],
    );
  }

  /// `All data loaded`
  String get Refresh_NoMoreData {
    return Intl.message(
      'All data loaded',
      name: 'Refresh_NoMoreData',
      desc: '',
      args: [],
    );
  }

  /// `Release to refresh`
  String get Refresh_Pulling {
    return Intl.message(
      'Release to refresh',
      name: 'Refresh_Pulling',
      desc: '',
      args: [],
    );
  }

  /// `Pull up to load more`
  String get Refresh_Pullup {
    return Intl.message(
      'Pull up to load more',
      name: 'Refresh_Pullup',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing`
  String get Refresh_Refreshing {
    return Intl.message(
      'Refreshing',
      name: 'Refresh_Refreshing',
      desc: '',
      args: [],
    );
  }

  /// `Request timeout`
  String get LoadingTimeoutTitle {
    return Intl.message(
      'Request timeout',
      name: 'LoadingTimeoutTitle',
      desc: '',
      args: [],
    );
  }

  /// `Request timeout, please try again later!`
  String get LoadingTimeout {
    return Intl.message(
      'Request timeout, please try again later!',
      name: 'LoadingTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Network unavailable detected. Check whether the network Settings of the device are available. If your device requires authorization, allow authorization to access the network.`
  String get Network_Lost {
    return Intl.message(
      'Network unavailable detected. Check whether the network Settings of the device are available. If your device requires authorization, allow authorization to access the network.',
      name: 'Network_Lost',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'Network settings' key

  /// `Network is not available`
  String get NetworkNotAvailable {
    return Intl.message(
      'Network is not available',
      name: 'NetworkNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `I have read and agree to the`
  String get Privacy_Agree {
    return Intl.message(
      'I have read and agree to the',
      name: 'Privacy_Agree',
      desc: '',
      args: [],
    );
  }

  /// `[n] and [m]`
  String get Privacy_Text {
    return Intl.message(
      '[n] and [m]',
      name: 'Privacy_Text',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get Privacy_Text1 {
    return Intl.message(
      'Privacy Policy',
      name: 'Privacy_Text1',
      desc: '',
      args: [],
    );
  }

  /// `User Agreement`
  String get Privacy_Text2 {
    return Intl.message(
      'User Agreement',
      name: 'Privacy_Text2',
      desc: '',
      args: [],
    );
  }

  /// `Please read the agreement and agree to it before proceeding!`
  String get Privacy_UnagreeAlert {
    return Intl.message(
      'Please read the agreement and agree to it before proceeding!',
      name: 'Privacy_UnagreeAlert',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your feedback`
  String get Feedback_PlaceHolder {
    return Intl.message(
      'Please enter your feedback',
      name: 'Feedback_PlaceHolder',
      desc: '',
      args: [],
    );
  }

  /// `We've updated our app with new features! Please update it.🥳🥳🥳`
  String get NewVer_Text {
    return Intl.message(
      'We\'ve updated our app with new features! Please update it.🥳🥳🥳',
      name: 'NewVer_Text',
      desc: '',
      args: [],
    );
  }

  /// `Go to App Store`
  String get NewVer_BtnText1 {
    return Intl.message(
      'Go to App Store',
      name: 'NewVer_BtnText1',
      desc: '',
      args: [],
    );
  }

  /// `Later`
  String get NewVer_BtnText2 {
    return Intl.message(
      'Later',
      name: 'NewVer_BtnText2',
      desc: '',
      args: [],
    );
  }

  /// `Rate`
  String get AppReview_Title {
    return Intl.message(
      'Rate',
      name: 'AppReview_Title',
      desc: '',
      args: [],
    );
  }

  /// `Yes, I like it`
  String get AppReview_Yes {
    return Intl.message(
      'Yes, I like it',
      name: 'AppReview_Yes',
      desc: '',
      args: [],
    );
  }

  /// `Later`
  String get AppReview_Later {
    return Intl.message(
      'Later',
      name: 'AppReview_Later',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get AppReview_BtnText1 {
    return Intl.message(
      'Feedback',
      name: 'AppReview_BtnText1',
      desc: '',
      args: [],
    );
  }

  /// `Rate on App Store`
  String get AppReview_BtnText2 {
    return Intl.message(
      'Rate on App Store',
      name: 'AppReview_BtnText2',
      desc: '',
      args: [],
    );
  }

  /// `We strive to provide the best user experience. If you like this app, please give us a five-star rating😘😘😘`
  String get AppReview_Text {
    return Intl.message(
      'We strive to provide the best user experience. If you like this app, please give us a five-star rating😘😘😘',
      name: 'AppReview_Text',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for your support, we will try to make the application better!`
  String get AppReview_Text2 {
    return Intl.message(
      'Thank you for your support, we will try to make the application better!',
      name: 'AppReview_Text2',
      desc: '',
      args: [],
    );
  }

  /// `Delete confirm`
  String get Delete_confirm_title {
    return Intl.message(
      'Delete confirm',
      name: 'Delete_confirm_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to do this?`
  String get Delete_confirm_message {
    return Intl.message(
      'Are you sure you want to do this?',
      name: 'Delete_confirm_message',
      desc: '',
      args: [],
    );
  }

  /// `File source`
  String get Tips_title_file_source {
    return Intl.message(
      'File source',
      name: 'Tips_title_file_source',
      desc: '',
      args: [],
    );
  }

  /// `Albums`
  String get Tips_file_source_albums {
    return Intl.message(
      'Albums',
      name: 'Tips_file_source_albums',
      desc: '',
      args: [],
    );
  }

  /// `Documents`
  String get Tips_file_source_document {
    return Intl.message(
      'Documents',
      name: 'Tips_file_source_document',
      desc: '',
      args: [],
    );
  }

  /// `Follow System`
  String get Follow_System {
    return Intl.message(
      'Follow System',
      name: 'Follow_System',
      desc: '',
      args: [],
    );
  }

  /// `An amazing music player`
  String get Guides_1 {
    return Intl.message(
      'An amazing music player',
      name: 'Guides_1',
      desc: '',
      args: [],
    );
  }

  /// `Supports multiple formats, music freely chosen!`
  String get Guides_1_text {
    return Intl.message(
      'Supports multiple formats, music freely chosen!',
      name: 'Guides_1_text',
      desc: '',
      args: [],
    );
  }

  /// `Powerful Playlists`
  String get Guides_2 {
    return Intl.message(
      'Powerful Playlists',
      name: 'Guides_2',
      desc: '',
      args: [],
    );
  }

  /// `Create on demand, craft your own music world!`
  String get Guides_2_text {
    return Intl.message(
      'Create on demand, craft your own music world!',
      name: 'Guides_2_text',
      desc: '',
      args: [],
    );
  }

  /// `Get All Permissions`
  String get Guides_3 {
    return Intl.message(
      'Get All Permissions',
      name: 'Guides_3',
      desc: '',
      args: [],
    );
  }

  /// `Free trial for 3 days, then [pWeek]/ week, cancel anytime.`
  String get Guides_3_text_free {
    return Intl.message(
      'Free trial for 3 days, then [pWeek]/ week, cancel anytime.',
      name: 'Guides_3_text_free',
      desc: '',
      args: [],
    );
  }

  /// `Weekly subscription, [pWeek] per week, cancel anytime`
  String get Guides_3_text {
    return Intl.message(
      'Weekly subscription, [pWeek] per week, cancel anytime',
      name: 'Guides_3_text',
      desc: '',
      args: [],
    );
  }

  /// `Free trial Pro version`
  String get Guides_AlertTitle {
    return Intl.message(
      'Free trial Pro version',
      name: 'Guides_AlertTitle',
      desc: '',
      args: [],
    );
  }

  /// `Get your 3-day free trial now. No payment required, cancel anytime!`
  String get Guides_AlertText {
    return Intl.message(
      'Get your 3-day free trial now. No payment required, cancel anytime!',
      name: 'Guides_AlertText',
      desc: '',
      args: [],
    );
  }

  /// `Free trial`
  String get Subscribe_FreeTrail {
    return Intl.message(
      'Free trial',
      name: 'Subscribe_FreeTrail',
      desc: '',
      args: [],
    );
  }

  /// `VIP Privileges`
  String get Subscribe_Title {
    return Intl.message(
      'VIP Privileges',
      name: 'Subscribe_Title',
      desc: '',
      args: [],
    );
  }

  /// `Unlock the equalizer and reverb`
  String get Subscribe_Desc1 {
    return Intl.message(
      'Unlock the equalizer and reverb',
      name: 'Subscribe_Desc1',
      desc: '',
      args: [],
    );
  }

  /// `Create unlimited playlists`
  String get Subscribe_Desc2 {
    return Intl.message(
      'Create unlimited playlists',
      name: 'Subscribe_Desc2',
      desc: '',
      args: [],
    );
  }

  /// `Unlock backup and restore data`
  String get Subscribe_Desc3 {
    return Intl.message(
      'Unlock backup and restore data',
      name: 'Subscribe_Desc3',
      desc: '',
      args: [],
    );
  }

  /// `Unlock driving mode`
  String get Subscribe_Desc4 {
    return Intl.message(
      'Unlock driving mode',
      name: 'Subscribe_Desc4',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited audio extraction`
  String get Subscribe_Desc5 {
    return Intl.message(
      'Unlimited audio extraction',
      name: 'Subscribe_Desc5',
      desc: '',
      args: [],
    );
  }

  /// `Personalized functions`
  String get Subscribe_Desc6 {
    return Intl.message(
      'Personalized functions',
      name: 'Subscribe_Desc6',
      desc: '',
      args: [],
    );
  }

  /// `Speed up playback`
  String get Subscribe_Desc7 {
    return Intl.message(
      'Speed up playback',
      name: 'Subscribe_Desc7',
      desc: '',
      args: [],
    );
  }

  /// `VIP customer service`
  String get Subscribe_Desc8 {
    return Intl.message(
      'VIP customer service',
      name: 'Subscribe_Desc8',
      desc: '',
      args: [],
    );
  }

  /// `Remove ads`
  String get Subscribe_Desc9 {
    return Intl.message(
      'Remove ads',
      name: 'Subscribe_Desc9',
      desc: '',
      args: [],
    );
  }

  /// `Try free for 3 days`
  String get Subscribe_Tips {
    return Intl.message(
      'Try free for 3 days',
      name: 'Subscribe_Tips',
      desc: '',
      args: [],
    );
  }

  /// `Annual\n[pYear] per year`
  String get Subscribe_Product1 {
    return Intl.message(
      'Annual\n[pYear] per year',
      name: 'Subscribe_Product1',
      desc: '',
      args: [],
    );
  }

  /// `Weekly\n3-day free trial, Then [pWeek]/week`
  String get Subscribe_Product2_free {
    return Intl.message(
      'Weekly\n3-day free trial, Then [pWeek]/week',
      name: 'Subscribe_Product2_free',
      desc: '',
      args: [],
    );
  }

  /// `Weekly\n[pWeek] per week`
  String get Subscribe_Product2 {
    return Intl.message(
      'Weekly\n[pWeek] per week',
      name: 'Subscribe_Product2',
      desc: '',
      args: [],
    );
  }

  /// `No payment now`
  String get Subscribe_Status_Nopay {
    return Intl.message(
      'No payment now',
      name: 'Subscribe_Status_Nopay',
      desc: '',
      args: [],
    );
  }

  /// `Cancel anytime`
  String get Subscribe_Year_Tip {
    return Intl.message(
      'Cancel anytime',
      name: 'Subscribe_Year_Tip',
      desc: '',
      args: [],
    );
  }

  /// `START FOR FREE`
  String get Subscribe_Start {
    return Intl.message(
      'START FOR FREE',
      name: 'Subscribe_Start',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get Subscribe_Restore {
    return Intl.message(
      'Restore',
      name: 'Subscribe_Restore',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Subscription`
  String get Subscribe_Cancel {
    return Intl.message(
      'Cancel Subscription',
      name: 'Subscribe_Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Purchasing`
  String get IAP_Purchaseing {
    return Intl.message(
      'Purchasing',
      name: 'IAP_Purchaseing',
      desc: '',
      args: [],
    );
  }

  /// `Restoring`
  String get IAP_Restoring {
    return Intl.message(
      'Restoring',
      name: 'IAP_Restoring',
      desc: '',
      args: [],
    );
  }

  /// `Purchase failed, try to fix the exception?`
  String get IAP_PurchaseCrashTitle {
    return Intl.message(
      'Purchase failed, try to fix the exception?',
      name: 'IAP_PurchaseCrashTitle',
      desc: '',
      args: [],
    );
  }

  /// `Trying to fix the exception, restart the application after completion.`
  String get IAP_PurchaseCrashMsg {
    return Intl.message(
      'Trying to fix the exception, restart the application after completion.',
      name: 'IAP_PurchaseCrashMsg',
      desc: '',
      args: [],
    );
  }

  /// `Purchase failed`
  String get IAP_PurchaseFailedTitle {
    return Intl.message(
      'Purchase failed',
      name: 'IAP_PurchaseFailedTitle',
      desc: '',
      args: [],
    );
  }

  /// `The response speed may be slow due to the network delay. You can continue to purchase the product. Do not perform other operations during the purchase process and wait for the system response`
  String get IAP_PurchaseFailedMsg {
    return Intl.message(
      'The response speed may be slow due to the network delay. You can continue to purchase the product. Do not perform other operations during the purchase process and wait for the system response',
      name: 'IAP_PurchaseFailedMsg',
      desc: '',
      args: [],
    );
  }

  /// `Restore subscription`
  String get IAP_RestoreConfirmTitle {
    return Intl.message(
      'Restore subscription',
      name: 'IAP_RestoreConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `Make sure you are only signed into one correct App Store account, not multiple accounts. This app cannot recognize multiple accounts. If the recovery fails multiple times, please contact us.`
  String get IAP_RestoreConfirmMsg {
    return Intl.message(
      'Make sure you are only signed into one correct App Store account, not multiple accounts. This app cannot recognize multiple accounts. If the recovery fails multiple times, please contact us.',
      name: 'IAP_RestoreConfirmMsg',
      desc: '',
      args: [],
    );
  }

  /// `Restore successed`
  String get IAP_RestoreSuccessTitle {
    return Intl.message(
      'Restore successed',
      name: 'IAP_RestoreSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `The subscription is still valid`
  String get IAP_RestoreSuccessMsg {
    return Intl.message(
      'The subscription is still valid',
      name: 'IAP_RestoreSuccessMsg',
      desc: '',
      args: [],
    );
  }

  /// `Can't restore subscription`
  String get IAP_RestoreFailedTitle {
    return Intl.message(
      'Can\'t restore subscription',
      name: 'IAP_RestoreFailedTitle',
      desc: '',
      args: [],
    );
  }

  /// `No valid subscription was obtained`
  String get IAP_RestoreFailedMsg {
    return Intl.message(
      'No valid subscription was obtained',
      name: 'IAP_RestoreFailedMsg',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Upgarde Pro`
  String get settings_upgardepro {
    return Intl.message(
      'Upgarde Pro',
      name: 'settings_upgardepro',
      desc: '',
      args: [],
    );
  }

  /// `Create and spin custom wheels!`
  String get settings_upgardepro2 {
    return Intl.message(
      'Create and spin custom wheels!',
      name: 'settings_upgardepro2',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get settings_general {
    return Intl.message(
      'General',
      name: 'settings_general',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get settings_language {
    return Intl.message(
      'Languages',
      name: 'settings_language',
      desc: '',
      args: [],
    );
  }

  /// `Sound`
  String get settings_sound {
    return Intl.message(
      'Sound',
      name: 'settings_sound',
      desc: '',
      args: [],
    );
  }

  /// `Haptic feedback`
  String get settings_haptic_feedback {
    return Intl.message(
      'Haptic feedback',
      name: 'settings_haptic_feedback',
      desc: '',
      args: [],
    );
  }

  /// `App icon`
  String get settings_appicon {
    return Intl.message(
      'App icon',
      name: 'settings_appicon',
      desc: '',
      args: [],
    );
  }

  /// `Data`
  String get settings_data {
    return Intl.message(
      'Data',
      name: 'settings_data',
      desc: '',
      args: [],
    );
  }

  /// `Import data`
  String get settings_importdata {
    return Intl.message(
      'Import data',
      name: 'settings_importdata',
      desc: '',
      args: [],
    );
  }

  /// `Export data`
  String get settings_exportdata {
    return Intl.message(
      'Export data',
      name: 'settings_exportdata',
      desc: '',
      args: [],
    );
  }

  /// `iCloud sync`
  String get settings_icloudsync {
    return Intl.message(
      'iCloud sync',
      name: 'settings_icloudsync',
      desc: '',
      args: [],
    );
  }

  /// `Others`
  String get settings_others {
    return Intl.message(
      'Others',
      name: 'settings_others',
      desc: '',
      args: [],
    );
  }

  /// `Give a comment`
  String get settings_appreview {
    return Intl.message(
      'Give a comment',
      name: 'settings_appreview',
      desc: '',
      args: [],
    );
  }

  /// `Share to friends`
  String get settings_share {
    return Intl.message(
      'Share to friends',
      name: 'settings_share',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get settings_feedback {
    return Intl.message(
      'Feedback',
      name: 'settings_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get settings_privacy {
    return Intl.message(
      'Privacy Policy',
      name: 'settings_privacy',
      desc: '',
      args: [],
    );
  }

  /// `User Agreement`
  String get settings_eula {
    return Intl.message(
      'User Agreement',
      name: 'settings_eula',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
