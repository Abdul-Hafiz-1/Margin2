import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'core/services/state_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize offline encrypted storage & repositories
  try {
    await StateService.instance.initialize();
  } catch (e) {
    debugPrint('[Main] Offline storage initialization error ($e). Continuing with in-memory state.');
  }

  runApp(const MarginApp());
}
