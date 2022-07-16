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

  Future<void> _signIn() async {
    // var config = OktaConfig(
    //   clientId: 'YOUR CLINET ID',
    //   discoveryUri: 'YOUR DISCOVERY URI',
    //   redirectUri: 'YOUR REDIRECT URI',
    //   endSessionRedirectUri: 'YOUR END SESSION REDIRECT URI',
    //   scopes: ['openid', 'profile', 'email'],
    // );
    var config = OktaConfig(
      clientId: '0oa5r05zy5BV26wcQ5d7',
      discoveryUri: 'https://dev-03370337-admin.okta.com:/oauth2/default',
      redirectUri: 'com.okta.dev-03370337:/callback',
      endSessionRedirectUri: 'com.okta.dev-03370337:/',
      scopes: ['openid', 'profile', 'email'],
    );

    var status = await _okta.createOIDCConfig(config);
    if (status) {
      var result = await _okta.signIn();
      log('SignIn Result: ${result.toString()}');
    }
  }

  Future<void> _signOut() async {
    var result = await _okta.signOut();
    log('SignOut Result: ${result.toString()}');
  }

  Future<void> _refreshToken() async {
    var result = await _okta.signOut();
    log('RefreshToken Result: ${result.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _signIn,
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signOut,
                child: const Text('Sign Out'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _refreshToken,
                child: const Text('Refresh Token'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}