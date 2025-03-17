package com.mysteriumvpn.android

import android.app.Application
import io.maido.intercom.IntercomFlutterPlugin

class MyApp : Application() {
  override fun onCreate() {
    super.onCreate()
    IntercomFlutterPlugin.initSdk(this, appId = "sjkeehf4", androidApiKey = "android_sdk-f9955e908e48bf630f3f2a6dc6609c3f4b5aa2b8")
  }
}
