import 'package:flutter/foundation.dart';

/// Simple session for current user display name. Null = guest (not logged in).
/// Auth screens set [currentUserName] on successful sign-in/login.
final ValueNotifier<String?> currentUserName = ValueNotifier<String?>(null);
