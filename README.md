# Coach Pro (كوتش برو)

A client-management app for personal trainers. A coach tracks their clients,
records monthly body measurements with before/after photos, keeps an eye on
subscription renewals, and manages expenses and partner profit splits — with
push reminders when a subscription is about to lapse or a measurement is
overdue.

Flutter + Supabase. Arabic-first (RTL), with English available.

---

## Requirements

| | |
|---|---|
| Flutter | 3.41.9 (Dart 3.11.5) |
| iOS deployment target | 15.0 — required by `firebase_core` |
| Xcode | 16 or newer |
| Backend | A Supabase project + a Firebase project (for FCM) |

---

## Getting started

```bash
git clone <repo> && cd Coach_App
cp .env.example .env      # then fill in the two values
flutter pub get
flutter run
```

### The `.env` file

`.env` is declared as a Flutter asset and is **required to build** — without
it the build stops at `No file or variants found for asset: .env`. It is
gitignored; copy the template and fill it in from your Supabase dashboard
(Project Settings → API):

```
SUPABASE_URL=https://<your-project-ref>.supabase.co
SUPABASE_ANON_KEY=<your publishable/anon key>
```

### iOS first build

The first `pod install` can take several minutes. If CocoaPods complains that
its specs are out of date:

```bash
cd ios && pod repo update
```

---

## Project layout

```
lib/
├── core/                      shared across features
│   ├── constants/             strings, sizes, spacing, radii, enums
│   ├── errors/                exception types + ExceptionMapper
│   ├── localization/          locale state and the ar/en string resolver
│   ├── network/               connectivity tracking
│   ├── theme/                 colours, text styles, ThemeData
│   ├── utils/                 logger, image compression
│   └── widgets/               buttons, inputs, cards, layout, status
├── features/                  one folder per feature
│   ├── auth/                  sign-in, sign-up, password reset
│   ├── subscribers/           clients: list, profile, add/edit
│   ├── measurements/          monthly measurements + photos
│   ├── financial/             income, expenses, partner splits
│   └── notifications/         inbox, FCM handling, app badge
└── routing/                   GoRouter config and auth redirects

supabase/
├── functions/send-notifications/   daily notification job (Deno)
├── migrations/                     schema changes
└── seed/                           test data + diagnostics
```

Each feature follows the same shape:

```
feature/
├── cubit/      state + states
├── data/       repository — the only thing that talks to Supabase
├── models/     immutable models with fromJson / toJson
├── helper/     validators, formatters
├── screens/    screens and their private widgets
└── widgets/    widgets reused across the feature's screens
```

---

## Architecture notes

**State: Cubit (flutter_bloc).** Screens never call a repository directly.
Repositories throw; cubits catch and translate.

**Errors go through one place.** Every `catch` in a cubit calls
`ExceptionMapper.mapToMessage(e)`, which turns any Supabase, network, or
parsing failure into a ready-to-display Arabic/English string. Add new cases
there, not at call sites. Anything it cannot classify is logged with its type
and code in debug builds, so gaps surface in the console rather than as a
vague user report.

**Repositories scope by trainer.** Every query filters on `trainer_id`
alongside whatever RLS enforces — defence in depth, not a substitute for it.
The measurements table has no `trainer_id` column, so it scopes through
`subscribers` instead.

**Cubit lifetimes are deliberate.** `SubscriberCubit` is scoped to a
`ShellRoute` rather than the app root, so it is created when a screen that
needs it first opens and disposed when you leave that section.

**Refreshes keep data on screen.** Cubits that reload existing data do not
drop back to a loading state — the list stays visible while the request is in
flight.

---

## Localization

Strings live in `AppStrings` as getters over `AppLocale.current`:

```dart
static String get loginCta => _t('تسجيل الدخول', 'Log in');
```

Two rules when adding copy:

1. **Address the user in the masculine (general) form.** Arabic has no
   neutral imperative. `test/core/copy_style_test.dart` fails the build on
   feminine-address forms.
2. **Never hardcode a user-facing string in a widget.** Add it to
   `AppStrings` or `ErrorMessages`.

This is a hand-rolled setup rather than ARB/`gen-l10n`. It works because
`MaterialApp` rebuilds on locale change, but it sidesteps
`Localizations.of(context)` and has no plural support — worth migrating if
the app grows.

---

## Theming

Colours come from `Theme.of(context).colorScheme` for standard roles, and
`context.appColors` for everything else (borders, soft backgrounds, success
and warning tones, link colour).

Never import `AppColorsLight` or `AppColorsDark` into a widget — that is how
dark-palette colours ended up on a white card. `theme_contrast_test.dart`
asserts the link and body-text tokens clear 4.5:1 in both themes.

The app is **portrait-only**. The auth screens position content as a fraction
of screen height, which breaks in landscape.

---

## Notifications

Two halves that fail independently:

**The daily job** — `supabase/functions/send-notifications` runs at 09:00 UTC
via `pg_cron`. It finds what is due, writes a row to `notifications`, then
sends a push. Three kinds:

| Type | Fires |
|---|---|
| `subscription_expiry` | exactly one day before the end date |
| `overdue_measurement` | 1 and 3 days after the monthly due date, if unrecorded |
| `new_program_needed` | 28 days after the last program update, once per cycle |

The in-app inbox reads the table, so it works whether or not the push is
delivered.

```bash
supabase functions deploy send-notifications
deno test supabase/functions/send-notifications/    # requires deno
```

**Push delivery** needs three things, all outside this repository:

1. Push Notifications enabled on the `com.glowup.glowUp` App ID (Apple
   Developer portal). Without it, device builds fail code signing.
2. An APNs auth key (`.p8`) uploaded to Firebase → Project settings → Cloud
   Messaging. Without it FCM returns `Invalid APNs credential` and nothing is
   delivered, even though rows are still written.
3. A real device. The simulator cannot register for push; use
   `xcrun simctl push` to test rendering.

To exercise the inbox without waiting for a real event, run
`supabase/seed/test_notifications.sql`. To work out why it is empty, run
`supabase/seed/check_notifications.sql` — most often nothing is actually due
yet.

---

## Testing

```bash
flutter test                                      # 95 tests
flutter analyze                                   # expected: no issues
deno test supabase/functions/send-notifications/  # edge function date logic
```

The suite is weighted towards things that have broken before: error
classification, subscription status thresholds, notification payload parsing,
link contrast, and copy style. When fixing a bug, add the case that would have
caught it.

---

## Known gaps

- **The database schema is not in this repository.** `supabase/migrations/`
  holds only the partners table and the cron schedule; the five tables the app
  depends on, the RLS policies, and the `on_auth_user_created` trigger exist
  only in the dashboard. Nothing here can recreate the database, and the
  policies the security model rests on cannot be reviewed. This is the most
  valuable thing to fix.
- `notifications.title` does not exist yet. The edge function computes a title
  and discards it, so the push and the in-app list show different text for the
  same event. Migration is ready in `supabase/migrations/`; apply it, then
  uncomment the marked line in `index.ts`.
- `AuthCubit` reaches for `FirebaseMessaging.instance` in its constructor, so
  it cannot be unit tested without initialising Firebase.
- The splash screen is unreachable — `AuthCubit` resolves the session
  synchronously, so `AuthInitial` never survives to be observed.
