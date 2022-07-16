import 'dart:convert';
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
  //
  bool _isInitialized = false;
  String? _userProfile;
  final OktaFlutter _okta = OktaFlutter.instance;

  Future<void> _signIn() async {
    if (_isInitialized) {
      var result = await _okta.signIn();
      log('SignIn Result: ${result.toString()}');
    }
  }

  Future<void> _signOut() async {
    var result = await _okta.signOut();
    log('SignOut Result: ${result.toString()}');
  }

  Future<void> _refreshToken() async {
    var result = await _okta.refreshToken();
    log('RefreshToken Result: ${result.toString()}');
  }

  Future<void> _getUserProfile() async {
    var user = await _okta.getUserProfile();
    log('UserProfile Result: ${user?.toMap()}');

    setState(() {
      _userProfile = jsonEncode(user?.toMap());
    });
  }

  Future<void> initOktaService() async {
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
    _isInitialized = status;
  }

  @override
  void initState() {
    super.initState();
    initOktaService();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                const SizedBox(height: 20),
                if (_userProfile != null)
                  Text(
                    _userProfile ?? '',
                    textAlign: TextAlign.center,
                  ),
                if (_userProfile != null) const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _getUserProfile,
                  child: const Text('Get User Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
