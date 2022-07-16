package com.mobioxy.okta_flutter

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** OktaFlutterPlugin */
class OktaFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    private lateinit var binding: ActivityPluginBinding

    private val oktaService = OktaService()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mobility.okta_flutter")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "createOIDCConfig" -> {
                val config = processBaseConfigArguments(call)
                val configResult = oktaService.createOIDCConfig(context, config)
                if (configResult) {
                    Log.d(oktaService.tag, "OktaService initialized")
                    binding.addActivityResultListener { requestCode, resultCode, data ->
                        oktaService.onActivityResult(requestCode, resultCode, data)
                        true
                    }
                    result.success(true)
                } else {
                    result.success(false)
                }
            }
            "isAuthenticated" -> {
                val isAuthenticated = oktaService.isAuthenticated()
                result.success(isAuthenticated)
            }
            "signIn" -> {
                oktaService.signIn(binding.activity,
                    object : OktaService.OktaResultHandler {
                        override fun onResult(oktaResult: MutableMap<String, Any?>) {
                            result.success(oktaResult)
                        }
                    })
            }
            "signOut" -> {
                oktaService.signOut(binding.activity,
                    object : OktaService.OktaResultHandler {
                        override fun onResult(oktaResult: MutableMap<String, Any?>) {
                            result.success(oktaResult)
                        }
                    })
            }
            "refreshToken" -> {
                oktaService.refreshToken(
                    object : OktaService.OktaResultHandler {
                        override fun onResult(oktaResult: MutableMap<String, Any?>) {
                            result.success(oktaResult)
                        }
                    })
            }
            "getUserProfile" -> {
                oktaService.getUserProfile(
                    object : OktaService.OktaResultHandler {
                        override fun onResult(oktaResult: MutableMap<String, Any?>) {
                            result.success(oktaResult)
                        }
                    })
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun processBaseConfigArguments(call: MethodCall): BaseConfig {
        return BaseConfig(
            clientId = call.argument<String>("clientId") ?: "",
            discoveryUri = call.argument<String>("discoveryUri") ?: "",
            endSessionRedirectUri = call.argument<String>("endSessionRedirectUri") ?: "",
            redirectUri = call.argument<String>("redirectUri") ?: "",
            scopes = call.argument<ArrayList<String>>("scopes")!!,
        )
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.binding = binding
    }

    override fun onDetachedFromActivity() {
    }

}
