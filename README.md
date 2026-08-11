# xpiria_app

## Notifications

The application supports:

- Local notifications through `flutter_local_notifications`.
- Push notifications through Firebase Cloud Messaging (FCM).
- Foreground, background and notification-tap handling.

To test a local notification, sign in and press the notification floating
button on the home screen. Accept the notification permission when prompted.

To test a push notification on Android, run the app on a physical device, copy
the `FCM token` shown in the debug console and send a test message from Firebase
Console > Messaging. For iOS, also enable **Push Notifications** and
**Background Modes > Remote notifications** for the Runner target in Xcode and
upload an APNs authentication key in the Firebase console.

A new Flutter project.
