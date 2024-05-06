import 'package:day_planner/views/views.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes = {
  "/": (context) => const LoginView(),
  "/login": (context) => const LoginView(),
};
