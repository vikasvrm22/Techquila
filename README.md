# Tech Learn

Android app to learn Playwright, TypeScript, Git, Jenkins, and Java — with
daily quiz, progress dashboard, and personal notes (with camera/gallery photos).

## Features

- **5 tutorials**: Playwright, TypeScript, Git, Jenkins, Java — each with several chapters, mark-as-complete tracking
- **Dashboard**: bar chart of progress per tutorial, average quiz score
- **Daily quiz**: 10 random MCQ questions from a 22-question pool covering all 5 topics, instant scoring, answer breakdown
- **My Notes**: side-menu accessible notes screen — add title, text, and a photo from camera or gallery
- All data (progress, quiz scores, notes) stored **locally on the device** using `shared_preferences` — nothing leaves the phone, no backend needed

## Building the APK (via GitHub Actions — no local Android Studio needed)

1. Push this project to a GitHub repository (use GitHub Desktop — see below)
2. GitHub Actions automatically builds the APK on every push
3. Go to the **Actions** tab → latest run → **Artifacts** → download `tech-learn-apk`
4. Extract the zip, install `app-release.apk` on your phone

### Uploading with GitHub Desktop (recommended)

1. Install [GitHub Desktop](https://desktop.github.com)
2. Sign in with your GitHub account
3. Create a new repo on GitHub.com, then **File → Clone Repository** in GitHub Desktop
4. Copy all files from this project folder into the cloned folder
5. In GitHub Desktop: write a commit summary → **Commit to main** → **Push origin**
6. Check the **Actions** tab on GitHub.com — the build starts automatically

## Running Locally (optional, for testing)

```bash
flutter pub get
flutter run
```

Requires Flutter SDK installed locally. If you hit native-compilation errors
on Windows, this project intentionally avoids any package that needs a C++
compiler (no `better-sqlite3`-style dependencies) — everything here is pure
Dart or well-maintained Flutter plugins, so `flutter pub get` should work
without Visual Studio build tools.

## Notes on Content

Tutorial content is written from scratch, in original wording, based on
publicly documented concepts of each technology (Playwright, TypeScript,
Git, Jenkins, Java) — not copied from any single source. Feel free to
expand `lib/data/tutorial_content.dart` and `lib/data/quiz_data.dart` with
more chapters and questions any time.
