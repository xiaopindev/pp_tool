import 'package:get/get.dart';

import '../modules/app_review/app_review.dart';
import '../modules/app_versioin/new_version.dart';
import '../modules/common/root_page.dart';
import '../modules/common/web_page.dart';
import '../modules/guides/guides_page.dart';
import '../modules/launch_load/launch_page.dart';
import '../modules/settings/feedback_page.dart';
import '../modules/settings/individuation_page.dart';
import '../modules/settings/languages_page.dart';
import '../modules/subscription/subscription_page.dart';

/*
Get.toNamed("/NextScreen");
Get.toNamed("/NextScreen", arguments: {"id": 1});
Get.toNamed("/NextScreen", arguments: {"id": 1}, id: "2");
Get.toNamed("/NextScreen", arguments: {"id": 1}, id: "2", preventDuplicates: false);

Get.toNamed(AppPages.root);
*/
class AppPages {
  static const String demo = '/demo';

  static const String notFound = '/not_found';
  static const String root = '/';
  static const String launchLoad = '/launch_load';
  static const String guides = '/guides';
  static const String subscription = '/subscription';
  static const String home = '/home';
  static const String web = '/web';
  static const String newVersion = '/new_version';
  static const String appReview = '/app_review';
  static const String feedback = '/feedback';
  static const String languages = '/languages';
  static const String audioPlayer = '/audio_player';
  static const String driveMode = '/audio_player_drive_mode';
  static const String equalizer = '/audio_player_equalizer';

  static const String trackSongEdit = '/tracks_song_edit';
  static const String trackSongListEdit = '/tracks_song_list_edit';
  static const String trackAlbumListEdit = '/tracks_album_list_edit';
  static const String trackAlbumDetail = '/tracks_album_detail';
  static const String trackFavorites = '/tracks_favorites';

  static const String playlistAddEdit = '/playlist_add_edit';
  static const String playlistAddSongs = '/playlist_add_songs';
  static const String playlistDetail = '/playlist_detail';
  static const String playlistPicker = '/playlist_picker';

  static const String importAudioExtractor = '/import_audio_extractor';
  static const String transferOnPcWifi = '/transfer_on_pc_wifi';
  static const String transferOnAppleDevices = '/transfer_on_apple_devices';
  static const String transferOnDropbox = '/transfer_on_dropbox';
  static const String transferOnOneDrive = '/transfer_on_onedrive';
  static const String transferOnGoogleDrive = '/transfer_on_google_drive';

  static const String individuation = '/individuation';

  static final routers = [
    GetPage(name: AppPages.launchLoad, page: () => const LaunchLoadingPage()),
    GetPage(name: AppPages.guides, page: () => const GuidesPage()),
    GetPage(
      name: AppPages.subscription,
      page: () => const SubscriptionPage(),
      popGesture: false,
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppPages.home,
      page: () => const RootPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(name: AppPages.web, page: () => const WebViewPage()),
    GetPage(
      name: AppPages.newVersion,
      page: () => const NewVerPage(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: AppPages.appReview,
      page: () => const AppReviewPage(),
      transition: Transition.zoom,
    ),
    GetPage(name: AppPages.feedback, page: () => const FeedbackPage()),
    GetPage(name: AppPages.languages, page: () => const LanguagesPage()),
    GetPage(
      name: AppPages.individuation,
      page: () => IndividuationPage(),
    )
  ];
}
