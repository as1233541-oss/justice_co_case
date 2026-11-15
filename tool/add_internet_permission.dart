// Run once after `flutter create .`:  dart tool/add_internet_permission.dart
// Adds the INTERNET permission to the Android manifest. Debug builds get it
// automatically, but release builds do not, so without it the release app
// cannot reach the API.
import 'dart:io';

void main() {
  final file = File('android/app/src/main/AndroidManifest.xml');
  if (!file.existsSync()) {
    stderr.writeln('AndroidManifest.xml not found. Run "flutter create ." first.');
    exit(1);
  }

  final text = file.readAsStringSync();
  if (text.contains('android.permission.INTERNET')) {
    stdout.writeln('INTERNET permission already present. Nothing to do.');
    return;
  }

  final index = text.indexOf('<application');
  if (index == -1) {
    stderr.writeln('Could not find the <application> tag in the manifest.');
    exit(1);
  }

  file.writeAsStringSync(text.replaceRange(
    index,
    index,
    '<uses-permission android:name="android.permission.INTERNET"/>\n    ',
  ));
  stdout.writeln('Added the INTERNET permission.');
}
