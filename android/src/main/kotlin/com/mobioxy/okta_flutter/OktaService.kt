package com.mobioxy.okta_flutter

import android.app.Activity
import android.content.Context
import android.util.Log
import com.okta.oidc.*
import com.okta.oidc.clients.web.WebAuthClient
import com.okta.oidc.results.Result
import com.okta.oidc.storage.SharedPreferenceStorage
import com.okta.oidc.storage.security.DefaultEncryptionManager
import com.okta.oidc.util.AuthorizationException


class OktaService {

    private var config: OIDCConfig? = null
    private var authClient: WebAuthClient? = null

    var tag: String = this.javaClass.simpleName

    interface OktaResultHandler {
        fun onResult(oktaResult: MutableMap<String, Any?>)
    }

    fun createOIDCConfig(context: Context, baseConfig: BaseConfig): Boolean {
        try {
            config = OIDCConfig.Builder()
                .clientId(baseConfig.clientId)
                .redirectUri(baseConfig.redirectUri)
                .endSessionRedirectUri(baseConfig.endSessionRedirectUri)
                .scopes(*baseConfig.scopes.toTypedArray())
                .discoveryUri(baseConfig.discoveryUri)
                .create()

            authClient = Okta.WebAuthBuilder()
                .withConfig(config!!)
                .withContext(context)
                .withStorage(SharedPreferenceStorage(context))
                .withEncryptionManager(DefaultEncryptionManager(context))
                .setRequireHardwareBackedKeyStore(false)
                .withCallbackExecutor(null)
                .create();

            return true
        } catch (e: Exception) {
            Log.d(tag, "OktaService initialization Failed: ${e.message}")
            return false
        }
    }

    fun open(activity: Activity, oktaResult: OktaResultHandler) {
        val response: MutableMap<String, Any?> = HashMap()

        try {
            val payload = AuthenticationPayload.Builder()
                .setLoginHint("Login with Okta")
                .build()

            authClient?.signIn(activity, payload)
            authClient?.registerCallback(
                object : ResultCallback<AuthorizationStatus, AuthorizationException> {
                    override fun onSuccess(result: AuthorizationStatus) {
                        Log.d(tag, "onSuccess: ${result.name}")

                        response["authorizationStatus"] = result.name
                        response["message"] = "Success"
                        oktaResult.onResult(response)
                    }

                    override fun onCancel() {
                        Log.d(tag, "onCancel")

                        response["authorizationStatus"] = AuthorizationStatus.CANCELED.name
                        response["message"] = "Cancelled by User"
                        oktaResult.onResult(response)
                    }

                    override fun onError(msg: String?, exception: AuthorizationException?) {
                        Log.d(tag, "onError: $msg")

                        response["authorizationStatus"] = AuthorizationStatus.ERROR.name
                        response["message"] = msg
                        oktaResult.onResult(response)
                    }
                }, activity
            )
        } catch (e: Exception) {
            Log.d(tag, "OktaService Error: ${e.message}")
            response["authorizationStatus"] = AuthorizationStatus.ERROR.name
            response["message"] = e.message
            oktaResult.onResult(response)
        }
    }
}