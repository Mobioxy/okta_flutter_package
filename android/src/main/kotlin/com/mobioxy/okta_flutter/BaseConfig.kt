package com.mobioxy.okta_flutter

data class BaseConfig(
    var clientId: String,
    var redirectUri: String,
    var endSessionRedirectUri: String,
    var discoveryUri: String,
    var scopes: ArrayList<String>,
)