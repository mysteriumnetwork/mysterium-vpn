# Mysterium App Release Process 🚀

This document outlines the step-by-step process for preparing, configuring, and releasing the Mysterium app across iOS, macOS, Android, and Windows platforms.

---

## Step 1: Versioning & Internal Communication 📢

1. Decide on the new version number for the release.
2. Create a new release tag in GitHub (e.g. `2.1.0`).
3. Announce the new tag in [#vpn-releases](https://mysteriumnetwork.slack.com/archives/C0488D16RMF).

---

## Step 2: ConfigCat Flags 🧩

We use ConfigCat to control feature visibility across different platforms and environments, especially for app store review builds.

### `hideDeleteAccount`

* **Default**: `true` (button hidden)
* **Override**: `false` for `ios` and `macos` **if** app version equals latest

### `pricingMonthly`

* **Default**: `true`
* **Override**: `false` for `ios` and `macos` **if** app version equals latest

These flags allow us to tailor features shown during the app review process. Always ensure ConfigCat settings are correct before submissions. Once the apps are approved and published, restore the flags to their default values. 

---

## Step 3: Human-Readable Release Notes 📝

1. Prepare a short, user-facing changelog for the app release.
2. Use [this spreadsheet](https://docs.google.com/spreadsheets/d/15Du_g0SD7coaByv-OO8BEe661y-sCnj7FLqolOmgmsQ/edit?usp=sharing) to manage translations.
3. These notes will be used on all platform stores (iOS, Android, macOS, Microsoft Store). 

---

## Step 4: Platform Releases 📲

### iOS 🍎

Link: [App Store Connect – iOS](https://appstoreconnect.apple.com/apps/6446624307/distribution/ios/version/deliverable)

1. Press `+` next to **iOS App** to create a new version.
2. Add translated changelog in **What's New in This Version** (use spreadsheet).
3. Under **Build**, press "Add Build" and select the latest build.
4. Under **App Store Version Release**, choose `Manually release this version`.
5. Under **Phased Release**, select `Release update over 7-day period`.
6. Click **Add for Review**, wait for processing, then **Submit to App Review**.

### macOS 🖥️

Link: [App Store Connect – macOS](https://appstoreconnect.apple.com/apps/6446624307/distribution/macos/version/deliverable)

Same process as iOS with two exceptions:

* Press `+` next to **macOS App**
* Changelog is only required in English

### Android 🤖

Link: [Google Play Console – Production](https://play.google.com/console/developers/7955390843158584488/app/4973980590971676436/tracks/production)

1. Press **Create New Release**.
2. In **App Bundles**, click `Add from Library` and select latest bundle.
3. In **Release Details**, paste translated changelog.
4. Press `Next`.
5. In **Staged Rollout**, set initial rollout to 1%. Android requires daily manual updates to mimic Apple’s 7-day schedule.
6. Press `Save`.
7. Go to **Publishing Overview**, ensure **Managed publishing** is enabled, then press **Send changes for review**.

### Windows 📦

For Windows, builds are generated automatically but **must be uploaded manually** to Microsoft Partner Center. 📤

1. Visit the [CD GitHub Action](https://github.com/mysteriumnetwork/mysterium-vpn/actions/workflows/cd.yml) and find the workflow for the latest version tag.
2. Under the **Artifacts** section, download the `Windows app (Store)` ZIP file. **Do not use** the `Standalone` build.
3. Extract the ZIP to access the `.msix` file. This is what gets submitted to the Microsoft Store.
4. Go to the [Microsoft Partner Center](https://partner.microsoft.com/en-us/dashboard/products/9NGWJCZSB5MK/overview).
5. Click **Add new package**, then upload the `.msix` file.
6. Once uploaded, press **Submit for certification**.

This process ensures the Windows Store build is correctly submitted and certified. 

---

## Final Steps ✅

1. Once iOS and macOS apps are approved, publish them using staged rollout.
2. After iOS/macOS are live, **restore the ConfigCat flags** to their default values.
3. Once Android is approved, begin the rollout at 1% and manually increase daily to mirror Apple’s staged rollout.

This concludes the release process. 🎉
