# NativeTavern release runbook

This is the durable source of truth for packaging and publishing NativeTavern.
It exists to prevent release steps from being reconstructed from chat history.

## Non-negotiable rules

- Start from the repository root and read this file before release work.
- Preserve unrelated user changes in a dirty worktree.
- Read configuration from `.env`; never print secret values.
- Bump `pubspec.yaml` before packaging. Do not relabel an older artifact with a
  new build number.
- Package only with the checked-in `.sh` scripts. Never substitute ad hoc
  Flutter, Gradle, or Xcode packaging commands.
- A packaging script must finish successfully and print its final artifact
  path before any upload begins.
- Apple is internal TestFlight only unless the user explicitly requests App
  Store review submission.
- Google Play uses the AAB. Cloudflare R2 receives the APK.
- Discord announcements use the bot API through
  `tool/discord_release.sh`, never browser automation.
- License or SDK commercial review does not block engineering delivery.

## 1. Establish the release baseline

Run read-only checks first:

```sh
git status --short --branch
git log -5 --oneline --decorate
git tag --sort=-creatordate --list 'v*'
awk -F= '/^[A-Za-z_][A-Za-z0-9_]*=/{print $1}' .env | sort
tool/discord_release.sh history 10
```

The last Discord announcement, not merely the last Git tag, defines the
starting version for cumulative public release notes.

Required `.env` keys are platform-dependent:

- Apple: `APPLE_DEVELOP_ID`, `APP_STORE_CONNECT_ISSUER_ID`
- Google Play: `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`,
  `GOOGLE_PLAY_PACKAGE_NAME`, `GOOGLE_PLAY_TRACK`
- R2: `R2_Access_Key`, `R2_Secret_Key`, `R2_Endpoint`, `R2_OBJECT`
- Discord: `DISCORD_BOT_TOKEN`, `DISCORD_GUILD_ID`,
  `DISCORD_RELEASE_CHANNEL_ID`

Never include the values of secret keys in logs, release notes, commits, or
chat output.

## 2. Set the version

`pubspec.yaml` is the version source of truth:

```yaml
version: <marketing-version>+<build-number>
```

Confirm the build number is newer than every uploaded build on the target
stores. Use the same version value for filenames, Git tags, and release notes.

## 3. Run checks

Run the repository gate before packaging:

```sh
tool/run_mobile_release_checks.sh
```

If a known pre-existing gate failure is unrelated to the requested release,
record it accurately. Do not silently claim the full gate passed. The platform
packaging script's own validation must still pass.

## 4. Package

Use only these commands:

```sh
./build_ios.sh
./build_android.sh
./build_macos.sh
```

Relevant iOS modes:

```sh
CHECK_ONLY=true ./build_ios.sh
BUILD_FOR_DEVICE=true DEVICE_ID=<device-id> ./build_ios.sh
```

Expected artifacts:

- `release/NativeTavern_v<version>.ipa`
- `release/NativeTavern_v<version>_Android.apk`
- `release/NativeTavern_v<version>_Android.aab`
- `release/NativeTavern_v<version>_macOS.zip`

Record a SHA-256 checksum for every distributed artifact. For iOS, preserve
the script's checks for bundle ID, version/build, iOS 15.0 minimum, signing,
and the native Live2D render-scale path.

## 5. Distribute

### Apple

Upload the IPA with the App Store Connect API credentials, then wait until the
build is `VALID`. Associate it with the intended internal TestFlight group and
verify `internalBuildState` is `IN_BETA_TESTING` before sending invitations.

Use `tool/app_store_connect_api.rb` for App Store Connect resource reads and
mutations instead of assembling one-off JWT and `curl` requests. The tool reads
`APP_STORE_CONNECT_ISSUER_ID` from the environment and discovers the matching
`AuthKey_*.p8` in the standard App Store Connect private-key directory:

```sh
set -a
. ./.env
set +a
tool/app_store_connect_api.rb GET '/v1/apps/6757631215/appStoreVersions'
```

Do not submit App Store review without an explicit instruction. Expire or
remove old test builds only when requested or when they make the current
internal invitation non-installable.

App Store Review contact fields are optional for this project. Do not add,
invent, or treat missing contact name, email, or phone fields as a release
requirement. If an API submission flow reports a contact-field validation
error, report the platform response without writing placeholder contact data.

For a resubmission, inspect the existing `reviewSubmissions` collection and
its `reviewSubmissionItems` first. Reuse the prepared submission item and
submit it with `PATCH /v1/reviewSubmissions/{id}` using
`{"data":{"type":"reviewSubmissions","id":"{id}","attributes":{"submitted":true}}}`.
Do not create a second draft submission or add contact fields as a workaround.

### Google Play

Upload the `.aab`, not the APK. Use the configured track and follow the user's
explicit instruction about draft, staged rollout, or production review.
Verify the edit was committed and read back the resulting track/release state.
Use the repository helper so the upload, track update, validation, commit, and
read-back remain one operation:

```sh
set -a
. ./.env
set +a
GOOGLE_PLAY_TRACK=production dart run tool/google_play_release.dart publish \
  release/NativeTavern_v<version>_Android.aab \
  docs/releases/<version>-app-store-whats-new.json <version-code> completed
```

For a production-track draft that must not be sent for review, preserve the
currently completed release and pass `draft` explicitly:

```sh
set -a
. ./.env
set +a
GOOGLE_PLAY_TRACK=production dart run tool/google_play_release.dart publish \
  release/NativeTavern_v<version>_Android.aab \
  docs/releases/<version>-app-store-whats-new.json <version-code> draft
```

### Cloudflare R2

Upload the APK for direct distribution using the configured R2 endpoint and
object key. Verify the public download URL and checksum after upload. The
canonical APK URL currently used in announcements is:

```text
https://download.nativetavern.com/NativeTavern.apk
```

### macOS

Package the macOS release application with `./build_macos.sh`. The final artifact is packaged as `release/NativeTavern_v<version>_macOS.zip` accompanied by its `.sha256` checksum.
Verify the zip archive integrity and checksum:

```sh
unzip -t "release/NativeTavern_v${VERSION}_macOS.zip"
shasum -a 256 -c "release/NativeTavern_v${VERSION}_macOS.zip.sha256"
```

For local development and testing, run `./build_macos_local.sh`, which produces test artifacts under `build/local_release/`.

## 6. Publish release notes to Discord

Fetch the latest announcements first:

```sh
tool/discord_release.sh history 10
```

Write public, user-facing cumulative notes from the last announced build to
the new build. Include platform availability and download links; omit internal
implementation noise and license commentary. Save the exact posted text under
`docs/releases/` so the announcement baseline remains available in Git.

Validate, then publish:

```sh
tool/discord_release.sh validate docs/releases/<release>-discord.md
tool/discord_release.sh publish docs/releases/<release>-discord.md
```

The script must return the Discord message ID and URL. Read the message back or
use `history` to confirm the posted content.

## 7. Commit and verify

Commit the version and any release metadata, create the matching annotated
tag, and push both `main` and the tag. Verify:

```sh
git status --short --branch
git rev-parse HEAD
git rev-parse 'v<version>^{}'
git ls-remote --heads --tags origin main 'v<version>'
```

Completion means all requested store states, R2 artifacts, Discord message,
checksums, commit, branch, and tag have been independently read back.
