import 'package:flutter/material.dart';
import 'package:okta_flutter/okta_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //
  bool _isInitialized = false;
  UserProfile? _userProfile;
  final OktaFlutter _okta = OktaFlutter.instance;

  Future<void> _signIn() async {
    if (_isInitialized) {
      var result = await _okta.signIn();
      if (result.status == AuthorizationStatus.authorized) {
        _getUserProfile();
      } else {
        _showSnackBar(result.message ?? 'Unknown error');
      }
    }
  }

  Future<void> _signOut() async {
    var result = await _okta.signOut();
    _showSnackBar(result.message ?? 'Unknown error');
    setState(() {
      _userProfile = null;
    });
  }

  Future<void> _refreshToken() async {
    var result = await _okta.refreshToken();
    _showSnackBar(result.message ?? 'Unknown error');
  }

  Future<void> _getUserProfile() async {
    var userProfile = await _okta.getUserProfile();
    setState(() {
      _userProfile = userProfile;
    });
  }

  Future<void> _initOktaService() async {
    var config = OktaConfig(
      clientId: 'YOUR CLINET ID',
      discoveryUri: 'YOUR DISCOVERY URI',
      redirectUri: 'YOUR REDIRECT URI',
      endSessionRedirectUri: 'YOUR END SESSION REDIRECT URI',
      scopes: ['openid', 'profile', 'email'],
    );

    var status = await _okta.createOIDCConfig(config);
    if (status) {
      setState(() {
        _isInitialized = status;
      });
    } else {
      _showSnackBar('OktaService initialization failed');
    }
  }

  @override
  void initState() {
    super.initState();
    _initOktaService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: _isInitialized
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<bool>(
                future: _okta.isAuthenticated(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var isAuthenticated = snapshot.data ?? false;
                    if (isAuthenticated) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_userProfile != null)
                              Column(
                                children: List.generate(
                                  _userProfile?.toMap().length ?? 0,
                                  (index) {
                                    var detail = _userProfile
                                        ?.toMap()
                                        .entries
                                        .elementAt(index);
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(detail?.key ?? ''),
                                      trailing:
                                          Text(detail?.value.toString() ?? ''),
                                    );
                                  },
                                ),
                              ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _signOut,
                              child: const Text('Sign Out'),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _refreshToken,
                              child: const Text('Refresh Token'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: _signIn,
                            child: const Text('Sign In'),
                          ),
                        ],
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
