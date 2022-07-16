package com.mobioxy.okta_flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.util.Log
import com.okta.oidc.*
import com.okta.oidc.clients.sessions.SessionClient
import com.okta.oidc.clients.web.WebAuthClient
import com.okta.oidc.storage.SharedPreferenceStorage
import com.okta.oidc.storage.security.DefaultEncryptionManager
import com.okta.oidc.util.AuthorizationException

class OktaService {

    var tag: String = this.javaClass.simpleName

    private var config: OIDCConfig? = null
    private var authClient: WebAuthClient? = null
    private var sessionClient: SessionClient? = null


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
                .create()

            sessionClient = authClient?.sessionClient

            return true
        } catch (e: Exception) {
            Log.d(tag, "OktaService initialization failed: ${e.message}")
            return false
        }
    }

    fun signIn(activity: Activity, oktaResult: OktaResultHandler) {
        val response: MutableMap<String, Any?> = HashMap()

        val payload = AuthenticationPayload.Builder()
            .build()

        authClient?.signIn(activity, payload)
        authClient?.registerCallback(
            object : ResultCallback<AuthorizationStatus, AuthorizationException> {
                override fun onSuccess(result: AuthorizationStatus) {
                    Log.d(tag, "SignIn onSuccess: ${result.name}")

                    val tokens = sessionClient?.tokens

                    val oktaTokens: MutableMap<String, Any?> = HashMap()
                    oktaTokens["idToken"] = tokens?.idToken
                    oktaTokens["accessToken"] = tokens?.accessToken
                    oktaTokens["refreshToken"] = tokens?.refreshToken
                    oktaTokens["expiresIn"] = tokens?.expiresIn

                    response["authorizationStatus"] = result.name
                    response["message"] = "Success"
                    response["tokens"] = oktaTokens
                    oktaResult.onResult(response)
                }

                override fun onCancel() {
                    Log.d(tag, "SignIn onCancel")

                    response["authorizationStatus"] = AuthorizationStatus.CANCELED.name
                    response["message"] = "Cancelled by User"
                    oktaResult.onResult(response)
                }

                override fun onError(msg: String?, exception: AuthorizationException?) {
                    Log.d(tag, "SignIn onError: ${exception?.message}")

                    response["authorizationStatus"] = AuthorizationStatus.ERROR.name
                    response["message"] = "$msg : ${exception?.message}"
                    oktaResult.onResult(response)
                }
            }, activity
        )
    }

    fun signOut(activity: Activity, oktaResult: OktaResultHandler) {
        val response: MutableMap<String, Any?> = HashMap()
        authClient?.signOut(activity, object : RequestCallback<Int, AuthorizationException> {
            override fun onSuccess(result: Int) {
                Log.d(tag, "SignOut onSuccess: $result")

                response["authorizationStatus"] = handleSignOutResult(result)
                response["message"] = "Success"
                oktaResult.onResult(response)
            }

            override fun onError(error: String?, exception: AuthorizationException?) {
                Log.d(tag, "SignOut onError: ${exception?.message}")

                response["authorizationStatus"] = AuthorizationStatus.ERROR.name
                response["message"] = "$error : ${exception?.message}"
                oktaResult.onResult(response)
            }

        }
        )
    }

    fun refreshToken(oktaResult: OktaResultHandler) {

        val response: MutableMap<String, Any?> = HashMap()

        sessionClient?.refreshToken(object : RequestCallback<Tokens, AuthorizationException> {
            override fun onSuccess(result: Tokens) {
                Log.d(tag, "RefreshToken onSuccess: ${result.toString()}")

                val oktaTokens: MutableMap<String, Any?> = HashMap()
                oktaTokens["idToken"] = result.idToken
                oktaTokens["accessToken"] = result.accessToken
                oktaTokens["refreshToken"] = result.refreshToken
                oktaTokens["expiresIn"] = result.expiresIn

                response["authorizationStatus"] = "SUCCESS"
                response["message"] = "Success"
                response["tokens"] = oktaTokens
                oktaResult.onResult(response)
            }

            override fun onError(error: String?, exception: AuthorizationException?) {
                Log.d(tag, "RefreshToken onError: ${exception?.message}")

                response["authorizationStatus"] = AuthorizationStatus.ERROR.name
                response["message"] = "$error : ${exception?.message}"
                oktaResult.onResult(response)
            }
        })
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        authClient?.handleActivityResult(requestCode, resultCode, data)
    }

    private fun handleSignOutResult(result: Int): String {
        return when (result) {
            0x00000000 -> {
                "SUCCESS"
            }
            0x00000001 -> {
                "FAILED_REVOKE_ACCESS_TOKEN"
            }
            0x00000002 -> {
                "FAILED_REVOKE_REFRESH_TOKEN"
            }
            0x00000004 -> {
                "FAILED_CLEAR_DATA"
            }
            0x00000008 -> {
                "FAILED_CLEAR_SESSION"
            }
            else -> AuthorizationStatus.ERROR.name
        }
    }
}