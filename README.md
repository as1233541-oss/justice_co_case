# Justice & Co. Case Tracker

Clean Architecture Flutter app. Fetches https://jsonplaceholder.typicode.com/todos
and shows only ACTIVE cases (completed == false).

## Run
1. flutter create .      (once, generates android/ios)
   then delete the generated test/ folder (not needed)
2. flutter pub get
3. flutter run

Android release builds need INTERNET permission in
android/app/src/main/AndroidManifest.xml (inside <manifest>):
<uses-permission android:name="android.permission.INTERNET"/>

## Structure
lib/core/error      typed exceptions (NoInternet, Timeout, Server, Parsing, Unknown)
lib/core/network    ApiClient (shared http wrapper) + NetworkInfo (connectivity_plus)
lib/core/theme      colors
lib/features/cases  domain / data / presentation
