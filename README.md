# Justice & Co. Case Tracker: Task 2 (Offline Caching with Hive)

A Flutter app (Clean Architecture) that lists a law firm's **active cases**
and keeps working when the Wi-Fi drops. It extends the Task 1 network layer,
which lives in its own separate repository.

## What this task adds
- Local cache of the case data using **Hive** (`hive`, `hive_flutter`).
- **Sync strategy** (`CaseRepositoryImpl`):
  1. Try the API first.
  2. If the API succeeds, update the Hive cache and show fresh data.
  3. If it fails for any reason, load the last saved data from Hive.
  4. If there is no saved data either, show the error screen with Retry.
- An **offline banner** showing when the data was last synced, with a Retry button.

## Data source
Mock API: `https://jsonplaceholder.typicode.com/todos`.
`completed == true` maps to a `closed` case, otherwise `active`. Only active
cases are shown. The cache stores all fetched cases and the active filter is
applied when reading.

## Structure
```
lib/
├── main.dart                      DI wiring, Hive init
├── core/
│   ├── error/exceptions.dart      typed exceptions (incl. CacheException)
│   ├── network/api_client.dart    shared HTTP client
│   ├── network/network_info.dart  connectivity_plus wrapper
│   └── theme/app_colors.dart
└── features/cases/
    ├── domain/    entities (Case, CasesResult), repository contract, usecase
    ├── data/      models, remote + local (Hive) data sources, repository impl
    └── presentation/  CasesPage, list item, summary header, error view, offline banner
```

## Run
```bash
flutter create .     # once, generates android/ and ios/
flutter pub get
flutter run
```
Android release builds need
`<uses-permission android:name="android.permission.INTERNET"/>` inside
`<manifest>` in `android/app/src/main/AndroidManifest.xml`.

## Try the offline behaviour
1. Run with internet so the list loads (this fills the cache).
2. Close the app, turn off Wi-Fi and mobile data, open it again:
   the saved list appears with an "Offline" banner and the last sync time.
3. Turn the internet on and tap Retry on the banner to sync again.
4. On a fresh install with no internet, the "No Internet Connection" screen appears.
