import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rickmorty/layers/presentation/app_root.dart';
import 'package:rickmorty/layers/presentation/using_get_it/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum for different state management options in Flutter.
///
/// This enum represents the different state management strategies that can be used in a Flutter application.
/// The options include:
/// - `bloc`: A predictable state management library that helps implement the BLoC design pattern
/// - `cubit`: A simpler version of `bloc` that doesn't require Streams and Sinks
/// - `provider`: A wrapper around InheritedWidget to make them easier and more intuitive to use
/// - `riverpod`: A flexible state management solution that works well with Flutter's widget tree
/// - `getIt`: A service locator for managing state and other resources
/// - `mobx`: A state management library that makes it easy to connect the reactive data of your application with the UI
enum StateManagementOptions {
  bloc,
  cubit,
  provider,
  riverpod,
  getIt,
  mobX,
}

// The `late` keyword is used because we can't immediately initialize `SharedPreferences` as it's an asynchronous operation.
late SharedPreferences sharedPref;

// Runs the Flutter application.
//
// This line of code is typically found in the `main` function of a Flutter application. It initializes the root widget of the application.
// In this case, the root widget is `ProviderScope` with a child widget `AppRoot`.
//
// `ProviderScope` is a widget from the `flutter_riverpod` package that provides a scope in which you can read providers.
// This means that any widgets in the subtree can use `ProviderScope` to access the data provided by the `Provider`.
//
// `AppRoot` is the root widget of the application. This is where the application starts its widget tree.
void main() async {
  // Ensures that the widget tree in the Flutter engine is properly initialized.
  // This method should be called if you will be working with services such as
  // `SharedPreferences` or other platform channels that need to interact with
  // the native platform. It is typically called before running the app to make
  // sure that these services are initialized before any widgets are built.
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes the `SharedPreferences` instance and assigns it to `sharedPref`.
  // `SharedPreferences` allows you to read and write persistent key-value pairs of
  // primitive data types. This is typically used for storing simple data like user
  // preferences, settings, etc.
  sharedPref = await SharedPreferences.getInstance();

  // Calls the `initializeGetIt` function to set up the GetIt service locator.
  // GetIt allows you to access services and instances across your whole app.
  await initializeGetIt();

  // Sets the `restartOnHotReload` property of the `Animate` class to `true`.
  // This ensures that any ongoing animations are restarted whenever a hot reload occurs.
  Animate.restartOnHotReload = true;

  // Runs the Flutter application.
  //
  // This line of code is typically found in the `main` function of a Flutter application. It initializes the root widget of the application.
  // In this case, the root widget is `ProviderScope` with a child widget `AppRoot`.
  //
  // `ProviderScope` is a widget from the `flutter_riverpod` package that provides a scope in which you can read providers.
  // This means that any widgets in the subtree can use `ProviderScope` to access the data provided by the `Provider`.
  //
  // `AppRoot` is the root widget of the application. This is where the application starts its widget tree.
  runApp(const ProviderScope(child: AppRoot()));
}
