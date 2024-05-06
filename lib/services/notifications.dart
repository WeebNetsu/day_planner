import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:url_launcher/url_launcher.dart';

class NotificationController {
  /// ID used when the notification is about app updates
  static const updateId = 1;

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // final appInfoConn = MongoDB.db?.collection(AppInfoModel.collectionName);

    // try {
    //   final appInfoRes = await appInfoConn?.findOne();

    //   if (appInfoRes != null) {
    //     final appInfo = AppInfoModel.fromJson(appInfoRes);

    //     // await launchUrl(Uri.parse(appInfo.latestAppUrl));
    //   }
    // } catch (e) {
    //   // we do nothing if it fails, since it does not affect app day-to-day usage
    // }

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
    //   '/update',
    //   (route) => (route.settings.name != '/update') || route.isFirst,
    //   arguments: receivedAction,
    // );
  }
}
