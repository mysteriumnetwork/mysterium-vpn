package com.mysteriumvpn.mail_launcher

import android.content.Context
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL = "network.mysterium/mail_launcher"
private const val MAILTO = "mailto:"

// PayPal registers a mailto: handler but is not a mail app. Filter it out
// to match common practice (mirrors what open_mail_app excluded).
private val EXCLUDED_PACKAGES = setOf(
    "com.paypal.android.p2pmobile",
)

class MailLauncherPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "listInstalled" -> result.success(listInstalled())
            "open" -> {
                val id = call.argument<String>("identifier")
                if (id.isNullOrEmpty()) {
                    result.error("INVALID_ARGS", "identifier required", null)
                } else {
                    result.success(open(id))
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun listInstalled(): List<Map<String, String>> {
        val pm = context.packageManager
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(MAILTO))
        return pm.queryIntentActivities(intent, 0)
            .asSequence()
            .map { it.activityInfo.packageName to it.loadLabel(pm).toString() }
            .distinctBy { it.first }
            .filter { it.first !in EXCLUDED_PACKAGES }
            .map { (pkg, label) -> mapOf("identifier" to pkg, "name" to label) }
            .toList()
    }

    private fun open(packageName: String): Boolean {
        val launchIntent = context.packageManager.getLaunchIntentForPackage(packageName) ?: return false
        launchIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        return try {
            context.startActivity(launchIntent)
            true
        } catch (_: Exception) {
            false
        }
    }
}
