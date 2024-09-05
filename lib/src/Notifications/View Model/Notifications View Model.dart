import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotification(String title, String body, String payload) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );
  await flutterLocalNotificationsPlugin
      .show(0, title, body, notificationDetails, payload: payload);
}

Future<void> sendNotificationToSelectedDevice(String deviceToken, String sentMessage,String sender_name) async {
  final String serverAccessTokenKey = await getAccessToken();
  final String endpointFirebaseCloudMessaging =
      'https://fcm.googleapis.com/v1/projects/chatapp-4d1a9/messages:send';

  final Map<String, dynamic> message = {
    'message': {
      'token': deviceToken,
      'notification': {
        'title': "$sender_name",
        'body': sentMessage,
      },
    },
  };

  final http.Response response = await http.post(
    Uri.parse(endpointFirebaseCloudMessaging),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverAccessTokenKey',
    },
    body: jsonEncode(message),
  );

  if (response.statusCode == 200) {
    print('FCM message sent successfully');
  } else {
    print('Failed to send FCM message: ${response.statusCode}');
    print(response.body);
  }
}

Future<String> getAccessToken() async {
  final serviceJson = {
    "type": "service_account",
    "project_id": "chatapp-4d1a9",
    "private_key_id": "130caf2ec330904b07336969cc6aba998e64d11c",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCUyNUp8yF8oXmv\nXBjF7SSXP/aHdcxJx3G1OoPd8APZAaDBIyf7dwY8aIamAgbmJrqc/XBK7aXhKgcV\n5/7fvLhkS4OMxNloDSIB9p8s3/Q+q0gBS05ZyLCI/mwjzpUIUDO1ih+/9lXCaloc\nQX3At1ukOjRwUfCAPzzhNSvRIQPX0Q6mhiLnBJI6mb6d6hrRLyKxnipLQYSpxN90\nK8rs0UTISzl4dTeEKtEpOHv4CmhuKo3qVsYt/iyeF1J1hk8cGz4a6XqY858v10O7\nkE1u1NwbCKxgT4pCRHV0C3sDdCkubcfqWyhVktSjgp47sfEPkVWvoX5s28CEn+eA\n025WE+i3AgMBAAECggEAGsyL3Lj+3KCHNwdbLPd4gkfSo3ab2+QxPofyLZ0oTEOn\nTXKEJp67QFFBg5BU5squDU33Fn/0w3ha+16kwW8QNXyGjun8EOpgqELgS+hw6YLX\nfuguDi0AY0SUfOSeYndzwOzGqEB6FQEsBu/i8z3zo0KapGqV67u4PwZhRJNySkKG\nshMx2V/2bFm3DUsHwOIE0+NZ47LqB7tCY65azb4Sx4uX5Xoy3nhwzDdjmh8bXbaK\nS+BBEwku6MJSLiKE8oQW+gTKg/g/QeDCL0KZan7JNeXyTnqcUxGDKtgYqzH9waf+\nmeVYeY13+CIBrhvzClSVWRrbc0wqS04h/MNufkvJaQKBgQDQE1X/uPit8zDcObHR\npUL7NHDzaAEhen6igO4+wF5IWmEBZ1C+M6j1BioA6XFkABhWO3DmxIc0In3nH/eS\nvWWAdjK9CCNUGWwmpqx6zzgkQO1KVbyMCeOdPaPUPCqp0wSMMTuFtQ7dmNgXSkrS\nSQK7q1uzEMIAWhK4B86qmvOXGQKBgQC3DYvlL+TWpGCaJzEeDLAT4uITM4Sel5Hr\n/sW9cY5rT4NT9x3O/qe4DswUgvEptpUeLnfxtY69ii22wB8UkZuQr0T4u2aIkQYF\nG0rMRzD8PKBAqswC8awrA+bddHvovXj+cGYIbSQcDDedF+eWslpuN2fBJFpBbhtj\npy4uNRuITwKBgA3N+pqorvb7d3Zk7YM3L6Zy6Dt93vVVpyko3KWVJawvMthg/l5g\nFwmKiybcVgWIbBTshKUKzN2MnEXFPSujHSTUsrEP5SgjN6Wo0TCkptjg5d1Uqtmv\nnkZEXKYsB7iUo2yZp5VLWd0h0tRYvXYOGfxRdhf/OJ/FWhCTlAaFmTuhAoGBAIMy\n1l3B4gZlckeKZ43eEiVurBKPDjKM+C1pQVjylt0a9EmuCFNf+d3V3TemUitPjblA\nHP/E3TXEX9doA96+Lf2ZYZnU1zxylRn74bRgIh/nZAR1ZhuGE5wRA9sdreG2S44y\nCS9o6kSgDQwvIfHEi0QLufWYlIfo3wChxluf/MfJAoGBAK7RJG/jxydFWUGBWHa0\nPLfunD/bIuP/b6DMHhjxxWrCLwjYOS4NJGcYoDESFtT9l5rC1jd+4ZW22oGl8uPs\nGuIGchQQkyUEV5v7mQFgVDnuTP9XO0XSEbCSjKkY8caJvihHxNlaoz/odV4V/jOk\n7rgozOZCuylARw5K9xshNRVA\n-----END PRIVATE KEY-----\n",
    "client_email":
        "firebase-adminsdk-f16zu@chatapp-4d1a9.iam.gserviceaccount.com",
    "client_id": "103155771168501872526",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-f16zu%40chatapp-4d1a9.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  final serviceAccountCredentials =
      auth.ServiceAccountCredentials.fromJson(jsonEncode(serviceJson));
  final scopes = [
    'https://www.googleapis.com/auth/firebase.messaging',
  ];

  final client =
      await auth.clientViaServiceAccount(serviceAccountCredentials, scopes);
  final credentials = client.credentials;

  return credentials.accessToken.data;
}

Future<String?> getToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  return token;
}

void setupFirebaseMessaging() {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received a message while in the foreground!');
    if (message.notification != null) {
      showNotification(
        message.notification!.title ?? 'Title',
        message.notification!.body ?? 'Body',
        message.data['payload'] ?? '',
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Message clicked!');

  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print('App opened from a notification');
    }
  });
}
