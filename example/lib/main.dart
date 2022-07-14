import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:okta_flutter/okta_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final OktaFlutter _okta = OktaFlutter.instance;

  Future<void> _oktaAuthenticationHandler() async {
    var config = OktaConfig(
      clientId: '0oa5r05zy5BV26wcQ5d7',
      discoveryUri: 'https://dev-03370337-admin.okta.com:/oauth2/default',
      redirectUri: 'com.okta.dev-03370337:/callback',
      endSessionRedirectUri: 'com.okta.dev-03370337:/',
      scopes: ['openid', 'profile', 'email'],
    );
    var status = await _okta.createOIDCConfig(config);
    if (status) {
      var result = await _okta.open();
      log('result: ${result.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: _oktaAuthenticationHandler,
            child: const Text('Okta Authentication'),
          ),
        ),
      ),
    );
  }
}
